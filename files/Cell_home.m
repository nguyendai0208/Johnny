//
//  Stepone_customCell.m
//  Cranial Ipad app
//
//  Created by Neil D on 23/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "Cell_home.h"
#import "SettingView.h"

@implementation Cell_home
@synthesize lbl_title;
@synthesize imageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //self.backgroundImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"foo.png"]] autorelease];
      
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    lbl_title.textColor = selected ? [SettingView sharedCache].selectedTextColor: [SettingView sharedCache].textColor;
    // Configure the view for the selected state.
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    NSLog(@"%@", highlighted ? @"YES" : @"NO");
    lbl_title.textColor = highlighted ? [SettingView sharedCache].selectedTextColor: [SettingView sharedCache].textColor;
}

- (void)dealloc
{

    [super dealloc];
}
@end
