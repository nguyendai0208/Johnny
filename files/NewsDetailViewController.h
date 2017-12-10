//
//  NewsDetailViewController.h
//  PortfolioApp
//
//  Created by Long Nguyen Vu on 3/5/14.
//  Copyright (c) 2014 cybervation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController
{
    
    IBOutlet UIButton *btnBack;
    IBOutlet UILabel *lbTitle;
    IBOutlet UIImageView *ivThumb;
    IBOutlet UIButton *btnPlayVideo;
    IBOutlet UILabel *lbHeadline;
    IBOutlet UILabel *lbLocation;
    IBOutlet UILabel *lbContent;
    IBOutlet UILabel *lbLink;
    IBOutlet UIButton *btnLink;
    IBOutlet UIScrollView *scrollview;
    IBOutlet UIButton *btnShare;
}

@property(nonatomic, strong) NSDictionary* dictDetail;

- (IBAction)onBackPressed:(id)sender;
- (IBAction)onPlayVideo:(id)sender;
- (IBAction)onOpenLink:(id)sender;
@end
