//
//  video_gallery_Cell.m

//

//  Copyright (c) Kapova. All rights reserved.
//

#import "video_gallery_Cell.h"
#import "SettingView.h"

@implementation video_gallery_Cell
@synthesize lbl_date;
@synthesize lbl_title;
@synthesize imageView;
@synthesize discolore;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
        self.backgroundColor = [SettingView sharedCache].appBackgroundColor;
        self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(16, 14, 60, 52)];
       
        [self.contentView addSubview:self.imageView];
        
        self.lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(92, 16, 190, 50)];
        self.lbl_title.textAlignment=NSTextAlignmentLeft;
        self.lbl_title.textColor=[UIColor whiteColor];
        self.lbl_title.backgroundColor=[UIColor clearColor];
        //self.lbl_title.font=[UIFont boldSystemFontOfSize:17.0];
        //Font
        self.lbl_title.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        self.lbl_title.numberOfLines=2;
        self.lbl_title.lineBreakMode=NSLineBreakByTruncatingTail;
        
        [self.contentView addSubview: self.lbl_title];
        
        self.lbl_date=[[UILabel alloc]initWithFrame:CGRectMake(92, 48, 220, 25)];
        self.lbl_date.textAlignment=NSTextAlignmentLeft;
        self.lbl_date.textColor=[UIColor whiteColor];
        self.lbl_date.backgroundColor=[UIColor clearColor];
        //self.lbl_date.font=[UIFont boldSystemFontOfSize:12.0];
        //Font
        self.lbl_date.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:12];
        [self.contentView addSubview: self.lbl_date];
        
        self.discolore=[[UIImageView alloc]initWithFrame:CGRectMake(294, 33, 10, 13)];
        [self.discolore setImage:[UIImage imageNamed:@"arrow.png"]];
        [self.contentView addSubview:self.discolore];
        
        }
        else{
            self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 20, 84, 72)];
            
            [self.contentView addSubview:self.imageView];
            
            self.lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(142, 14, 584, 55)];
            self.lbl_title.textAlignment=NSTextAlignmentLeft;
            self.lbl_title.textColor=[UIColor whiteColor];
            self.lbl_title.backgroundColor=[UIColor clearColor];
            //self.lbl_title.font=[UIFont boldSystemFontOfSize:34.0];
            //Font
            self.lbl_title.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:34];
            self.lbl_title.numberOfLines=1;
            self.lbl_title.lineBreakMode=NSLineBreakByTruncatingTail;
            
            [self.contentView addSubview: self.lbl_title];
            
            self.lbl_date=[[UILabel alloc]initWithFrame:CGRectMake(132, 71, 614, 25)];
            self.lbl_date.textAlignment=NSTextAlignmentLeft;
            self.lbl_date.textColor=[UIColor whiteColor];
            self.lbl_date.backgroundColor=[UIColor clearColor];
            //self.lbl_date.font=[UIFont boldSystemFontOfSize:20.0];
            //Font
            self.lbl_date.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:20];
            [self.contentView addSubview: self.lbl_date];
            
            self.discolore=[[UIImageView alloc]initWithFrame:CGRectMake(715, 41, 25, 30)];
            [self.discolore setImage:[UIImage imageNamed:@"arrow_ipad.png"]];
            [self.contentView addSubview:self.discolore];
        }
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
