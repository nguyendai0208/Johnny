//
//  AppDelegate.h

//
//
//  Copyright (c) 2015 Kapova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPManager.h"
#import "Global.h"
#import "GAI.h"
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIWebViewDelegate>
{
    UIView *view;
    UIView *behindview;
    UIWebView *webview;
    NSURL *webviewURL;
    UIButton *closeBtn;
    UIButton *safariBtn;
    UIButton *nextBtn;
    UIButton *PreviousBtn;
    BOOL isLoading;
   }
@property (strong, nonatomic) id<GAITracker> tracker;
@property (nonatomic, strong)NSURL *webviewURL;
@property (nonatomic, strong)UIButton *closeBtn;
@property (nonatomic, strong)UIButton *safariBtn;
@property (nonatomic, strong)UIButton *nextBtn;
@property (nonatomic, strong)UIButton *PreviousBtn;

@property (strong, nonatomic)NSDictionary *dic_data;
@property (strong, nonatomic)NSDictionary *about_us_dic_data;
@property (strong, nonatomic)NSDictionary *maps_dic_data;
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)UINavigationController *navcontroller;
@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic)BOOL isFromIpad;
@property (nonatomic)BOOL isiPhone5;
@property (strong, nonatomic) FBRequestConnection *requestConnection;
- (void)analyticsEvent:(NSString *)event;
- (void)analyticsEvent:(NSString *)event properties:(NSDictionary *)properties;
-(void)sendDataTogoogleAnalytics:(NSString *)screenName;

+ (NSArray *)getArrayNotDisplay;
@end
