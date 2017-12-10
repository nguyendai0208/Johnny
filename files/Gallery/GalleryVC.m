//
//  GalleryVC.m

//
//
//  Copyright (c) 2015 Kapova. All rights reserved.
//

#import "GalleryVC.h"
#import "Cell_home.h"
#import "EGORefreshTableHeaderView.h"
#import "AFHTTPRequestOperation.h"
#import "NSString+extras.h"
#import "XMLReader.h"
#import "video_gallery_Cell.h"
#import "MoviePlayViewController.h"
#import "XCDYouTubeVideoPlayerViewController.h"
#import "UIImage+Overlay.h"
#import <CommonCrypto/CommonDigest.h>
//#import "MWPhoto.h"
@interface GalleryVC ()
@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
@end

@implementation GalleryVC
@synthesize tableView;
@synthesize dict_detail;
@synthesize photos = _photos;
@synthesize alert;
@synthesize video_dict_detail;
@synthesize isFromVideo;
@synthesize controller;
@synthesize hud;
//@synthesize btn_photography;
//@synthesize btn_share;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    btn_share.tintColor = [SettingView sharedCache].colorBarButton;

    self.view.backgroundColor = [SettingView sharedCache].appBackgroundColor;
    self.tableView.backgroundColor = [SettingView sharedCache].appBackgroundColor;
    
    self.dict_detail=[[NSUserDefaults standardUserDefaults]valueForKey:@"gallery"];

    self.video_dict_detail=[[NSUserDefaults standardUserDefaults]valueForKey:@"video_gallery"];
    
    self.navigationController.navigationBarHidden=NO;
    _lbl_photography.text = [kGallery uppercaseString];
    _lbl_photography.textColor = [SettingView sharedCache].textColor;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        //_lbl_photography.font=[UIFont boldSystemFontOfSize:34.0];
        //Font
        _lbl_photography.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:34];
        
        if(self.isFromVideo==YES) {
            _lbl_photography.text=[kVideos uppercaseString];
        }
        
        [_btn_photography setImage:[[UIImage imageNamed:@"BACKbtn_ipad.png"] imageWithColor:[SettingView sharedCache].colorBarButton] forState:UIControlStateNormal];
        
//        btn_share.tintColor = [SettingView sharedCache].colorBarButton;
        tableView.frame=CGRectMake(0, 88, 768, self.view.frame.size.height-88);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200,44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        //titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        //Font
        titleLabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = self.title;
        self.navigationItem.titleView = titleLabel;
    }
    else {
        [_btn_photography setImage:[[UIImage imageNamed:@"left_arrow.png"] imageWithColor:[SettingView sharedCache].colorBarButton] forState:UIControlStateNormal];
        //d3t comment this line
        
        _btn_photography.tintColor = [SettingView sharedCache].colorBarButton;
        
        _imgview_title.frame=CGRectMake(0, 0, 320, 47);
        if(self.isFromVideo==YES)
        {
            _lbl_photography.text=[kVideos uppercaseString];
        }
        // tableView.frame=CGRectMake(0, 0, 768, self.view.frame.size.height-60);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-25, 0, 200,44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        //titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        //Font
        titleLabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.textAlignment = ([self.title length] < 10 ? UITextAlignmentCenter : UITextAlignmentCenter);
        titleLabel.text = self.title;
        self.navigationItem.titleView = titleLabel;
        [titleLabel release];
        //Font
        _lbl_photography.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        
        
    }
    if(self.isFromVideo==YES)
    {
        if (self.video_dict_detail)
        {
            
        }
        else
        {
            [self reloadTableViewDataSource];
            if([SettingView sharedCache].isVideoAvailabel==YES)
            {
                [self video_get_data_for_gallery];
            }
        }
        
    }
    else{
        if (self.dict_detail)
        {
            
        }
        else
        {
            //[self scrollViewDidScroll:self.tableView];
            [self reloadTableViewDataSource];
            //        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
            [self get_data_for_gallery];
        }
        
    }
    self.title=@"Photography";
    if (_refreshHeaderView == nil)
    {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0) {
        
    }
    else{
        //fix for ios 6.0
//        [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
        [self.navigationController.navigationBar setBackgroundImage :[UIImage imageNamed:@"categoryHeader.png"]forBarMetrics:UIBarMetricsDefault];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.toolBar.clipsToBounds = NO;
    for (id sv in [self.toolBar subviews])
    {
        NSString *class = [[sv class] description];
        if([class isEqualToString:@"_UIToolbarBackground"]||[class isEqual:@"UIImage"]){
            [sv removeFromSuperview];
        }else if ([sv isKindOfClass:[UIImageView class]]){
            [sv removeFromSuperview];
        }
        NSLog(@"id %@",[[sv class] description]);
//        if([sv isKindOfClass:[UIToolbarButton class]]){
//
//        }
        
    }
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appdelegate analyticsEvent:@"Gallery"];
}

- (void)viewDidDisappear:(BOOL)animated{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0) {
        
    }
    else{
        //fix for ios 6.0
        [self.navigationController.navigationBar  setBackgroundImage :[UIImage imageNamed:nil]forBarMetrics:UIBarMetricsDefault];
    }
}
#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return 80;
    }
    return 112;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isFromVideo==YES)
    {
        return [[[[self.video_dict_detail valueForKey:@"photographerAppVideos"]valueForKey:@"vidGallery"]valueForKey:@"video"] count];
    }
    
    return [[[[self.dict_detail valueForKey:@"photographerAppV1"]valueForKey:@"imgGallery"]valueForKey:@"gallery"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell_UserGuide";
    if(self.isFromVideo==YES)
    {
        video_gallery_Cell *cell = (video_gallery_Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[[video_gallery_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.backgroundView = [ [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_tab.png"] ]autorelease];
            [cell.selectedBackgroundView setBackgroundColor:[SettingView sharedCache].appBackgroundColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            
            
        }
        
        NSString *str_url=[[[[[[[self.video_dict_detail valueForKey:@"photographerAppVideos"]valueForKey:@"vidGallery"]valueForKey:@"video"] objectAtIndex:indexPath.row]valueForKey:@"videoThumb"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
        
        NSLog(@"--------String url %@",str_url);
        NSString *str_date=[[[[[[[self.video_dict_detail valueForKey:@"photographerAppVideos"]valueForKey:@"vidGallery"]valueForKey:@"video"] objectAtIndex:indexPath.row]valueForKey:@"videoDate"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:str_url] placeholderImage:[UIImage imageNamed:@"default_thumb.jpg"]];
        
        NSString *str_gallery=[[[[[[[self.video_dict_detail valueForKey:@"photographerAppVideos"]valueForKey:@"vidGallery"]valueForKey:@"video"] objectAtIndex:indexPath.row]valueForKey:@"videoName"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
        
        
        //        NSString *str_gallery=[[[[[[[self.dict_detail valueForKey:@"photographerAppV1"]valueForKey:@"imgGallery"]valueForKey:@"gallery"] objectAtIndex:indexPath.row]valueForKey:@"galleryName"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
        cell.frame=CGRectMake(0, 0, 768, 112);
        cell.clipsToBounds=YES;
        
        cell.lbl_title.text=str_gallery;
        cell.lbl_title.textColor = [SettingView sharedCache].textColor;
        cell.lbl_title.highlightedTextColor = [SettingView sharedCache].selectedTextColor;
        
        cell.lbl_date.text=str_date;
        cell.lbl_date.textColor = [SettingView sharedCache].textColor;
        cell.lbl_date.highlightedTextColor = [SettingView sharedCache].selectedTextColor;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            cell.imageView.frame=CGRectMake(24, 20, 84, 72);
            cell.lbl_title.frame=CGRectMake(128,0, 580, 80);
            //Font
            cell.lbl_title.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:34];
       }
        else
        {
            cell.lbl_title.frame=CGRectMake(92, 8, 190, 50);
            //Font
            cell.lbl_title.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        }
        return cell;
        
    }
    else{
        Cell_home *cell = (Cell_home *)[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *topLevelObjects;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                
                topLevelObjects= [[NSBundle mainBundle] loadNibNamed:@"Cell_home" owner:self options:nil];
            }else
            {
                
                topLevelObjects= [[NSBundle mainBundle] loadNibNamed:@"Cell_home_ipad" owner:self options:nil];
                
            }
            for (id currentObject in topLevelObjects)
            {
                if ([currentObject isKindOfClass:[UITableViewCell class]])
                {
                    cell =  (Cell_home *) currentObject;
                    break;
                }
            }
            //        cell.autoresizingMask=UIViewAutoresizingNone;
            cell.backgroundView = [ [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_tab.png"] ]autorelease];
            [cell.selectedBackgroundView setBackgroundColor:[SettingView sharedCache].appBackgroundColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            
        }
        NSString *str_url=[[[[[[[self.dict_detail valueForKey:@"photographerAppV1"]valueForKey:@"imgGallery"]valueForKey:@"gallery"] objectAtIndex:indexPath.row]valueForKey:@"galleryThumb"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
        [cell.imageView setImageWithURL:[NSURL URLWithString:str_url] placeholderImage:[UIImage imageNamed:@"default_thumb.jpg"]];
        
        NSString *str_gallery=[[[[[[[self.dict_detail valueForKey:@"photographerAppV1"]valueForKey:@"imgGallery"]valueForKey:@"gallery"] objectAtIndex:indexPath.row]valueForKey:@"galleryName"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
        
        cell.frame=CGRectMake(0, 0, 768, 112);
        cell.clipsToBounds=YES;
        cell.lbl_title.text=str_gallery;
        cell.lbl_title.textColor = [SettingView sharedCache].textColor;
        cell.lbl_title.highlightedTextColor = [SettingView sharedCache].selectedTextColor;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            cell.imageView.frame=CGRectMake(24, 20, 84, 72);
            cell.lbl_title.frame=CGRectMake(128, 16, 414, 80);
            //Font
            cell.lbl_title.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:34];
        }
        else
        {
            //Font
            cell.lbl_title.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        }
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //d3H: select 
    //NSLog(@"%@",[[[[[[[self.dict_detail valueForKey:@"photographerAppV1"]valueForKey:@"imgGallery"]valueForKey:@"gallery"] objectAtIndex:indexPath.row]valueForKey:@"galleryUrl"]valueForKey:@"text"] stringByTrimmingTrailingWhitespaceAndNewlineCharacters]);
    if(self.isFromVideo==YES)
    {
        NSString *categoryname=[[[[[[self.video_dict_detail valueForKey:@"photographerAppVideos"]valueForKey:@"vidGallery"]valueForKey:@"video"] objectAtIndex:indexPath.row]valueForKey:@"videoName"]valueForKey:@"text"];
        [appdelegate sendDataTogoogleAnalytics:categoryname];
        NSString * url1=[[[[[[[[self.video_dict_detail valueForKey:@"photographerAppVideos"]valueForKey:@"vidGallery"]valueForKey:@"video"] objectAtIndex:indexPath.row]valueForKey:@"videoUrl"]valueForKey:@"text"]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *arr=[url1 componentsSeparatedByString:@"?v="];
        NSString *keycode;
        if(arr.count>1)
        {
            keycode=[arr objectAtIndex:1];
        }
        else
        {
            return;
        }
        
        if (!self.videoPlayerViewController)
            self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:keycode];
        else
            self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:keycode];
        
        //            self.videoPlayerViewController.preferredVideoQualities = @[ @(XCDYouTubeVideoQualitySmall240), @(XCDYouTubeVideoQualityMedium360) ];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerDidExitFullscreen:)
                                                     name:MPMoviePlayerDidExitFullscreenNotification
                                                   object:nil];
        [self presentMoviePlayerViewControllerAnimated:self.videoPlayerViewController];
        return;
        
        NSString * url=[[[[[[[[self.video_dict_detail valueForKey:@"photographerAppVideos"]valueForKey:@"vidGallery"]valueForKey:@"video"] objectAtIndex:indexPath.row]valueForKey:@"videoUrl"]valueForKey:@"text"]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
        LBYouTubeExtractor *extractor = [[LBYouTubeExtractor alloc] initWithURL:[NSURL URLWithString:url] quality:LBYouTubeVideoQualityLarge];
        
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
        
        self.controller = [[LBYouTubePlayerController alloc] initWithYouTubeURL:[NSURL URLWithString:url] quality:LBYouTubeVideoQualityLarge];
        self.controller.delegate = self;
        self.controller.view.frame = self.view.bounds;
        
        //        self.controller.view.center = self.view.center;
        //        self.controller.view.hidden=YES;

        [UIApplication sharedApplication].statusBarHidden=YES;
        CGRect finalFrame = self.controller.view.frame;
        [self.controller.view setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        [UIView animateWithDuration:0.3 animations:^{
            //        [self.navigationController setNavigationBarHidden:YES];
            [self.view addSubview:self.controller.view];
            [self.controller.view setFrame:finalFrame];
        }];
    
    }
    else{
        
        NSDictionary *galleryDetail = [[[[self.dict_detail valueForKey:@"photographerAppV1"]valueForKey:@"imgGallery"]valueForKey:@"gallery"] objectAtIndex:indexPath.row];
        
        NSString *pass = [[galleryDetail objectForKey:@"password"] objectForKey:@"text"];
        if (pass&&![pass isEqualToString:@""]) {
            galleryNeedVerifier = [[NSDictionary alloc] initWithDictionary:galleryDetail];
            //TODO: need ferifier
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Verifier Category" message:@"This is a secure section, please enter the password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            [alertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
            [alertView show];
        }else{
            [self gotoGalleryDetailWithGalleryInfo:galleryDetail];
        }
    }
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)setNavibationBackImage {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        CGRect rect = self.navigationController.navigationBar.frame;
        rect.size.height = 88;
        self.navigationController.navigationBar.frame = rect;
    }
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        UIImage *backgroundImage = [UIImage imageNamed:@"under_photographerName.png"];
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        // UIImage *backgroundImage = [UIImage imageNamed:@"image.png"];
        NSString *barBgPath = [[NSBundle mainBundle] pathForResource:@"under_photographerName" ofType:@"png"];
        [self.navigationController.navigationBar.layer setContents:(id)[UIImage imageWithContentsOfFile: barBgPath].CGImage];
    }
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource
{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}
- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self reloadTableViewDataSource];
    //call the WS here,,,
    self.alert=YES;
    if (self.isFromVideo==YES)
    {
        if([SettingView sharedCache].isVideoAvailabel==YES)
        {
            [self video_get_data_for_gallery];
        }
    }
    else{
        [self get_data_for_gallery];
    }
}
-(void)get_data_for_gallery
{
    NSURL *url = [NSURL URLWithString:PhotoURL];
    NSURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
    AFHTTPRequestOperation *operation1;
    
    operation1=[[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation1  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSString *string=[operation1.responseString stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
         string=[string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         string=[string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
         NSDictionary *dict=[XMLReader dictionaryForXMLString:string  error:&error];
         [self.dict_detail release];
         self.dict_detail=nil;
         [appdelegate analyticsEvent:@"updated" properties:[NSDictionary dictionaryWithObject:@"updated" forKey:@"update"]];
         self.dict_detail=[[NSMutableDictionary alloc]initWithDictionary:dict];
         //self.dict_detail=[NSMutableDictionary dictionaryWithDictionary:dict];
         [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"gallery"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         [self doneLoadingTableViewData];
         [self.tableView reloadData];
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (self.dict_detail||self.alert==NO)
         {
             
         }
         else
         {
             CustomAlertView *alert1=[[CustomAlertView alloc]initWithTitle:@"Message" message:[error localizedDescription] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil ];
             [alert1 show];
             [alert1 release];
         }
         [self doneLoadingTableViewData];
     }
     ];
    [operation1 start];
    
}

-(void)video_get_data_for_gallery
{
    NSURL *url = [NSURL URLWithString:VideoURL];
    NSURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
    AFHTTPRequestOperation *operation1;
    
    operation1=[[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation1  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSString *string=[operation1.responseString stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
         string=[string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         string=[string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
         NSDictionary *dict=[XMLReader dictionaryForXMLString:string  error:&error];
         [self.video_dict_detail release];
         self.video_dict_detail=nil;
         [appdelegate analyticsEvent:@"updated" properties:[NSDictionary dictionaryWithObject:@"updated" forKey:@"update"]];
         self.video_dict_detail=[[NSMutableDictionary alloc]initWithDictionary:dict];
         //self.dict_detail=[NSMutableDictionary dictionaryWithDictionary:dict];
         [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"video_gallery"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         [self doneLoadingTableViewData];
         [self.tableView reloadData];
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //NSLog(@"error: %@",  operation.responseString);
         if (self.video_dict_detail||self.alert==NO)
         {
             
         }
         else
         {
             CustomAlertView *alert1=[[CustomAlertView alloc]initWithTitle:@"Message" message:[error localizedDescription] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil ];
             [alert1 show];
             [alert1 release];
         }
         [self doneLoadingTableViewData];
     }
     ];
    [operation1 start];
    
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload
{
    [self setBtn_share1:nil];
    [self setToolBar:nil];
    [btn_share release];
    btn_share = nil;
    [btn_share release];
    btn_share = nil;
    [self setBtn_photography:nil];
    [self setLbl_photography:nil];
    [self setImgview_title:nil];
	_refreshHeaderView=nil;
    self.navigationController.navigationBarHidden=NO;
}
- (void)dealloc
{
	_refreshHeaderView = nil;
    [_imgview_title release];
    [_lbl_photography release];
    [_btn_photography release];
    [btn_share release];
    [_btn_share1 release];
    [_toolBar release];
    [super dealloc];
}
-(IBAction)back_button_pressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)btnShareClicked:(id)sender
{
    
    [appdelegate sendDataTogoogleAnalytics:[NSString stringWithFormat:@"%@",GalleryShareButton ]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share With a Friend!"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"SMS", @"Email",@"Twitter",@"Facebook", nil];
        
        [actionSheet showFromRect:_btn_share1.frame inView:self.view.superview animated:YES];
        [actionSheet release];
    }
    else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share With a Friend!"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"SMS", @"Email",@"Twitter",@"Facebook", nil];
        
        [actionSheet showInView:self.view];
        [actionSheet release];
        
    }
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 0)
	{
        [appdelegate sendDataTogoogleAnalytics:[NSString stringWithFormat:@"%@",GalleryMessageShareButton ]];
       
        if([MFMessageComposeViewController canSendText])
        {
            
            MessageTempClass *mclasss =[[MessageTempClass alloc]initWithNibName:@"MessageTempClass" bundle:nil];
            
            nav1=[[UINavigationController alloc]initWithRootViewController:mclasss];
            mclasss.classreference=nav1;
            [self.view addSubview:nav1.view];
        }
		
		
		
		
	}
	if(buttonIndex == 1)
	{
        [appdelegate sendDataTogoogleAnalytics:[NSString stringWithFormat:@"%@",GalleryEmailShareButton ]];

		if ([MFMailComposeViewController canSendMail]) {
			
			mailViewController = [[MFMailComposeViewController alloc] init];
			mailViewController.mailComposeDelegate = self;
			
			[mailViewController setToRecipients:nil];
			[mailViewController setSubject:MessageSubject];
            
            NSString *str=MailShare;
			[mailViewController setMessageBody:str isHTML:YES];
			[self.view addSubview:mailViewController.view];
            
		}
		else
		{
			
			UIAlertView *aview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please first make setting for your mail." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[aview show];
			[aview release];
			
		}
		
		
	}
	if(buttonIndex == 2)
	{
        //        ListenArabicAppDelegate   *appdel = (ListenArabicAppDelegate *)[[UIApplication sharedApplication] delegate];
         [appdelegate sendDataTogoogleAnalytics:[NSString stringWithFormat:@"%@",GalleryTwitterShareButton ]];
        
        [appdelegate checkTwitterLogin];
        
        
		
		
	}
	if(buttonIndex == 3)
	{
         [appdelegate sendDataTogoogleAnalytics:[NSString stringWithFormat:@"%@",GalleryFacebookShareButton ]];
       
        [appdelegate postMessageOnFacebook];
        
	}
	if(buttonIndex == 4)
	{
		
	}
}
#pragma mark mfmailcomposerdelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    [mailViewController.view removeFromSuperview];
	
}
#pragma mark -
#pragma mark LBYouTubePlayerViewControllerDelegate

-(void)youTubePlayerViewController:(LBYouTubePlayerController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL {
    NSLog(@"Did extract video source:%@", videoURL);
}

-(void)youTubePlayerViewController:(LBYouTubePlayerController *)controller failedExtractingYouTubeURLWithError:(NSError *)error {
    NSLog(@"Failed loading video due to error:%@", error);
}
-(void) moviePlayerLoadStateChanged:(NSNotification*) notification {
    if ( [self.controller playbackState] == MPMoviePlaybackStatePlaying ) {
        //        self.controller.view.hidden=NO;
        [self.controller setFullscreen:YES];
    }
}

- (void)moviePlayerDidExitFullscreen:(NSNotification *)theNotification {
    //     self.controller.view.hidden=YES;
    CGRect finalFrame =CGRectMake(0, self.view.frame.size.height+110, self.view.frame.size.width, self.view.frame.size.height) ;
    [UIView animateWithDuration:0.7 animations:^{
        [self.controller.view setFrame:finalFrame];
    }];
    
}
#pragma mark NewYouTUbePlayer

- (IBAction) playYouTubeVideo:(id)sender
{
	
}
#pragma mark - Notifications

- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
	MPMovieFinishReason finishReason = [notification.userInfo[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
	NSError *error = notification.userInfo[XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey];
	NSString *reason = @"Unknown";
	switch (finishReason)
	{
		case MPMovieFinishReasonPlaybackEnded:
			reason = @"Playback Ended";
			break;
		case MPMovieFinishReasonPlaybackError:
			reason = @"Playback Error";
			break;
		case MPMovieFinishReasonUserExited:
			reason = @"User Exited";
			break;
	}
	NSLog(@"Finish Reason: %@%@", reason, error ? [@"\n" stringByAppendingString:[error description]] : @"");
    [self dismissMoviePlayerViewControllerAnimated];
}

- (void) moviePlayerPlaybackStateDidChange:(NSNotification *)notification
{
	MPMoviePlayerController *moviePlayerController = notification.object;
	NSString *playbackState = @"Unknown";
	switch (moviePlayerController.playbackState)
	{
		case MPMoviePlaybackStateStopped:
			playbackState = @"Stopped";
			break;
		case MPMoviePlaybackStatePlaying:
			playbackState = @"Playing";
			break;
		case MPMoviePlaybackStatePaused:
			playbackState = @"Paused";
			break;
		case MPMoviePlaybackStateInterrupted:
			playbackState = @"Interrupted";
			break;
		case MPMoviePlaybackStateSeekingForward:
			playbackState = @"Seeking Forward";
			break;
		case MPMoviePlaybackStateSeekingBackward:
			playbackState = @"Seeking Backward";
			break;
	}
	NSLog(@"Playback State: %@", playbackState);
}

- (void) moviePlayerLoadStateDidChange:(NSNotification *)notification
{
	MPMoviePlayerController *moviePlayerController = notification.object;
	
	NSMutableString *loadState = [NSMutableString new];
	MPMovieLoadState state = moviePlayerController.loadState;
	if (state & MPMovieLoadStatePlayable)
		[loadState appendString:@" | Playable"];
	if (state & MPMovieLoadStatePlaythroughOK)
		[loadState appendString:@" | Playthrough OK"];
	if (state & MPMovieLoadStateStalled)
		[loadState appendString:@" | Stalled"];
	
	NSLog(@"Load State: %@", loadState.length > 0 ? [loadState substringFromIndex:3] : @"N/A");
}


#pragma mark -
#pragma mark UIAlertViewDataSource

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        return;
    }
    NSString *pass = [alertView textFieldAtIndex:0].text;
    NSString *passCorrectlyMd5 = [[[[[galleryNeedVerifier objectForKey:@"password"] objectForKey:@"text"] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    
    const char *cStr = [pass UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    NSString *md5Pass = [[NSString stringWithFormat:
                          @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                          result[0], result[1], result[2], result[3],
                          result[4], result[5], result[6], result[7],
                          result[8], result[9], result[10], result[11],
                          result[12], result[13], result[14], result[15]
                          ] lowercaseString];
    
    NSLog(@"/%@/ /%@/ %@",passCorrectlyMd5,md5Pass,pass);
    
    if ([md5Pass isEqualToString:passCorrectlyMd5]) {
        [self gotoGalleryDetailWithGalleryInfo:galleryNeedVerifier];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Verifier Category" message:@"Wrong password. Please try again!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
        [alertView show];
        
    }
}

- (void)gotoGalleryDetailWithGalleryInfo:(NSDictionary *)galleryInfo{
    SDWebImageRootViewController *newController = [[SDWebImageRootViewController alloc] init];
    NSString *categoryname=[[galleryInfo valueForKey:@"galleryName"]valueForKey:@"text"];
    [appdelegate sendDataTogoogleAnalytics:categoryname];
    
    newController.str_url=[[[[galleryInfo valueForKey:@"galleryUrl"]valueForKey:@"text"]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    newController.title=[[[[galleryInfo valueForKey:@"galleryName"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters] uppercaseString];
    [appdelegate analyticsEvent:@"GALLERY" properties:[NSDictionary dictionaryWithObject:newController.title forKey:newController.title]];
    [[self navigationController] pushViewController:newController animated:YES];
    [self navigationController].navigationBarHidden = NO;
    [self setNavibationBackImage];
    [newController release];
}

@end
