//
//  AboutusVC.h

//
//
//  Copyright (c) 2015 Kapova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
@interface AboutusVC : UIViewController<MFMailComposeViewControllerDelegate>
{
    AppDelegate *appdelegate;
    IBOutlet UILabel *lbl_name;
    IBOutlet UITextView *txt_desc;
    IBOutlet UIButton *btn_email;
    IBOutlet UIButton *btn_phone;
    IBOutlet UIButton *btn_website;
}
@property (retain, nonatomic) IBOutlet UIImageView *imgview_title;
@property (retain, nonatomic) IBOutlet UIButton *btn_photography;
@property (retain, nonatomic) IBOutlet UILabel *lbl_photography;


@end
