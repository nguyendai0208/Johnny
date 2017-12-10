//
//  video_gallery_Cell.h


//  Copyright (c) Kapova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface video_gallery_Cell : UITableViewCell
{
    UILabel *lbl_title;
    UILabel *lbl_date;
    UIImageView* imageView;
    UIImageView *discolore;
    
}
@property(nonatomic,retain) UIImageView *discolore;
@property(nonatomic,retain) UILabel *lbl_date;
@property(nonatomic,retain) UIImageView* imageView;
@property(nonatomic,retain) UILabel *lbl_title;
@end
