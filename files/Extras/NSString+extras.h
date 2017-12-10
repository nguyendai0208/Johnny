//
//  NSString+extras.h
//
//  Created by Mobile Developer on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (extras)

-(NSString *)stringWithSubstitute:(NSString *)subs forCharactersFromSet:(NSCharacterSet *)set;
-(NSString *)trimWhiteSpace;
-(NSString *)stripHTML;
-(NSString *)ellipsizeAfterNWords: (int) n;

// Validation for empty/email/url
-(BOOL)isEmptyString;
-(BOOL)isValidEmail;
-(BOOL)isValidURL;

// Common Custom encryption for all platform
-(NSString *)encryptCommonPassword;
-(NSString *)decryptCommonPassword;
-(int)getRandomNumber:(int)from to:(int)to;
-(NSString *)implodeArray:(NSMutableArray *)pArr:(NSString *)pStrGlueString;

// Convert string to URL
-(NSURL*)toURL;
-(NSURL *)toWebURL;

// starts/ends-with compare/escaping/count substring
- (BOOL)startsWithString:(NSString*)otherString;
- (BOOL)endsWithString:(NSString*)otherString;
- (NSComparisonResult)compareCaseInsensitive:(NSString*)other;
- (NSString*)stringByPercentEscapingCharacters:(NSString*)characters;
- (NSString*)stringByEscapingURL;
- (NSString*)stringByUnescapingURL;
- (int)countSubstring:(NSString *)aString ignoringCase:(BOOL)flag;
- (NSString *)getSubstringOfLength:(NSInteger)pIntLength;

// Check String Exists
- (BOOL) containsString:(NSString *)aString;
- (BOOL) containsString:(NSString *)aString ignoringCase:(BOOL)flag;
- (BOOL)containString:(NSString*)pstrStringArray separationBy:(NSString*)pstrSeparation;

// Get Size/Height based on String
-(CGSize)getDynamicHeight:(int)pIntFixWidth andHeight:(int)pIntFixHeight withFontName:(NSString *)pstrFontName andFontSize:(CGFloat)pFontSize;
//-(CGSize)getDynemicHeight:(int)pintFixWidth;
//-(CGSize)getTheStringSize;
//-(CGFloat)getTheStringHeight;

// Date Compare
//-(BOOL)isGreaterToDate:(NSString *)pStrToDate;
//-(CGFloat)getHoursFromDate:(NSString *)pStrDateTime;
//-(int)getDateDifferenceInDays:(NSString *)pstrDate;

// Date Conversion
-(NSString *)convertToDateFormat:(NSString *)pFromDateFormat ToDateFormat:(NSString *)pToDateFormat;

// Trimming
- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingLeadingWhitespaceAndNewlineCharacters;
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters;

+ (NSString*)base64forData:(NSData*)theData;
+(NSString *) encrypt:(NSString *) data;
@end
