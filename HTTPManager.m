
//
//  RootViewController.m
//  Sample
//
//  Created by mac on 28/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "HTTPManager.h"
@implementation HTTPManager

@synthesize connectionDelegate;
@synthesize succeededAction;
@synthesize failedAction;
@synthesize receivedData;

- (id)initWithDelegate:(id)delegate selSucceeded:(SEL)succeeded selFailed:(SEL)failed {
    if ((self = [super init])) {
        self.connectionDelegate = delegate;
        self.succeededAction = succeeded;
        self.failedAction = failed;
    }
    return self;
}
- (BOOL)startRequestForURL:(NSString*)strUrl params:(NSString*)params method:(NSString*)method {
    
    NSURL *url; 
    NSMutableURLRequest* urlRequest;
    // cache & policy stuff here
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    if([method isEqualToString:@"POST"])
    {
        
       url = [NSURL URLWithString:strUrl];
        urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPShouldHandleCookies:YES];
        [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];

        
    }else if([method isEqualToString:@"GET"])
    {
        NSString *tempUrl = [NSString stringWithFormat:@"%@",strUrl];
        
        url = [NSURL URLWithString:tempUrl];

        urlRequest = [NSMutableURLRequest requestWithURL:url];

        
    }
    
    NSURLConnection* connectionResponse = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    if (!connectionResponse)
    {
        // handle error
        return NO;
    } else {
        self.receivedData = [NSMutableData data];
    }
    return YES;
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
    [self.receivedData setLength:0];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    [self.receivedData appendData:data];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    [connectionDelegate performSelector:failedAction withObject:error];
   // [self.receivedData release];
}
- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    [connectionDelegate performSelector:succeededAction withObject:self.receivedData];
}
@end