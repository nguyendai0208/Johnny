//
//  MessageTempClass.h
//  RadioListner
//
//  Created by Raghav on 07/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>


@interface MessageTempClass : UIViewController <MFMessageComposeViewControllerDelegate>{

	NSString *message;
	MFMessageComposeViewController *picker;
	id classreference;
}
@property (nonatomic,retain)NSString *message;
@property (nonatomic,retain)id classreference;
@end
