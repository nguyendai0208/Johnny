//
//  AboutusVC.h

//
//
//  Copyright (c) Kapova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
@interface TheArtistVC : UIViewController<MFMailComposeViewControllerDelegate>
{
    AppDelegate *appdelegate;
    IBOutlet UILabel *lbl_name;
    IBOutlet UITextView *txt_desc;
    IBOutlet UIButton *btn_email;
    IBOutlet UIButton *btn_phone;
    IBOutlet UIButton *btn_website;
    IBOutlet UIImageView *imgview;
    IBOutlet UIButton *btn_Facebook;
    IBOutlet UIButton *btn_twitter;
    IBOutlet UIButton *btnShare;
}
- (IBAction)btn_facebookClicked:(id)sender;
- (IBAction)btn_twitterClicked:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *imgview_title;
@property (retain, nonatomic) IBOutlet UIButton *btn_photography;
@property (retain, nonatomic) IBOutlet UILabel *lbl_photography;

@end
