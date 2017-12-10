//
//  NewsViewController.m
//  PortfolioApp
//
//  Created by Long Nguyen Vu on 3/5/14.
//  Copyright (c) 2014 cybervation. All rights reserved.
//

#import "NewsViewController.h"
#import "AFHTTPRequestOperation.h"
#import "NSString+extras.h"
#import "XMLReader.h"
#import "Global.h"
#import "video_gallery_Cell.h"
#import "UIImage+Overlay.h"
#import "SettingView.h"
#import "NewsDetailViewController.h"
#import "AFHTTPClient.h"
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface NewsViewController ()
@end

@implementation NewsViewController

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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [SettingView sharedCache].appBackgroundColor;
    
    ivLatestNews.hidden = YES;
    viewLatest.hidden = YES;
    
    [self loadData];
    
    lbTitle.text = [KNews uppercaseString];
    lbTitle.textColor = [SettingView sharedCache].textColor;
    //Font
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //Font
        lbTitle.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        lbLatestNewsHeadline.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:22];
        lblLatestNewsLocation.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:12];
    }
    else
    {
        //Font
        lbTitle.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:34];
        lbLatestNewsHeadline.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:32];
        lblLatestNewsLocation.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:20];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [btnBack setImage:[[UIImage imageNamed:@"BACKbtn_ipad.png"] imageWithColor:[SettingView sharedCache].colorBarButton]
                 forState:UIControlStateNormal];
        [btnShare setImage:[[UIImage imageNamed:@"shareBTN_iPhone_7@2x"] imageWithColor:[SettingView sharedCache].colorBarButton]
                 forState:UIControlStateNormal];
    } else {
        [btnBack setImage:[[UIImage imageNamed:@"left_arrow.png"] imageWithColor:[SettingView sharedCache].colorBarButton] forState:UIControlStateNormal];
        
       btnBack.tintColor = [SettingView sharedCache].colorBarButton;
    }
    
    if (refeshTableHeaderView == nil)
    {
        refeshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tableview.bounds.size.height, self.view.frame.size.width, tableview.bounds.size.height)];
        refeshTableHeaderView.delegate = self;
        [tableview addSubview:refeshTableHeaderView];
        [refeshTableHeaderView refreshLastUpdatedDate];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    NSURL *url = [NSURL URLWithString:NewsURL];
    NSURLRequest *request=[NSMutableURLRequest requestWithURL:url];
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

         [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"news"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         [self onLoadDataCompleted];
          [refeshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tableview];
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //NSLog(@"error: %@",  operation.responseString);
         if (self.dict_detail)
         {
             
         }
         else
         {
             CustomAlertView *alert1=[[CustomAlertView alloc]initWithTitle:@"Message" message:[error localizedDescription] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil ];
             [alert1 show];
             [alert1 release];
         }
//         [self doneLoadingTableViewData];
          [refeshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tableview];
     }
     ];
    [operation1 start];
}

- (void) onLoadDataCompleted
{
    newsData = [[[self.dict_detail valueForKey:@"xml"] valueForKey:@"nitf"] valueForKey:@"nitem"];
    NSLog(@"count: %d", newsData.count);
    [tableview reloadData];
    
    if (newsData.count > 0) {
        
        NSDictionary *latestNews = newsData[0];
        NSString* imageUrl;
        if([latestNews valueForKey:@"nimage"]){
           imageUrl = [self prettyString:[[latestNews valueForKey:@"nimage"] valueForKey:@"text"]];
        }
        else{
            imageUrl = [self prettyString:[[latestNews valueForKey:@"nthumb"] valueForKey:@"text"]];
        }
//        NSString* imageUrl = [self prettyString:[[latestNews valueForKey:@"nthumb"] valueForKey:@"text"]];
        [ivLatestNews setImageWithURL:[NSURL URLWithString:imageUrl]
                     placeholderImage:[UIImage imageNamed:@"blackloader.jpg"]];
        
        NSString* location = [self prettyString:[[latestNews valueForKey:@"nlocation"] valueForKey:@"text"]];
        NSString* originalDateStr = [self prettyString:[[latestNews valueForKey:@"ndate"] valueForKey:@"text"]];
        if (location == nil || [location isEqualToString:@""]) {
            lblLatestNewsLocation.text = [NSString stringWithFormat:@"%@", [self formatDate:originalDateStr]];
        }else{
            lblLatestNewsLocation.text = [NSString stringWithFormat:@"%@ | %@", location, [self formatDate:originalDateStr]];
        }
        
        NSString* title = [self prettyString:[[latestNews valueForKey:@"nheadline"] valueForKey:@"text"]];
        lbLatestNewsHeadline.text = title;
        lbLatestNewsHeadline.textColor = [SettingView sharedCache].textColor;
        [lblLatestNewsLocation sizeToFit];
        lblLatestNewsLocation.textColor =[SettingView sharedCache].textColor;

        [lbLatestNewsHeadline sizeToFit];
        
        CGRect frame = lblLatestNewsLocation.frame;
        frame.origin.y = lbLatestNewsHeadline.frame.origin.y + lbLatestNewsHeadline.frame.size.height;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            frame.origin.y = frame.origin.y + 10;
        }
        lblLatestNewsLocation.frame = frame;
        frame = viewLatest.frame;
        frame.size.height = lblLatestNewsLocation.frame.origin.y + lblLatestNewsLocation.frame.size.height;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            frame.size.height = frame.size.height + 30;
        }else{
            frame.size.height = frame.size.height + 10;
        }
        frame.origin.y = ivLatestNews.frame.origin.y + ivLatestNews.frame.size.height - 9 - frame.size.height + 9;
        viewLatest.frame = frame;
        
        ivLatestNews.hidden = NO;
        viewLatest.hidden = NO;
    }
    else {
        ivLatestNews.hidden = YES;
        viewLatest.hidden = YES;
    }
        viewLatest.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainNews_bk.png"]];
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
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"EEEE MMMM dd yyyy H:mm v"];
    NSDate *date = [dateFormatter dateFromString:string];
    
    [dateFormatter setDateFormat:@"MMM, dd yyyy - h:mm a"];
    
    return [dateFormatter stringFromDate:date];
}

- (NSString*) getDate:(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE MMMM dd yyyy H:mm v"];
    NSDate *date = [dateFormatter dateFromString:string];
    
    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    
    return [dateFormatter stringFromDate:date];
}

- (void)dealloc {
    [ivLatestNews release];
    [viewLatest release];
    [lblLatestNewsLocation release];
    [lbLatestNewsHeadline release];
    [tableview release];
    [lbTitle release];
    [btnBack release];
    [btnShare release];
    [super dealloc];
}

- (void)viewDidUnload {
    [ivLatestNews release];
    ivLatestNews = nil;
    [viewLatest release];
    viewLatest = nil;
    [lblLatestNewsLocation release];
    lblLatestNewsLocation = nil;
    [lbLatestNewsHeadline release];
    lbLatestNewsHeadline = nil;
    [tableview release];
    tableview = nil;
    [lbTitle release];
    lbTitle = nil;
    [btnBack release];
    btnBack = nil;
    [btnShare release];
    btnShare = nil;
    [super viewDidUnload];
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
    return (newsData.count - 1 > 0) ? newsData.count - 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell_UserGuide";
    video_gallery_Cell *cell = (video_gallery_Cell *)[tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[[video_gallery_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundView = [ [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_tab.png"] ]autorelease];
        [cell.selectedBackgroundView setBackgroundColor:[SettingView sharedCache].appBackgroundColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
//        cell.lbl_date.font=[UIFont systemFontOfSize:10.0];
    }
    
    NSDictionary* news = newsData[indexPath.row + 1];
    NSString *str_url = [self prettyString:[[news valueForKey:@"nthumb"] valueForKey:@"text"]];
    [cell.imageView setImageWithURL:[NSURL URLWithString:str_url] placeholderImage:[UIImage imageNamed:@"default_thumb.jpg"]];
    
    NSString* location = [self prettyString:[[news valueForKey:@"nlocation"] valueForKey:@"text"]];
    NSString* originalDateStr = [self prettyString:[[news valueForKey:@"ndate"] valueForKey:@"text"]];
    NSString *str_date = nil;
    if (location == nil || [location isEqualToString:@""]) {
        str_date = [NSString stringWithFormat:@"%@", [self formatDate:originalDateStr]];
    }else{
        str_date = [NSString stringWithFormat:@"%@ | %@", location, [self formatDate:originalDateStr]];
    }
    
    NSString *str_gallery = [self prettyString:[[news valueForKey:@"nheadline"] valueForKey:@"text"]];
    
    
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
    }
    else{
        cell.lbl_title.frame=CGRectMake(92, 8, 190, 50);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* xib;
    if (IS_IPAD) {
        xib = @"NewsDetailViewController_ipad";
    }
    else {
        xib = @"NewsDetailViewController";
    }
    NewsDetailViewController* detailVC = [[NewsDetailViewController alloc]
                                          initWithNibName:xib bundle:nil];
    
    detailVC.dictDetail = newsData[indexPath.row + 1];
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [detailVC release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)onBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onOpenLatestNews:(id)sender
{
    NSString* xib;
    if (IS_IPAD) {
        xib = @"NewsDetailViewController_ipad";
    }
    else if (IS_WIDESCREEN){
        xib = @"NewsDetailViewController";
    }
    else {
        xib = @"NewsDetailViewController_small";
    }
    NewsDetailViewController* detailVC = [[NewsDetailViewController alloc]
                                          initWithNibName:xib bundle:nil];
    
    detailVC.dictDetail = newsData[0];
    [self.navigationController pushViewController:detailVC animated:YES];    
    [detailVC release];
}


#pragma mark - datasources and delegates
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[refeshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[refeshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark EGORefreshTableHeaderView delegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
//    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://google.com"]];
//    [client set]
//    
//    if (status != AFNetworkReachabilityStatusNotReachable) {
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:NewsURL]]];
//    }

    [self loadData];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return NO;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date];
}

@end
