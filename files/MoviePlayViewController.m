//
//  MoviePlayViewController.m

//
//
//  Copyright (c) Kapova. All rights reserved.
//

#import "MoviePlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface MoviePlayViewController ()

@end

@implementation MoviePlayViewController
@synthesize url;
@synthesize controller;

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
    
    /*
    videoView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 385)];
    
    [self embedYouTube :@"http://fromyoutube"  frame:CGRectMake(0, 0, 320, 385)];
    
    [self.view addSubview:videoView];
    
    
    
    
    
//    if(self.isYouTube)
    {
        NSString *embedHTML;
        NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"4.3" options: NSNumericSearch];
        if (order == NSOrderedSame || order == NSOrderedDescending) {
            
            embedHTML = @"<html><head><style type=\"text/css\">body {background-color:black; color:black; margin-right:auto; margin-left:auto;}</style></head><body style=\"margin:0\"><embed id=\"yt\" src=\"%@\" airplay=\"allow\" type=\"application/x-shockwave-flash\" position=\"fixed\" allowfullscreen=\"true\" autoplay=\"1\" width=\"320.0\" height=\"460.0\"><video src=\"point/to/mov\"></video></embed></body></html>";
            
        } else {
            
            embedHTML = @"<html><head><style type=\"text/css\">body {background-color:black; color:black; margin-right:auto; margin-left:auto;}</style></head><body style=\"margin:0\"><embed id=\"yt\" src=\"%@\"  type=\"application/x-shockwave-flash\" position=\"fixed\" allowfullscreen=\"true\" autoplay=\"1\" width=\"320.0\" height=\"460.0\"></embed></body></html>";
            
        }
        
     
        NSString *contentHtml = [NSString stringWithFormat:embedHTML,@"http://www.fromyoutube"];
        
        [videoView setBackgroundColor:[UIColor blackColor]];
        
        [videoView loadHTMLString:contentHtml baseURL:nil];
        
    }
//    else
//    {
//        NSURL *urlForOpenFile=[NSURL URLWithString:self.url];
//        NSURLRequest *request=[NSURLRequest requestWithURL:urlForOpenFile];
//        [self.webView loadRequest:request];
//    }
    
    
//    MPMoviePlayerController *theMoviPlayer;
//    NSURL *urlString=[NSURL URLWithString:@"http://thiswasMP4"];
//    theMoviPlayer = [[MPMoviePlayerController alloc] initWithContentURL:urlString];
//    theMoviPlayer.scalingMode = MPMovieScalingModeFill;
//    theMoviPlayer.view.frame = CGRectMake(0, 60, 320, 350);
//    [self.view addSubview:theMoviPlayer.view];
//    [theMoviPlayer play];
     
     */
    
    
    LBYouTubeExtractor *extractor = [[LBYouTubeExtractor alloc] initWithURL:[NSURL URLWithString:self.url] quality:LBYouTubeVideoQualityLarge];
    
    [extractor extractVideoURLWithCompletionBlock:^(NSURL *videoURL, NSError *error) {
        if(!error) {
            NSLog(@"Did extract video URL using completion block: %@", videoURL);
        } else {
            NSLog(@"Failed extracting video URL using block due to error:%@", error);
        }
    }];
    
    // Setup the player controller and add it's view as a subview:
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateChanged:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.controller];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerDidExitFullscreen:)
                                                 name:MPMoviePlayerDidExitFullscreenNotification
                                               object:nil];
    
    self.controller = [[LBYouTubePlayerController alloc] initWithYouTubeURL:[NSURL URLWithString:self.url] quality:LBYouTubeVideoQualityLarge];
    self.controller.delegate = self;
    self.controller.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    
//    self.controller.view.center = self.view.center;
    [self.view addSubview:self.controller.view];
    // Do any additional setup after loading the view from its nib.
}
-(void) moviePlayerLoadStateChanged:(NSNotification*) notification {
    if ( [self.controller playbackState] == MPMoviePlaybackStatePlaying ) {
        [self.controller setFullscreen:YES];
    }
}

- (void)moviePlayerDidExitFullscreen:(NSNotification *)theNotification {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    
//    self.controller = [[LBYouTubePlayerController alloc] initWithYouTubeURL:[NSURL URLWithString:self.url] quality:LBYouTubeVideoQualityLarge];
//    self.controller.delegate = self;
//    self.controller.view.frame = CGRectMake(0.0f, 0.0f, 200.0f, 200.0f);
//    self.controller.view.center = self.view.center;
//    [self.view addSubview:self.controller.view];
//    
//    [self.controller setFullscreen:YES];
    
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}




- (void)embedYouTube:(NSString*)url frame:(CGRect)frame

{
    
    NSString* embedHTML = @"\"<html><head>\"<style type=\"text/css\">\"body {\"background-color: transparent;\"color: white;\"}\"</style>\"</head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \"width=\"%0.0f\" height=\"%0.0f\"></embed>\"</body></html>";
    
    
    
    NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
    
    if(videoView == nil) {
        
        videoView = [[UIWebView alloc] initWithFrame:frame];
        
        [self.view addSubview:videoView];
        
    }
    
    [videoView loadHTMLString:html baseURL:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
