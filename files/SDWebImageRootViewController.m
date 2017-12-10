//
//  SDWebImageRootViewController.m
//  Sample
//
//  Created by Kirby Turner on 3/18/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "SDWebImageRootViewController.h"
#import "SDWebImageDataSource.h"
#import "AFHTTPRequestOperation.h"
#import "XMLReader.h"
#import "NSString+extras.h"
#import "SettingView.h"
#import "UIImage+Overlay.h"

@interface SDWebImageRootViewController ()
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
@end
@implementation SDWebImageRootViewController
@synthesize str_url;
@synthesize photos;
- (void)dealloc
{
    [activityIndicatorView_ release], activityIndicatorView_ = nil;
    [images_ release], images_ = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    
    NSLog(@"0 %f", [[NSDate date] timeIntervalSince1970]);
    [super viewDidLoad];
    self.photos=[[[NSMutableArray alloc]init] autorelease];
    [self custom_back];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        //        tableView.frame=CGRectMake(0, 88, 768, self.view.frame.size.height-88);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,600,44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        //titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:34.0];
        //Font
        titleLabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:34];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = self.title;
        titleLabel.textColor = [SettingView sharedCache].textColor;
        
        UIView *_view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,768, 88)];
        _view1.backgroundColor = [UIColor clearColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"top_header_bk"]];
        
        //        [_view1 addSubview:_imageView];
        //        _view1.tag = 10002;
        [_view1 addSubview:titleLabel];
        _view1.clipsToBounds = NO;
        
        self.navigationItem.titleView = [_view1 autorelease];
        self.navigationItem.titleView.clipsToBounds = NO;
        self.navigationController.navigationBar.clipsToBounds = NO;
        //        [self.view addSubview:_view1];
        
        
    }
    else{
        _imgview_title.frame=CGRectMake(0, 0, 320, 39);
        //    {
        //         tableView.frame=CGRectMake(0, 0, 768, self.view.frame.size.height-60);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-25, 0, 200,44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        //titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        //Font
        titleLabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
//        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.textAlignment = ([self.title length] < 10 ? UITextAlignmentCenter : UITextAlignmentCenter);
        titleLabel.text = self.title;
        titleLabel.textColor = [SettingView sharedCache].textColor;
        self.navigationItem.titleView = titleLabel;
        [titleLabel release];
    }
    
    //    self.navigationController.navigationBarHidden=NO;
    
    images_ = [[SDWebImageDataSource alloc] init];
    images_.images_=[[NSMutableArray alloc]init];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:self.str_url ])
    {
        images_.images_=[[NSUserDefaults standardUserDefaults]valueForKey:self.str_url ];
        [self setDataSource:images_];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"caption_%@",str_url]])
    {
        images_.caption_=[[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"caption_%@",str_url] ];
    }
    
    NSLog(@"url %@", str_url);
    NSURL *url = [NSURL URLWithString:self.str_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation1;
    operation1=[[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation1  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"2 %f", [[NSDate date] timeIntervalSince1970]);
         NSError *error;
         NSString *string=[operation1.responseString stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
         string=[string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         NSDictionary *dict=[XMLReader dictionaryForXMLString:string  error:&error];
         NSMutableArray *arr_data=[[NSMutableArray alloc]initWithArray:[[[dict valueForKey:@"xml"]valueForKey:@"section"]valueForKey:@"img"]];
         NSMutableArray *arr=[[NSMutableArray alloc]init];
         NSMutableArray *arrCaption=[[NSMutableArray alloc]init];
         for (int i=0; i<arr_data.count; i++)
         {
             NSString *str=[[[[[arr_data objectAtIndex:i]valueForKey:@"imgURL"]valueForKey:@"text"]stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
             
             NSString *CaptionStrstr=[[[[arr_data objectAtIndex:i]valueForKey:@"imgCaption"]valueForKey:@"text"]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
             
             [arr addObject:[NSArray arrayWithObjects:str,str, nil]];
             if(CaptionStrstr)
             {
                 [arrCaption addObject:CaptionStrstr];
             }
             
         }
         
         
         
         if ([images_.images_ isEqualToArray:arr] )
         {
             
         }
         else
         {
             [images_.caption_ removeAllObjects];
             images_.caption_=[NSMutableArray arrayWithArray:arrCaption];
             [images_.images_ removeAllObjects];
             images_.images_=[NSMutableArray arrayWithArray:arr];
             [self setDataSource:images_];
             [[NSUserDefaults standardUserDefaults] setValue:images_.images_ forKey:str_url];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [[NSUserDefaults standardUserDefaults] setValue:images_.caption_ forKey:[NSString stringWithFormat:@"caption_%@",str_url]];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
         NSLog(@"3 %f", [[NSDate date] timeIntervalSince1970]);
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"4 %f", [[NSDate date] timeIntervalSince1970]);
         if ([[NSUserDefaults standardUserDefaults]valueForKey:self.str_url ])
         {
             
         }
         else
         {
             NSLog(@"%@",error.localizedDescription);
             if ([error.localizedDescription isEqualToString:@"Expected status code in (200-299), got 404"])
             {
                 CustomAlertView *alert=[[CustomAlertView alloc]initWithTitle:@"Message" message:@"Album not available at the moment." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil ];
                 [alert show];
                 [alert release];
                 
             }
             else
             {
                 CustomAlertView *alert=[[CustomAlertView alloc]initWithTitle:@"Message" message:error.localizedDescription delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil ];
                 [alert show];
                 [alert release];
                 
             }
             
         }
         
     }
     ];
    
    [operation1 start];
    [self setNavibationBackImage];
}



- (void)setNavibationBackImage {
    dispatch_async(dispatch_get_main_queue(), ^{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        CGRect rect = self.navigationController.navigationBar.frame;
        rect.size.height = 88;
        self.navigationController.navigationBar.frame = rect;
    }
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0) {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"categoryHeader"]
                                                         forBarPosition:UIBarPositionAny
                                                             barMetrics:UIBarMetricsDefault];
    }
    else if (version >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage :[UIImage imageNamed:@"categoryHeader.png"]forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        // UIImage *backgroundImage = [UIImage imageNamed:@"image.png"];
        NSString *barBgPath = [[NSBundle mainBundle] pathForResource:@"categoryHeader" ofType:@"png"];
        [self.navigationController.navigationBar.layer setContents:(id)[UIImage imageWithContentsOfFile: barBgPath].CGImage];
    }
    

    self.navigationController.navigationBar.backgroundColor = [SettingView sharedCache].appBackgroundColor;
    });
}
-(void)viewWillAppear:(BOOL)animated
{
    
    
    //	    [self.navigationController setNavigationBarHidden:NO];
    //     self.view.frame=CGRectMake(0, 88, 768, 936);
    //    self.navigationItem.titleView.hidden = YES;
    self.view.backgroundColor = [SettingView sharedCache].appBackgroundColor;
    [self setNavibationBackImage];
}

- (void)viewDidAppear:(BOOL)animated {
    //        self.navigationItem.titleView.hidden = NO;
    self.navigationController.navigationBarHidden=NO;
    self.view.hidden = NO;
    self.navigationItem.titleView.hidden = NO;
    [self setNavibationBackImage];
    //    }
}
-(void)custom_back
{
    UIImage *buttonImage = [UIImage imageNamed:@"left_arrow.png"];
	//create the button and assign the image
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:buttonImage forState:UIControlStateNormal];
	//set the frame of the button to the size of the image (see note below)
	button.frame = CGRectMake(0, 4, buttonImage.size.width+12, buttonImage.size.height);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0,12.0, 0.0, 0.0)];
	
	[button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIView *_view1 = [[[UIView alloc] initWithFrame:CGRectMake(0, 0,buttonImage.size.width+50, 88)] autorelease];
        button.frame = CGRectMake(10, 8, 50, 34);
        [button setImage:[[UIImage imageNamed:@"BACKbtn_ipad.png"] imageWithColor:[SettingView sharedCache].colorBarButton]
                forState:UIControlStateNormal];
        
        [_view1 addSubview:button];
        UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:_view1];
        self.navigationItem.leftBarButtonItem = customBarItem;
        // Cleanup
        [customBarItem release];
    }
    else {
        //create a UIBarButtonItem with the button as a custom view
        UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"left_arrow"] imageWithColor:[SettingView sharedCache].colorBarButton]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(back)];
        
        [customBarItem setBackgroundImage:[[UIImage alloc] init]
                                 forState:UIControlStateNormal
                               barMetrics:UIBarMetricsDefault];
        
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        if (version >= 7.0) {
            self.navigationController.navigationBar.tintColor = [SettingView sharedCache].colorBarButton;
        }
        self.navigationItem.leftBarButtonItem = customBarItem;
        
        // Cleanup
        [customBarItem release];
    }
}
-(void)back
{
	// Tell the controller to go back
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */
- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload
{
    //    [self.navigationController setNavigationBarHidden:YES];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
- (void)willLoadThumbs
{
    [self showActivityIndicator];
}
- (void)didLoadThumbs
{
    NSLog(@"loaded");
    [self hideActivityIndicator];
}
#pragma mark -
#pragma mark Activity Indicator
- (UIActivityIndicatorView *)activityIndicator
{
    if (activityIndicatorView_)
    {
        return activityIndicatorView_;
    }
    activityIndicatorView_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGPoint center = [[self view] center];
    [activityIndicatorView_ setCenter:center];
    [activityIndicatorView_ setHidesWhenStopped:YES];
    [activityIndicatorView_ startAnimating];
    [[self view] addSubview:activityIndicatorView_];
    
    return activityIndicatorView_;
}
- (void)showActivityIndicator
{
    [[self activityIndicator] startAnimating];
}
- (void)hideActivityIndicator
{
    [[self activityIndicator] stopAnimating];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortraitUpsideDown|UIInterfaceOrientationMaskPortrait;
}
- (void)didSelectThumbAtIndex:(NSUInteger)index
{
    if(images_ == NULL || images_.images_ == NULL) return;
    [self.photos removeAllObjects];
    for (int i=0;i<images_.images_.count;i++)
    {
        MWPhoto *p = [MWPhoto photoWithURL:[NSURL URLWithString:[[images_.images_ objectAtIndex:i]objectAtIndex:0]]];
        NSString *caption = nil;
        if(images_.caption_.count>i)
        {
            caption=[images_.caption_ objectAtIndex:i];
        }
        if(caption==nil)
        {
            [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[[images_.images_ objectAtIndex:i]objectAtIndex:0]]]];
        }
        else
        {
            p.caption=caption;
            [self.photos addObject:p];
        }
        
    }
    
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    [browser setInitialPageIndex:index];
    [[self navigationController] pushViewController:browser animated:YES];
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return NO;
}


@end
