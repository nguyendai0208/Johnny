//
//  MoviePlayViewController.h

//
//
//  Copyright (c) Kapova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBYouTube.h"
@interface MoviePlayViewController : UIViewController <LBYouTubePlayerControllerDelegate>
{
    UIWebView *videoView;
    LBYouTubePlayerController* controller;
    NSString *url;
}
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) LBYouTubePlayerController* controller;
@end
