//
//  GalleryVC.h

//
//
//  Copyright (c) 2015 Kapova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "SDWebImageRootViewController.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "MessageTempClass.h"
#import "LBYouTube.h"
#import "MBProgressHUD.h"


@interface GalleryVC : UIViewController
<EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,LBYouTubePlayerControllerDelegate>
{
    NSArray *_photos;
    UINavigationController *nav1;
	EGORefreshTableHeaderView *_refreshHeaderView;
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
    AppDelegate *appdelegate;
    IBOutlet UIBarButtonItem *btn_share;
    MFMailComposeViewController *mailViewController;
    LBYouTubePlayerController* controller;
    MBProgressHUD *hud;
    NSDictionary *galleryNeedVerifier;
}
@property (nonatomic, strong) LBYouTubePlayerController* controller;
@property (nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,readwrite)BOOL alert;
@property (nonatomic, retain) NSArray *photos;
@property (retain, nonatomic) IBOutlet UIImageView *imgview_title;
@property (retain, nonatomic) IBOutlet UIButton *btn_photography;
@property (retain, nonatomic) IBOutlet UILabel *lbl_photography;
@property (retain, nonatomic) IBOutlet UIButton *btn_share1;
@property(strong,retain)NSMutableDictionary *dict_detail;
@property(strong,retain)NSMutableDictionary *video_dict_detail;
@property (nonatomic) BOOL isFromVideo;
@property(strong,retain)IBOutlet UITableView *tableView;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
-(void)get_data_for_gallery;
- (IBAction)btnShareClicked:(id)sender;;
@end
