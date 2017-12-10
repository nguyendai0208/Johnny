//
//  Stepone_customCell.h
//  Cranial Ipad app
//
//  Created by Neil D on 23/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
@interface Cell_home : UITableViewCell
{
 	IBOutlet UILabel *lbl_title;
    IBOutlet UIImageView* imageView;
}
@property(nonatomic,retain)IBOutlet UIImageView* imageView;
@property(nonatomic,retain)IBOutlet UILabel *lbl_title;
@end
