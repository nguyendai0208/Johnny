//
//  SDWebImageRootViewController.h
//  Sample
//
//  Created by Kirby Turner on 3/18/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTThumbsViewController.h"
#import "MWPhotoBrowser.h"
@class SDWebImageDataSource;

@interface SDWebImageRootViewController : KTThumbsViewController <MWPhotoBrowserDelegate>
{
    NSString *str_url;
    NSMutableArray *_photos;
@private
    SDWebImageDataSource *images_;   
   UIActivityIndicatorView *activityIndicatorView_;
   UIWindow *window_;
}
@property(nonatomic,retain) NSMutableArray *photos;
@property(nonatomic,retain)NSString *str_url;
@property (retain, nonatomic) IBOutlet UIImageView *imgview_title;
@property (retain, nonatomic) IBOutlet UIButton *btn_photography;
@property (retain, nonatomic) IBOutlet UILabel *lbl_photography;
@end
