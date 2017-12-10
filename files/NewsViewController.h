//
//  NewsViewController.h
//  PortfolioApp
//
//  Created by Long Nguyen Vu on 3/5/14.
//  Copyright (c) 2014 cybervation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "EGORefreshTableHeaderView.h"

@interface NewsViewController : UIViewController<EGORefreshTableHeaderDelegate>
{
    AppDelegate *appdelegate;
    NSMutableArray* newsData;
    IBOutlet UIImageView *ivLatestNews;
    IBOutlet UIView *viewLatest;
    IBOutlet UILabel *lblLatestNewsLocation;
    IBOutlet UILabel *lbLatestNewsHeadline;
    IBOutlet UITableView *tableview;
    IBOutlet UILabel *lbTitle;
    IBOutlet UIButton *btnBack;
    IBOutlet UIButton *btnShare;
    
    EGORefreshTableHeaderView *refeshTableHeaderView;
}

@property(strong,retain)NSMutableDictionary *dict_detail;

- (IBAction)onBackPressed:(id)sender;
- (IBAction)onOpenLatestNews:(id)sender;
@end
