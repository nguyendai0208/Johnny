//
//  RootViewController.h
//  Sample
//
//  Created by mac on 28/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


@interface HTTPManager : NSObject {
    NSMutableData* receivedData;
}
@property (nonatomic, retain) NSMutableData* receivedData;
@property (nonatomic, retain) id connectionDelegate;
@property (nonatomic) SEL succeededAction;
@property (nonatomic) SEL failedAction;
- (id)initWithDelegate:(id)delegate selSucceeded:(SEL)succeeded selFailed:(SEL)failed;
- (BOOL)startRequestForURL:(NSString*)strUrl params:(NSString*)params method:(NSString*)method;

@end