//
//  NSString+extras.m
//  iPhoneBasicStructure
//
//  Created by Mobile Developer on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+extras.h"
#include <CommonCrypto/CommonCryptor.h>
@implementation NSString (extras)

- (NSString *)stringWithSubstitute:(NSString *)subs forCharactersFromSet:(NSCharacterSet *)set
{
	NSRange r = [self rangeOfCharacterFromSet:set];
	if (r.location == NSNotFound) return self;
	NSMutableString *newString = [self mutableCopy];
	do
	{
		[newString replaceCharactersInRange:r withString:subs];
		r = [newString rangeOfCharacterFromSet:set];
	}
	while (r.location != NSNotFound);
	return [newString autorelease];
}

- (NSString *) trimWhiteSpace 
{
	NSMutableString *s = [[self mutableCopy] autorelease];
	CFStringTrimWhitespace ((CFMutableStringRef) s);
	return (NSString *) [[s copy] autorelease];
} /*trimWhiteSpace*/

-(NSString *)ellipsizeAfterNWords: (NSInteger) n 
{	
	NSArray *stringComponents = [self componentsSeparatedByString: @" "];
	NSMutableArray *componentsCopy = [stringComponents mutableCopy];
	NSInteger ix = n;
	NSInteger len = [componentsCopy count];
	if (len < n)
		ix = len;
	[componentsCopy removeObjectsInRange: NSMakeRange (ix, len - ix)];
	return [componentsCopy componentsJoinedByString: @" "];
} /*ellipsizeAfterNWords*/

-(NSString *)stripHTML 
{	
	NSUInteger len = [self length];
	NSMutableString *s = [NSMutableString stringWithCapacity: len];
	NSUInteger i = 0, level = 0;
	
	for (i = 0; i < len; i++) {
		
		NSString *ch = [self substringWithRange: NSMakeRange (i, 1)];
		
		if ([ch isEqualToString: @"<"])
			level++;
		
		else if ([ch isEqualToString: @">"]) {
			
			level--;
			
			if (level == 0)			
				[s appendString: @" "];
		} /*else if*/
		
		else if (level == 0)			
			[s appendString: ch];
	} /*for*/
	
	return (NSString *) [[s copy] autorelease];
} /*stripHTML*/

#pragma mark -
#pragma mark Validation empty/email/url

- (BOOL)isEmptyString
{	
	NSString *copy;
	
	if (self == nil)
		return (YES);
	
	if ([self isEqualToString:@""])
		return (YES);
	
	if ([self isEqualToString:@"(null)"])
		return (YES);
	
	copy = [[self copy] autorelease];
	
	if ([[copy trimWhiteSpace] isEqualToString: @""])
		return (YES);
	
	return (NO);
} /*stringIsEmpty*/

-(BOOL)isValidEmail
{
	BOOL stricterFilter = YES; 
	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,4}";
	NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:self];
}

-(BOOL)isValidURL
{
	BOOL isValidURL = NO;	
	NSURL *candidateURL = [NSURL URLWithString:self];
	if (candidateURL && candidateURL.scheme && candidateURL.host)
		isValidURL = YES;
	return isValidURL;
}
/*- (BOOL) isValidURL
{
    NSString *urlRegEx =
    //@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    @"((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
    return [urlTest evaluateWithObject:self];
}*/

#pragma mark -
#pragma mark Encryption

-(NSString *)encryptCommonPassword
{
	int intLength = [self length];
	int randKey = [self getRandomNumber:1 to:9];
	int i = 0;
	NSMutableArray *arr = [[NSMutableArray alloc]init];
	while (i < intLength) 
	{
		unichar c = [self characterAtIndex:i];
		
		int j = (int)c;
		//NSLog(@"%C and %d",c,j);
		NSString *ascval = [NSString stringWithFormat:@"%d",j-randKey];
		[arr addObject:ascval];
		i++;
	}
	
	NSString *retString = [self implodeArray:arr :@"."];
	NSString *string = [NSString stringWithFormat:@"%d", randKey];
	char c = [string characterAtIndex:0];	
	int j = (int)c;
	retString = [NSString stringWithFormat:@"%@.%d",retString,j+50];
	//NSLog(@"Encrypted Password = %@",retString);
	//[self decryptPassword:retString];
	return retString;
}

-(NSString *)decryptCommonPassword
{
	NSArray *arr = [self componentsSeparatedByString:@"."];
	int lastVal = [arr count] - 1;
	NSString *last = [arr objectAtIndex:lastVal];
	int intLast = [last intValue];
	intLast = intLast - 50;
	
	NSString *str = [NSString stringWithFormat:@"%c",intLast];
	unichar c = [str characterAtIndex:0];
	
	NSString *string = [NSString stringWithFormat:@"%c", c];
	int randKey = [string intValue];
	int i = 0;
	
	NSString *strFinal = @"";
	while (i < [arr count] - 1)
	{
		int ccc = [[arr objectAtIndex:i]intValue] + randKey;
		NSString *str = [NSString stringWithFormat:@"%d",ccc];
		unichar c = [str characterAtIndex:0];
		strFinal  = [strFinal stringByAppendingString:[NSString stringWithFormat:@"%C",c]];
		i++;
	}
	return strFinal; 
}

-(int)getRandomNumber:(int)from to:(int)to 
{
	return (int)from + arc4random() % (to-from+1);
}

-(NSString *)implodeArray:(NSMutableArray *)pArr:(NSString *)pStrGlueString
{
	NSString *strOutput = @"";
	if ([pArr count] > 0)
	{
		NSString *str = @"";
		str = [str stringByAppendingString:[pArr objectAtIndex:0]];
		for (int i =1 ; i < [pArr count]; i++) {
			str = [str stringByAppendingString:pStrGlueString];
			str = [str stringByAppendingString:[pArr objectAtIndex:i]];
		}
		strOutput = str;
	}
	return strOutput;
}

#pragma mark -
#pragma mark Convert string url to NSURL

-(NSURL*)toURL
{
	return [NSURL URLWithString:self];
}

-(NSURL *)toWebURL
{
	NSURL *webURL = nil;
	if([self hasPrefix:@"http"])
		webURL = [NSURL URLWithString:self];
	else 
		webURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self]];
	
	return webURL;
}

#pragma mark -
#pragma mark starts/ends-with compare/escaping/count substring

-(BOOL)startsWithString:(NSString*)otherString 
{
    return [self rangeOfString:otherString].location == 0;
}

-(BOOL)endsWithString:(NSString*)otherString 
{
    return [self rangeOfString:otherString].location == [self length]-[otherString length];
}

-(NSComparisonResult)compareCaseInsensitive:(NSString*)other 
{
    NSString *selfString = [self lowercaseString];
    NSString *otherString = [other lowercaseString];	
    return [selfString compare:otherString];
}

- (NSString*)stringByPercentEscapingCharacters:(NSString*)characters {
    return [(NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)characters, kCFStringEncodingUTF8) autorelease];
}

- (NSString*)stringByEscapingURL {
    //may be you would like to add '?' in escape seq.
    return [self stringByPercentEscapingCharacters:@";/:?@&=+$,"];
}

- (NSString*)stringByUnescapingURL {
    return [(NSString*)CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)self, CFSTR("")) autorelease];
}

- (int)countSubstring:(NSString *)aString ignoringCase:(BOOL)flag {
    unsigned mask = (flag ? NSCaseInsensitiveSearch : 0);
    return [self rangeOfString:aString options:mask].length;
}

- (NSString *)getSubstringOfLength:(NSInteger)pIntLength
{
	if([self length] > pIntLength)
		return [self substringToIndex:pIntLength];
	else
		return self;
}

#pragma mark -
#pragma mark Check String Exists

- (BOOL)containsString:(NSString *)aString {
    return [self containsString:aString ignoringCase:NO];
}

- (BOOL)containsString:(NSString *)aString ignoringCase:(BOOL)flag {
    unsigned mask = (flag ? NSCaseInsensitiveSearch : 0);
    return [self rangeOfString:aString options:mask].length > 0;
}

- (BOOL)containString:(NSString*)pstrStringArray separationBy:(NSString*)pstrSeparation
{
	//pstrStringArray will be comma(',') array
	NSArray *arrayContainsData = [pstrStringArray componentsSeparatedByString:pstrSeparation];
	
	BOOL bolContains = FALSE;
	for(int i=0;i<[arrayContainsData count];i++){
		NSString *strCheckString = [arrayContainsData objectAtIndex:i];
		
		if (!([self rangeOfString:strCheckString options:NSCaseInsensitiveSearch].location == NSNotFound)){
			//NSLog(@"Found");
			bolContains = TRUE;
			break;
		}
		else{
			//NSLog(@"Not Found");
			bolContains = FALSE;
		}
	}
	
	return bolContains;
}

#pragma mark -
#pragma mark Get Size/Height based on String

-(CGSize)getDynamicHeight:(int)pIntFixWidth andHeight:(int)pIntFixHeight withFontName:(NSString *)pstrFontName andFontSize:(CGFloat)pFontSize
{
	CGSize maximumSize=CGSizeMake(pIntFixWidth, pIntFixHeight);
	UIFont *myFont = [UIFont fontWithName:pstrFontName size:pFontSize];
	CGSize sizeS = [self sizeWithFont:myFont constrainedToSize:maximumSize lineBreakMode:UILineBreakModeWordWrap];
	sizeS.height=sizeS.height+39;
	return sizeS;
}

/*-(CGSize)getDynemicHeight:(int)pintFixWidth
{
	CGSize maximumSize=CGSizeMake(pintFixWidth, g_Max_Width);
	UIFont *myFont = [UIFont fontWithName:g_Default_Font_Name size:g_Default_Font_Size];// font used for label
	myFont=[UIFont boldSystemFontOfSize:g_Default_Font_Size];
	
	CGSize sizeS = [self sizeWithFont:myFont 
					   constrainedToSize:maximumSize 
						   lineBreakMode:UILineBreakModeWordWrap];
	
	sizeS.height=sizeS.height+39;
	
	return sizeS;
}

-(CGSize)getTheStringSize
{
//	NSString *trimmedString = [self stringByTrimmingCharactersInSet:
							   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *trimmedString = [self trimWhiteSpace];
	NSString *text = trimmedString;
	CGSize constraint = CGSizeMake(g_CELL_CONTENT_WIDTH - (g_CELL_CONTENT_MARGIN * 5), 10.0f);
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:g_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	return size;
}

-(CGFloat)getTheStringHeight{
	//NSString *trimmedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *trimmedString = [self trimWhiteSpace];
	NSString *text = trimmedString;
	CGSize constraint = CGSizeMake(g_CELL_CONTENT_WIDTH - (g_CELL_CONTENT_MARGIN * 5), 10.0f);
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:g_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	CGFloat height = MAX(size.height, 44.0f);
	return height;
}

#pragma mark -
#pragma mark Date functions

-(BOOL)isGreaterToDate:(NSString *)pStrToDate
{
	BOOL boolISGreater=NO;
	NSDate *dateFrom = [ClsHelper getDateFromString:self withFormat:g_DisplayFormat];
	NSDate *dateTo = [ClsHelper getDateFromString:pStrToDate withFormat:g_DisplayFormat];
	NSComparisonResult result = [dateFrom compare:dateTo];
	if(result==NSOrderedDescending)
		boolISGreater = YES;
	return boolISGreater;
}

-(CGFloat)getHoursFromDate:(NSString *)pStrDateTime
{	
	NSDate *date = [ClsHelper getDateFromString:pStrDateTime withFormat:g_DisplayFormat];	
	double dtDiffInHours = [[NSDate date] timeIntervalSinceDate:date]/3600;
	NSLog(@"Hours Difference ==> %f",dtDiffInHours);
	return dtDiffInHours;
}

-(int)getDateDifferenceInDays:(NSString *)pstrDate
{
	//NSString *strDateDifference = @"";
	NSDateFormatter *df1 = [[[NSDateFormatter alloc] init] autorelease];
    [df1 setDateFormat:g_DisplayFormat];
    NSDate *dtDate1 = [df1 dateFromString:self];
	NSDateFormatter *df2 = [[[NSDateFormatter alloc] init] autorelease];
    [df2 setDateFormat:g_DisplayFormat];
    NSDate *dtDate2 = [df2 dateFromString:pstrDate];
	//NSLog(@"Post Date=%@",dtPostDate);
	//NSLog(@"Curr Date=%@",dtCurrDate);
	NSTimeInterval secondsBetween = [dtDate2 timeIntervalSinceDate:dtDate1];
	int numberOfDays = secondsBetween / 86400;
	//NSLog(@"There are %d days in between the two dates.", numberOfDays);
	return numberOfDays;*/
	/*if(numberOfDays > 0){
		//For Days
		if(numberOfDays==1){
			strDateDifference = [NSString stringWithFormat:@"About %d day ago", numberOfDays];
		}
		else if(numberOfDays<30){
			strDateDifference = [NSString stringWithFormat:@"About %d days ago", numberOfDays];
		}
		else {
			//For Months
			int numberOfMonths = numberOfDays / 30;
			if(numberOfMonths==1){
				strDateDifference = [NSString stringWithFormat:@"About %d month ago", numberOfMonths];
			}
			else {
				strDateDifference = [NSString stringWithFormat:@"About %d months ago", numberOfMonths];
			}
		}
	}
	else {
		int numberOfHours = secondsBetween / 3600;
		
		if(numberOfHours>0){
			//For Hours
			if(numberOfHours==1){
				strDateDifference = [NSString stringWithFormat:@"About %d hour ago", numberOfHours];
			}
			else {
				strDateDifference = [NSString stringWithFormat:@"About %d hours ago", numberOfHours];
			}
		}
		else {
			//For Minutes
			int numberOfMinutes = secondsBetween / 60;
			if(numberOfMinutes==1){
				strDateDifference = [NSString stringWithFormat:@"About %d minute ago", numberOfMinutes];
			}
			else {
				strDateDifference = [NSString stringWithFormat:@"About %d minutes ago", numberOfMinutes];
			}
		}
	}
	
	strDateDifference = [strDateDifference stringByAppendingString:@" via facebook"];
	
	return strDateDifference;*/
//}

#pragma mark -
#pragma mark Format Conversion

-(NSString *)convertToDateFormat:(NSString *)pFromDateFormat ToDateFormat:(NSString *)pToDateFormat
{
	NSDateFormatter *dtFormatter = [[[NSDateFormatter alloc]init] autorelease];
	[dtFormatter setDateFormat:pFromDateFormat];
	NSDate *date = [dtFormatter dateFromString:self];
	[dtFormatter setDateFormat:pToDateFormat];
	return [dtFormatter stringFromDate:date];
}

#pragma mark -
#pragma mark Format Conversion

- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet {
    NSRange rangeOfFirstWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]];
    if (rangeOfFirstWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringFromIndex:rangeOfFirstWantedCharacter.location];
}

- (NSString *)stringByTrimmingLeadingWhitespaceAndNewlineCharacters {
    return [self stringByTrimmingLeadingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet
{
    NSRange rangeOfLastWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]options:NSBackwardsSearch];
    if (rangeOfLastWantedCharacter.location == NSNotFound)
    {
        return @"";
    }
    return [self substringToIndex:rangeOfLastWantedCharacter.location+1]; // non-inclusive
}

- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters
{
    return [self stringByTrimmingTrailingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString*)base64forData:(NSData*)theData
{
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

+(NSString *) encrypt:(NSString *) data
{
    
    const void *vplainText;
    size_t plainTextBufferSize = [data length];
    vplainText = (const void *) [data UTF8String];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    Byte iv [] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xab, 0xcd, 0xef};
    
    NSString *key = @"complexkey";
    const void *vkey = (const void *) [key UTF8String];
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySizeDES,
                       iv,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result;
    result= [NSString base64forData:myData];
    // url encode the result
    return ( NSString *) CFURLCreateStringByAddingPercentEscapes(NULL,( CFStringRef) result,NULL,(CFStringRef) @"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
}
@end
