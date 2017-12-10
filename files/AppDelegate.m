//
//  AppDelegate.m

//
//
//  Copyright (c) 2015 Kapova. All rights reserved.
//

#import "AppDelegate.h"
#import "Global.h"
#import "ViewController.h"
#import "LocalyticsSession.h"
#import "HTTPManager.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include "SDImageCache.h"

static NSString *const kAllowTracking = @"allowTracking";
//static NSString *const kGaPropertyId = @"UA-44386207-1"; // Placeholder property ID.
//static NSString *const kTrackingPreferenceKey = @"allowTracking";
static BOOL const kGaDryRun = NO;
static int const kGaDispatchPeriod = 0;

@implementation UINavigationBar (UINavigationBarCategory)

- (void)drawRect:(CGRect)rect {
    UIImage *img = [UIImage imageNamed:@"under_photographerName.png"];
    [img drawInRect:rect];
}

@end

@implementation AppDelegate
@synthesize  isFromIpad;
@synthesize isiPhone5;
@synthesize  requestConnection;;
@synthesize about_us_dic_data;
@synthesize safariBtn;
@synthesize nextBtn;
@synthesize PreviousBtn;
@synthesize closeBtn;
@synthesize webviewURL;
@synthesize maps_dic_data;
@synthesize tracker;
- (void)dealloc
{
    [_window release];
    [_navcontroller release];
    [_viewController release];
    [_dic_data release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
//    [imageCache clearDisk];
    
    [self intializeValues];
    if([SettingView sharedCache].isPusNotification==YES)
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    [[LocalyticsSession sharedLocalyticsSession] startSession:@"c77f228ffd18024863343e5-e2976e30-8c1a-11e2-340a-008e703cf207"];
    
    
    // Google anlytics
    
    [self initializeGoogleAnalytics];
  
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
     [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Data"]isKindOfClass:[NSDictionary class] ])
    {
        self.dic_data=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:@"Data"]];
    }
    else
    {
        //NSLog(@"don't have any previously loaded content");
    }
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"about_us_Data"]isKindOfClass:[NSDictionary class] ])
    {
        self.about_us_dic_data=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:@"about_us_Data"]];
    }
    else
    {
        //NSLog(@"don't have any previously loaded content");
    }
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"maps"]isKindOfClass:[NSDictionary class] ])
    {
        self.maps_dic_data=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:@"maps"]];
    }
    else
    {
        //NSLog(@"don't have any previously loaded content");
    }

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if([UIScreen mainScreen].bounds.size.height>480)
        {
            isiPhone5=YES;
        }
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
    }
   
    self.navcontroller=[[UINavigationController alloc]initWithRootViewController:self.viewController];
    [self.navcontroller setNavigationBarHidden:YES];
    self.navcontroller.navigationBar.barStyle = UIBarStyleBlack;
    self.navcontroller.navigationBar.translucent = YES;
    self.window.rootViewController = self.navcontroller;
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Application opened"];
    [self.window makeKeyAndVisible];
    
    if(launchOptions)
    {

        [self performSelector:@selector(InitializeWebView) withObject:nil afterDelay:1.0];
        
    }
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"categoryHeader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)] forBarMetrics:UIBarMetricsDefault];

    
    
    return YES;
}
- (void)initializeGoogleAnalytics
{
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    // User must be able to opt out of tracking
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    [[GAI sharedInstance] setDispatchInterval:kGaDispatchPeriod];
    [[GAI sharedInstance] setDryRun:kGaDryRun];
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:GoogleAnalyticsTrackID];
}
-(void)sendDataTogoogleAnalytics:(NSString *)screenName
{
    /*
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:screenName
                                                      forKey:kGAIScreenName] build]];
     [[GAI sharedInstance] dispatch];*/
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                            action:@"Buttton"
                                             label:screenName
                                             value:nil] build];
    [[GAI sharedInstance].defaultTracker send:event];
    [[GAI sharedInstance] dispatch];
}
-(void)removeNotifications
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    HTTPManager *objHTTPManager = [[HTTPManager alloc] initWithDelegate:self                                                                               selSucceeded:@selector(ConnectionResponseSucceed:) selFailed:@selector(connectionResponseFailed:)];
    NSString *macaddress=[self GetMacAddrress];
    macaddress=[macaddress stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *url=[NSString stringWithFormat:@"http://kapova.net/",macaddress ];
    
    [objHTTPManager startRequestForURL:url params:nil method:@"GET"];
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [[token componentsSeparatedByString:@" "] componentsJoinedByString:@""];
    NSLog(@"My token is: %@", token);
    HTTPManager *objHTTPManager = [[HTTPManager alloc] initWithDelegate:self                                                                               selSucceeded:@selector(ConnectionResponseSucceed:) selFailed:@selector(connectionResponseFailed:)];
    NSString *macaddress=[self GetMacAddrress];
    macaddress=[macaddress stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *url=[NSString stringWithFormat:@"http://kapova.net/",token,macaddress ];
    
    [objHTTPManager startRequestForURL:url params:nil method:@"GET"];
    //    NSURL *url = [NSURL URLWithString:@"http://www.Kapova.net"];
    //    NSURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
    //
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
     [self performSelector:@selector(InitializeWebView) withObject:nil afterDelay:1.0];
}
#pragma mark Webview Methods

-(void) InitializeWebView
{
    
    webview=[[[UIWebView alloc]init]autorelease];
    CGRect viewframe=self.navcontroller.view.bounds;
    behindview=[[[UIView alloc]initWithFrame:CGRectMake(viewframe.origin.x, viewframe.origin.y,viewframe.size.width, viewframe.size.height+115)]autorelease];
    behindview.backgroundColor=[UIColor darkGrayColor];
    
    view=[[[UIView alloc]initWithFrame:CGRectMake(viewframe.origin.x, viewframe.origin.y,viewframe.size.width, viewframe.size.height+50)]autorelease];
    view.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleTopMargin;
    webview.frame=CGRectMake(view.frame.origin.x,view.frame.origin.y+44,view.frame.size.width, view.frame.size.height-95);
    webview.autoresizingMask=  UIViewAutoresizingFlexibleBottomMargin ;
    webview.delegate=self;
    
    UIView *closebuttonview=[[[UIView alloc]initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 45)]autorelease];
    
    UIColor *color = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"webViewHeader"]];
    closebuttonview.backgroundColor = color;
    [color release];
    
    closebuttonview.backgroundColor=[[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"webViewHeader"]]autorelease];
    //[closebuttonview setBackgroundColor:[UIColor blackColor]];
    
    [view addSubview:webview];
    [view addSubview:closebuttonview];
    [webview setBackgroundColor:[UIColor clearColor]];
    [webview setClipsToBounds:YES];
    [behindview addSubview:view];
    
    
    
    CGRect finalFrame = behindview.frame;
    [behindview setFrame:CGRectMake(0, self.navcontroller.view.frame.size.height, self.navcontroller.view.frame.size.width, self.navcontroller.view.frame.size.height)];
    [UIView animateWithDuration:0.3 animations:^{
        //        [self.navigationController setNavigationBarHidden:YES];
        [self.window addSubview:behindview];
        [behindview setFrame:finalFrame];
    }];
    
    
    self.closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(CloseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn.frame=CGRectMake(closebuttonview.frame.origin.x+12, 12, 23, 23);
    
    self.safariBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.safariBtn setImage:[UIImage imageNamed:@"safari"] forState:UIControlStateNormal];
    [self.safariBtn addTarget:self action:@selector(SafariClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.safariBtn.frame=CGRectMake(closebuttonview.frame.origin.x+60, 12,23,23);
    
    self.PreviousBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.PreviousBtn setImage:[UIImage imageNamed:@"back_active"] forState:UIControlStateNormal];
    [self.PreviousBtn addTarget:self action:@selector(goBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.PreviousBtn.frame=CGRectMake(closebuttonview.frame.size.width-60, 12, 23, 23);
    
    self.nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [ self.nextBtn setImage:[UIImage imageNamed:@"forword_active"] forState:UIControlStateNormal];
    [ self.nextBtn addTarget:self action:@selector(goNextClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn.frame=CGRectMake(closebuttonview.frame.size.width-30, 12, 23, 23);
    //    [[closebuttonview layer] setCornerRadius:5];
    [closebuttonview setClipsToBounds:YES];
    //[closebuttonview setBackgroundColor:[UIColor colorWithRed:28.0/255 green:238.0/255 blue:238.0/255 alpha:1]];
//    [closebuttonview addSubview:self.nextBtn];
//    [closebuttonview addSubview:self.PreviousBtn];
//    [closebuttonview addSubview:self.safariBtn];
    [closebuttonview addSubview:self.closeBtn];
    NSURLRequest *request = nil ;
    request=  [NSURLRequest requestWithURL:[NSURL URLWithString:webViewURL]];
    self.webviewURL=request.URL;
    [webview loadRequest:request];
     [self removeNotifications];
    //    [closebuttonview bringSubviewToFront:button];
    
}
-(void)CloseButtonClicked:(id)sender
{
    //    webview=nil;
    //    behindview=nil;
    CGRect finalFrame =CGRectMake(0, self.navcontroller.view.frame.size.height+110, self.navcontroller.view.frame.size.width, self.navcontroller.view.frame.size.height) ;
    [behindview setFrame:behindview.frame];
    [UIView animateWithDuration:0.3 animations:^{
        [behindview setFrame:finalFrame];
        
    }];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
//    if(isLoading==NO)
//    {
//        loadingView = [PoeniCriticsDAO allocGetLoadingScreen];
//        [webview addSubview:loadingView];
//    }
//    isLoading=YES;
    [self UpdateToolbar];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    self.webviewURL=webView.request.URL;
//    [loadingView removeFromSuperview];
//    isLoading=NO;
    [self UpdateToolbar];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self UpdateToolbar];
}
-(void)UpdateToolbar
{
    self.PreviousBtn.enabled=webview.canGoBack;
    self.nextBtn.enabled=webview.canGoForward;
}
-(void)SafariClicked:(id)sender
{
    [[UIApplication sharedApplication]openURL:self.webviewURL];
}
-(void)goBackClicked:(id)sender
{
    [webview goBack];
}
-(void)goNextClicked:(id)sender
{
    [webview goForward];
}
-(NSString *) GetMacAddrress
{

    
        int                 mgmtInfoBase[6];
        char                *msgBuffer = NULL;
        size_t              length;
        unsigned char       macAddress[6];
        struct if_msghdr    *interfaceMsgStruct;
        struct sockaddr_dl  *socketStruct;
        NSString            *errorFlag = NULL;
        
        // Setup the management Information Base (mib)
        mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
        mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
        mgmtInfoBase[2] = 0;
        mgmtInfoBase[3] = AF_LINK;        // Request link layer information
        mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
        
        // With all configured interfaces requested, get handle index
        if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
            errorFlag = @"if_nametoindex failure";
        else
        {
            // Get the size of the data available (store in len)
            if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
                errorFlag = @"sysctl mgmtInfoBase failure";
            else
            {
                // Alloc memory based on above call
                if ((msgBuffer = malloc(length)) == NULL)
                    errorFlag = @"buffer allocation failure";
                else
                {
                    // Get system information, store in buffer
                    if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                        errorFlag = @"sysctl msgBuffer failure";
                }
            }
        }
        
        // Befor going any further...
        if (errorFlag != NULL)
        {
            NSLog(@"Error: %@", errorFlag);
            return errorFlag;
        }
        
        // Map msgbuffer to interface message structure
        interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
        
        // Map to link-level socket structure
        socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
        
        // Copy link layer address data in socket structure to an array
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        
        // Read from char array into a string object, into traditional Mac address format
        NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                                      macAddress[0], macAddress[1], macAddress[2], 
                                      macAddress[3], macAddress[4], macAddress[5]];
        NSLog(@"Mac Address: %@", macAddressString);
        
        // Release the buffer memory
        free(msgBuffer);
        
        return macAddressString;
    
}
-(void)ConnectionResponseSucceed: (NSData *)data
{
    NSString *responseString=@"";
    NSLog(@"%@",responseString);
    responseString= [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"%@",responseString);

}
- (void) connectionResponseFailed :(NSData *)data
{
    
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}



- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Attempt to resume the existing session or create a new one.
    [[LocalyticsSession sharedLocalyticsSession] resume];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // close the session before entering the background
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Close Localytics Session in the case where the OS terminates the app
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}
#pragma localytics
- (void)analyticsEvent:(NSString *)event
{
	[self analyticsEvent:event properties:nil];
}
- (void)analyticsEvent:(NSString *)event properties:(NSDictionary *)properties
{
	if (!properties)
    {
		[[LocalyticsSession sharedLocalyticsSession] tagEvent:event];
	}
    else
    {
		[[LocalyticsSession sharedLocalyticsSession] tagEvent:event attributes:properties];
	}
}

#pragma mark twitter methods

-(void)checkTwitterLogin
{
  
    {
        
        
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
            if(granted) {
                // Get the list of Twitter accounts.
                NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
                
                NSLog(@"Count : %d",[accountsArray count]);
                if([accountsArray count]!=0)
                {
                if ([accountsArray count] == 1)
                {
                    // share on twitter
                    [self shareOnTwitter];
                    // share on twitter with photo
                    //[self shareOnTwitterWithPhoto];
                    
                    
                }
                else
                {
                    
                    
                    NSLog(@"Username : %@",[[accountsArray objectAtIndex:0]username]);
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // perform an action that updates the UI...
                        
                        
                        //                        [self.navigationController pushViewController:appDelegate.objTwitterAccountListViewController animated:YES];
                        
                        
                        
                        
                    });
                    
                }
                }
            }
            else
            {
                // Alert Please login through seeting
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // perform an action that updates the UI...
                    
                    
                    
                    UIAlertView *customAlertView = [[UIAlertView alloc]initWithTitle:@"Alert"
                                                                             message:@"Please enable twitter through iPhone Settings"
                                                                            delegate:nil
                                                                   cancelButtonTitle:nil
                                                                   otherButtonTitles:@"OK",nil];
                    [customAlertView show];
                    [customAlertView release];
                    
                });
                
                
            }
            
        }];
        
    }
    
    

    
    
}

-(void)twitterLogin
{
    
   
    {
        
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
            if(granted) {
                // Get the list of Twitter accounts.
                NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
                
                NSLog(@"Count : %d",[accountsArray count]);
                
                int flagTwitter;
                flagTwitter = 0;
//                for(int i = 0;i<[accountsArray count];i++)
//                {
//                    if([[[accountsArray objectAtIndex:i]username] isEqualToString:self.strTwitterEmailSelected])
//                    {
//                        
//                        flagTwitter = 1;
//                    }
//                    
//                }
                
//                if(flagTwitter == 1)
//                {
//                    self.strTwitterEmail = self.strTwitterEmailSelected;
//                    
//                }
//                else
//                {
//                    self.strTwitterEmail = [[accountsArray objectAtIndex:0]username];
//                    
//                }
//                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // perform an action that updates the UI...
                    
                    
                });
                
                
            }
            else
            {
                // Alert Please login through seeting
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // perform an action that updates the UI...
                    
                    
                    
                    UIAlertView *customAlertView = [[UIAlertView alloc]initWithTitle:@"Alert"
                                                                             message:@"Please enable twitter through iPhone Settings"
                                                                            delegate:nil
                                                                   cancelButtonTitle:nil
                                                                   otherButtonTitles:@"OK",nil];
                    [customAlertView show];
                    [customAlertView release];
                    
                });
                
                
            }
            
        }];
        
        
    }
       
    
    
    
    
    
}


-(void)twitterLogout
{
    
    
       
    
    
}


- (void)shareOnTwitter
{
    
    
    //first identify whether the device has twitter framework or not
    if (NSClassFromString(@"TWTweetComposeViewController")) {
        
        NSLog(@"Twitter framework is available on the device");
        //code goes here
        //create the object of the TWTweetComposeViewController
        TWTweetComposeViewController *twitterComposer = [[TWTweetComposeViewController alloc]init];
        //set the text that you want to post
        [twitterComposer setInitialText:TwitterShareString];
        [twitterComposer addURL:[NSURL URLWithString:TwitterShareURL]];
        
        //add Image
        //[twitterComposer addImage:[UIImage imageNamed:@"apple1.png"]];
        
        //add Link
        // [twitterComposer addURL:[NSURL URLWithString:@"http://iphonebyradix.blogspot.in"]];
        
        //display the twitter composer modal view controller
        
        [self performSelectorOnMainThread:@selector(myMethod:) withObject:twitterComposer waitUntilDone:NO];
        
        
        //check to update the user regarding his tweet
        twitterComposer.completionHandler = ^(TWTweetComposeViewControllerResult res){
            
            //if the posting is done successfully
            
            if (res == TWTweetComposeViewControllerResultDone){
                //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Tweet successful" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                //                [alert show];
                
            }
            //if posting is done unsuccessfully
            else if(res==TWTweetComposeViewControllerResultCancelled){
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Tweet unsuccessful" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                [alert show];
                
            }
            //dismiss the twitter modal view controller.
            [self.window.rootViewController dismissModalViewControllerAnimated:YES];
            //                [tweetTextField resignFirstResponder];
        };
        
        
        
        //releasing the twiter composer object.
        [twitterComposer release];
        
    }else{
        NSLog(@"Twitter framework is not available on the device");
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your device cannot send the tweet now, kindly check the internet connection or make a check whether your device has atleast one twitter account setup" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        //            [objAlertView release];
        
    }
}
-(void)myMethod:(id)object
{
    [self.window.rootViewController presentModalViewController:object animated:YES];
}
-(void)intializeValues
{
    
    [SettingView sharedCache].isVideoAvailabel=YES; // NO; will hide the video section
    [SettingView sharedCache].isBookAnAppoitment=YES; // NO; will hide the Book an appoitment
    [SettingView sharedCache].isLocateUSAvailabel=YES; // NO; will hide the Locate Us
    [SettingView sharedCache].isDisplayPhotographer = NO; // NO; will hide the Photographer name from homepage
    
    
    
    //White Theme config
    [SettingView sharedCache].colorBarButton = [self colorWithHexString:@"#000000"];
    [SettingView sharedCache].textColor = [self colorWithHexString:@"#000000"];
    [SettingView sharedCache].selectedTextColor = [self colorWithHexString:@"#000000"];
    [SettingView sharedCache].appBackgroundColor = [self colorWithHexString:@"#ffffff"];
   
    
    
    //Font
    [SettingView sharedCache].fontName = @"Avenir-Light";
    //[SettingView sharedCache].fontName = @"GillSans-Light";
    //[SettingView sharedCache].fontName = @"AvenirNext-UltraLight";
    //[SettingView sharedCache].fontName = @"HelveticaNeue-UltraLight";
    //[SettingView sharedCache].fontName =   @"Superclarendon-Light";
    
    
    
    
    

    
    [SettingView sharedCache].isHTML1Available = NO;//d3H: << please don't change this
    [SettingView sharedCache].isHTML2Available = NO;//d3H: << please don't change this
    [SettingView sharedCache].isHTML3Available = NO;//d3H: << please don't change this
    [SettingView sharedCache].isPusNotification= YES; //<< please don't change this
    [SettingView sharedCache].isNewsAndEvents = NO; //<< please don't change this
    [SettingView sharedCache].isAboutUS=NO; //<< please don't change this
    
    
    
    
   }

// takes @"#123456"
- (UIColor *)colorWithHexString:(NSString *)str {
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [self colorWithHex:x];
}

// takes 0x123456
- (UIColor *)colorWithHex:(UInt32)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

+ (NSArray *)getArrayNotDisplay{
    if([[[UIDevice currentDevice] systemVersion] floatValue]<7.0){
        return [NSArray arrayWithObjects: UIActivityTypePostToWeibo,
         UIActivityTypePrint,
         UIActivityTypeAssignToContact,
         nil];
    }
    else{
        return [NSArray arrayWithObjects:UIActivityTypeAddToReadingList, UIActivityTypePostToWeibo,
         UIActivityTypePrint,
         UIActivityTypeAssignToContact,
         UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,
         
         nil];
    }
}
@end
