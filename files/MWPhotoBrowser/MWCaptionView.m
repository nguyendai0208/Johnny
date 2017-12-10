//
//  MWCaptionView.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 30/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MWCaptionView.h"
#import "MWPhoto.h"
#import "AppDelegate.h"
static const CGFloat labelPadding = 10;

// Private
@interface MWCaptionView () {
    id<MWPhoto> _photo;
    UILabel *_label;    
}
@end

@implementation MWCaptionView

- (id)initWithPhoto:(id<MWPhoto>)photo {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)]; // Random initial frame
    if (self) {
        _photo = [photo retain];
//        self.opaque = NO;
//        self.backgroundColor = [UIColor clearColor];

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        
        
        
        [self setupCaption];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat maxHeight = 9999;
    if (_label.numberOfLines > 0) maxHeight = _label.font.leading*_label.numberOfLines;
    CGSize textSize = [_label.text sizeWithFont:_label.font 
                              constrainedToSize:CGSizeMake(size.width - labelPadding*2, maxHeight)
                                  lineBreakMode:_label.lineBreakMode];
    if (IS_IPAD) {
        return CGSizeMake(size.width, ((textSize.height + labelPadding * 2) > 88) ? (textSize.height + labelPadding * 2) : 88);
    }
    return CGSizeMake(size.width, ((textSize.height + labelPadding * 2) > 44) ? (textSize.height + labelPadding * 2) : 44);
}
- (void)setupCaption
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(labelPadding, 0, 
                                                       self.bounds.size.width-labelPadding*2,
                                                       self.bounds.size.height)];
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    _label.opaque = NO;
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = UITextAlignmentCenter;
    _label.lineBreakMode = UILineBreakModeWordWrap;
    _label.numberOfLines = 3;
    _label.textColor = [SettingView sharedCache].textColor;
    //_label.font = [UIFont systemFontOfSize:17];
    //Font
    _label.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
    if ([_photo respondsToSelector:@selector(caption)]) {
        _label.text = [_photo caption] ? [_photo caption] : @" ";
    }
    AppDelegate *appdel=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appdel sendDataTogoogleAnalytics:[NSString stringWithFormat:@"%@ %@",_label.text,DetailPhotoview]];
    
    [self addSubview:_label];

}
-(void)addBackgroundImage {
    UIImageView* ivBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slideSHOW_titlebar_bk"]];
    ivBg.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    NSLog(@"caption: %@", NSStringFromCGRect(ivBg.frame));
    [self addSubview:ivBg];
    [self bringSubviewToFront:_label];
}
- (void)dealloc
{
    [_label release];
    [_photo release];
    [super dealloc];
}

@end
