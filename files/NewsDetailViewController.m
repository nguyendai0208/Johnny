//
//  NewsDetailViewController.m
//  PortfolioApp
//
//  Created by Long Nguyen Vu on 3/5/14.
//  Copyright (c) 2014 cybervation. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "SettingView.h"
#import "Global.h"
#import "UIImage+Overlay.h"
#import "NSString+extras.h"
#import "XCDYouTubeVideoPlayerViewController.h"
#import "TSMiniWebBrowser.h"

@interface NewsDetailViewController ()
{
    BOOL hasVideo;
    
}

@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;

@end

@implementation NewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [SettingView sharedCache].appBackgroundColor;
    
    NSLog(@"%@", _dictDetail);
    
    lbTitle.text = [self prettyString:[[[self.dictDetail valueForKey:@"nheadline"] valueForKey:@"text"] uppercaseString]];
    lbTitle.textColor = [SettingView sharedCache].textColor;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [btnBack setImage:[[UIImage imageNamed:@"BACKbtn_ipad.png"] imageWithColor:[SettingView sharedCache].colorBarButton]
                 forState:UIControlStateNormal];
        //lbTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:34.0];
        //Font
        lbTitle.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:34];
        
        [btnShare setImage:[[UIImage imageNamed:@"shareBTN_iPad.png"] imageWithColor:[SettingView sharedCache].colorBarButton] forState:UIControlStateNormal];
        
    } else {
        //Font
        lbTitle.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        [btnBack setImage:[[UIImage imageNamed:@"left_arrow.png"] imageWithColor:[SettingView sharedCache].colorBarButton] forState:UIControlStateNormal];
        
        btnBack.tintColor = [SettingView sharedCache].colorBarButton;
        [btnShare setImage:[[UIImage imageNamed:@"shareBTN_iPhone.png"] imageWithColor:[SettingView sharedCache].colorBarButton] forState:UIControlStateNormal];
        
    }
    
    btnShare.tintColor = [SettingView sharedCache].colorBarButton;
    // Load video
    //    NSString* imageUrl = [self prettyString:[[self.dictDetail valueForKey:@"nthumb"] valueForKey:@"text"]];
    
    NSString* video = [self prettyString:[[self.dictDetail valueForKey:@"nvideo"] valueForKey:@"text"]];
    hasVideo = (video && video.length > 0) ? YES : NO;
    
    // SHOW-HIDE video button
    [btnPlayVideo setHidden:!hasVideo];
    
    // HEADLINE
    NSString* title = [self prettyString:[[_dictDetail valueForKey:@"nheadline"] valueForKey:@"text"]];
    lbHeadline.text = title;
    lbHeadline.textColor = [SettingView sharedCache].textColor;
    [lbHeadline sizeToFit];
    
    // LOCATION
    NSString* location = [self prettyString:[[_dictDetail valueForKey:@"nlocation"] valueForKey:@"text"]];
    NSString* originalDateStr = [self prettyString:[[_dictDetail valueForKey:@"ndate"] valueForKey:@"text"]];
    lbLocation.text = [NSString stringWithFormat:@"%@ | %@", location, [self formatDate:originalDateStr]];
    lbLocation.textColor = [SettingView sharedCache].textColor;
    [lbLocation sizeToFit];
    
    CGRect frame = lbLocation.frame;
    frame.origin.y = lbHeadline.frame.origin.y + lbHeadline.frame.size.height + 2;
    lbLocation.frame = frame;
    
    // CONTENT
    NSString* post = [self prettyString:[[_dictDetail valueForKey:@"npost"] valueForKey:@"text"]];
    lbContent.text = post;
    lbContent.textColor = [SettingView sharedCache].textColor;
    [lbContent sizeToFit];
    
    frame = lbContent.frame;
    frame.origin.y = lbLocation.frame.origin.y + lbLocation.frame.size.height + 10;
    lbContent.frame = frame;
    
    // URL
    NSString* url = [self prettyString:[[_dictDetail valueForKey:@"nurl"] valueForKey:@"text"]];
    if (url && url.length > 0) {
        lbLink.text = url;
        lbLink.textColor = [SettingView sharedCache].textColor;
        [lbLink sizeToFit];
        
        frame = lbLink.frame;
        frame.origin.y = lbContent.frame.origin.y + lbContent.frame.size.height + 20;
        lbLink.frame = frame;
        
        // BUTTON LINK
        btnLink.frame = frame;
    }
    else {
        lbLink.hidden = YES;
        btnLink.hidden = YES;
    }
    
    // SCROLL VIEW
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width, frame.origin.y + frame.size.height + 20);
    
    if (!IS_IPAD && !IS_WIDESCREEN) {
        scrollview.frame = CGRectMake(0, 44, 320, 436);
    }
    
    
    NSString* imageUrl = [self prettyString:[[self.dictDetail valueForKey:@"nimage"] valueForKey:@"text"]];
    if (imageUrl&&[imageUrl isEqualToString:@""]==NO) {
        [ivThumb setImageWithURL:[NSURL URLWithString:imageUrl]
                placeholderImage:[UIImage imageNamed:@"blackloader.jpg"]];
    }else{
        CGFloat collapse = ivThumb.frame.size.height;
        
        [ivThumb removeFromSuperview];
        [btnPlayVideo removeFromSuperview];
        CGSize size = scrollview.contentSize;
        size.height -= collapse;
        scrollview.contentSize = size;
        
        for (UIView *view in scrollview.subviews) {
            CGRect frame = view.frame;
            frame.origin.y -= collapse;
            view.frame = frame;
        }
    }
    NSLog(@"btn link hidden %@ and frame %@ lbcontent %@",btnLink.hidden?@"YES":@"NO",NSStringFromCGRect(btnLink.frame),NSStringFromCGRect(lbContent.frame));
    //Font
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //Font
        
        lbHeadline.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:20];
        lbLocation.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:10];
        lbContent.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
         lbLink.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:16];
    }
    else
    {
        //Font
        
        lbHeadline.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:30];
        lbLocation.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:18];
        lbContent.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:22];
        lbLink.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:18];
    }
}

- (IBAction)onBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPlayVideo:(id)sender {
    NSLog(@"play video");
    NSString * url = [self prettyString:[[self.dictDetail valueForKey:@"nvideo"] valueForKey:@"text"]];
    NSArray *arr=[url componentsSeparatedByString:@"?v="];
    NSString *keycode;
    if(arr.count>1)
    {
        keycode=[arr objectAtIndex:1];
    }
    else
    {
        return;
    }
    
    self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:keycode];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerDidExitFullscreen:)
                                                 name:MPMoviePlayerDidExitFullscreenNotification
                                               object:nil];

    [self presentMoviePlayerViewControllerAnimated:self.videoPlayerViewController];

}

- (IBAction)onOpenLink:(id)sender {
    
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:[self prettyString:[[_dictDetail valueForKey:@"nurl"] valueForKey:@"text"]]]];
    webBrowser.showURLStringOnActionSheetTitle = YES;
    webBrowser.showPageTitleOnTitleBar = YES;
    webBrowser.showActionButton = YES;
    webBrowser.showReloadButton = YES;
    webBrowser.mode = TSMiniWebBrowserModeModal;
    
    webBrowser.barStyle = UIBarStyleDefault;
   
    if (webBrowser.mode == TSMiniWebBrowserModeModal) {
        webBrowser.modalDismissButtonTitle = @"Back";
        [self presentModalViewController:webBrowser animated:YES];
    } else if(webBrowser.mode == TSMiniWebBrowserModeNavigation) {
        [self.navigationController pushViewController:webBrowser animated:YES];
    }
    
}

- (void)dealloc {
    [btnBack release];
    [lbTitle release];
    [ivThumb release];
    [btnPlayVideo release];
    [lbHeadline release];
    [lbLocation release];
    [lbContent release];
    [lbLink release];
    [btnLink release];
    [scrollview release];
    [super dealloc];
}
- (void)viewDidUnload {
    [btnBack release];
    btnBack = nil;
    [lbTitle release];
    lbTitle = nil;
    [ivThumb release];
    ivThumb = nil;
    [btnPlayVideo release];
    btnPlayVideo = nil;
    [lbHeadline release];
    lbHeadline = nil;
    [lbLocation release];
    lbLocation = nil;
    [lbContent release];
    lbContent = nil;
    [lbLink release];
    lbLink = nil;
    [btnLink release];
    btnLink = nil;
    [scrollview release];
    scrollview = nil;
    [super viewDidUnload];
}

- (NSString*) prettyString:(NSString*)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
    return string;
}

- (NSString*) formatDate:(NSString*)string
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"EEEE MMMM dd yyyy H:mm v"];
    NSDate *date = [dateFormatter dateFromString:string];
    
    [dateFormatter setDateFormat:@"MMM, dd yyyy - h:mm a"];
    
    return [dateFormatter stringFromDate:date];
}


- (IBAction)pressShare:(id)sender{
    
    
    NSString *textObject = [self.dictDetail valueForKey:@"nheadline"];
    NSString *urlString = kShareLinkApp;
    NSURL *url = [NSURL URLWithString:urlString];
    NSArray *activityItems;
    if([ivThumb superview]){
        activityItems = [NSArray arrayWithObjects:textObject, url,
                         ivThumb.image,
                         nil];
    }
    else{
        activityItems = [NSArray arrayWithObjects:textObject, url,
                         nil];
    }
    
    
    
    UIActivityViewController *avc = [[[UIActivityViewController alloc]
                                      initWithActivityItems:activityItems
                                      applicationActivities:nil] autorelease];
    avc.excludedActivityTypes = [AppDelegate getArrayNotDisplay];
    
    [self presentViewController:avc animated:YES completion:nil];
    
    
}

@end
