//
//  ViewController.m

//
//  Copyright (c) Kapova. All rights reserved.
//

#import "ViewController.h"

#import "XMLReader.h"
#import "NSString+extras.h"
#import "Cell_home.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPRequestOperation.h"
#import "AboutusVC.h"
#import "TheArtistVC.h"
#import "GalleryVC.h"
#import "MapKitDisplayViewController.h"
#import "CustomWebViewViewController.h"
#import "Global.h"
#import "NewsViewController.h"
#import "WebViewViewController.h"


//#import <SDWebImage/>

@interface ViewController ()
@end

@implementation ViewController
@synthesize alert;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [SettingView sharedCache].appBackgroundColor;
    
    self.alert=YES;
	// Do any additional setup after loading the view, typically from a nib.
    //check in server for update;
    [self setNavibationBackImage];
}


- (void)setNavibationBackImage {
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
        UIImage *backgroundImage = [UIImage imageNamed:@"categoryHeader"];
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        NSString *barBgPath = [[NSBundle mainBundle] pathForResource:@"categoryHeader" ofType:@"png"];
        [self.navigationController.navigationBar.layer setContents:(id)[UIImage imageWithContentsOfFile: barBgPath].CGImage];
    }
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [self fetch_data_from_server];
    [self fetch_data_from_server_about_us];
    if([SettingView sharedCache].isLocateUSAvailabel==YES)
    {
        [self fetch_data_from_server_Maps];
    }
    //load existing data
    appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appdelegate analyticsEvent:@"dashboard"];
    NSString *str_url=[[[[appdelegate.dic_data valueForKey:@"photographerApp_about"] valueForKey:@"homeImage"] valueForKey:@"text"] stringByTrimmingLeadingWhitespaceAndNewlineCharacters ];
    
    [cover_image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",str_url]]
                placeholderImage:[UIImage imageNamed:@"blackloader.jpg"]];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Data"]isKindOfClass:[NSDictionary class] ])
    {
        lbl_photographername.text=[[[[appdelegate.dic_data valueForKey:@"photographerApp_about"] valueForKey:@"photographerName"] valueForKey:@"text"] stringByTrimmingLeadingWhitespaceAndNewlineCharacters ];
        
    }
    else
    {
        lbl_photographername.text=@"";
    }
   
    //Font
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //Font
        lbl_photographername.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
    }
    else
    {
        //Font
        lbl_photographername.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:34];
    }

    if([SettingView sharedCache].isDisplayPhotographer == YES){
        lbl_photographername.hidden = NO;
        ivPhotographerName.hidden = NO;
    }
    else{
        ivPhotographerName.hidden = YES;
        lbl_photographername.hidden = YES;
        
        ivPhotographerName.backgroundColor = [SettingView sharedCache].appBackgroundColor;
        ivPhotographerName.tintColor = [SettingView sharedCache].appBackgroundColor;
        
    }
    
    lbl_photographername.textColor = [SettingView sharedCache].textColor;
    
    //button at bottom...
    arr_detail=[[NSMutableArray alloc]init];
    //d3H: add html to arr_detail
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    [arr_detail addObject:@""];
    arr_detail[kGalleryIndex] = kGallery;
    if([SettingView sharedCache].isVideoAvailabel==YES)
    {
        arr_detail[kVideoIndex] = kVideos;
    }
    if([SettingView sharedCache].isBookAnAppoitment==YES)
    {
        arr_detail[kAppointmentIndex] = kAppointment;
    }
    if([SettingView sharedCache].isLocateUSAvailabel==YES)
    {
        arr_detail[kLocateUsIndex] = kLocateUs;
    }
    
    arr_detail[kArtistIndex] = kArtist;
    
    if([SettingView sharedCache].isAboutUS==YES)
    {
        arr_detail[kAboutUsIndex] = kAbout;
    }
    
    if([SettingView sharedCache].isNewsAndEvents==YES){
        arr_detail[kNewsIndex] = KNews;
    }
    
    //d3H: add more html index...
    if([SettingView sharedCache].isHTML1Available == YES){
        arr_detail[kHTMLIndex1] = kHTMLName1;
    }
    
    if([SettingView sharedCache].isHTML2Available == YES){
        arr_detail[kHTMLIndex2] = kHTMLName2;
    }
    
    if([SettingView sharedCache].isHTML3Available == YES){
        arr_detail[kHTMLIndex3] = kHTMLName3;
    }
    
    //d3H: remove image if setting is NO
    if([SettingView sharedCache].isDisplayPhotographer == NO){
        ivPhotographerName.hidden = YES;
        lbl_photographername.hidden = YES;
    }
    //End D3H
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if(appdelegate.isiPhone5)
        {
            CGRect tablerect= tbl_video_list.frame;
            tablerect.origin.y=self.view.frame.size.height-240;
            tablerect.size.height=240;
            tbl_video_list.frame=tablerect;
        
            cover_image.frame= CGRectMake(0, 0, 320, 322);
            ivPhotographerName.frame = CGRectMake(0, 257, 320, 35);
            
        }
        else{
            CGRect imageviewrect=cover_image.frame;
            imageviewrect.origin.y=40;
            imageviewrect.size.height=60;
            
            //
            cover_image.frame=CGRectMake(0, 0, 320, 240);
            ivPhotographerName.frame = CGRectMake(0, 175, 320, 35);
        }
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    lbl_photographername.center = ivPhotographerName.center;
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"launched"]==NO)
    {
        if(arr_detail.count>3)
        {
            [tbl_video_list scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.6]];
            
            [tbl_video_list scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        BOOL launched = YES;
        [[NSUserDefaults standardUserDefaults]setBool:launched forKey:@"launched"];;
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    
}
+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
-(void)fetch_data_from_server
{
    NSURL *url = [NSURL URLWithString:ArtistURL];
    NSURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
    AFHTTPRequestOperation *operation1;
    operation1=[[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation1  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSString *string=[operation1.responseString stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
         string=[string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         //string=[string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
         
         // Set label name (deprecated), change by ivPhotographerName
         NSDictionary *dict=[XMLReader dictionaryForXMLString:string  error:&error];
         [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"Data"];
         NSString *pName = [[[[dict valueForKey:@"photographerApp_about"]valueForKey:@"photographerName"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters ];
         if(IS_IPAD){
             lbl_photographername.text=[pName uppercaseString];
             
         }
         else{
             lbl_photographername.text= pName;
         }
         
         // Cache data
         appdelegate.dic_data=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:@"Data"]];
         
         
         // Set image from RESPONSE
         NSString *str_url=[[[[appdelegate.dic_data valueForKey:@"photographerApp_about"] valueForKey:@"homeImage"] valueForKey:@"text"] stringByTrimmingLeadingWhitespaceAndNewlineCharacters ];
         
         [cover_image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",str_url]]
                     placeholderImage:[UIImage imageNamed:@"blackloader.jpg"]];
         
         [[NSUserDefaults standardUserDefaults] synchronize];
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //NSLog(@"error: %@",  [error localizedDescription]);
         if (self.alert==YES)
         {
             self.alert=NO;
             CustomAlertView *alert1=[[CustomAlertView alloc]initWithTitle:@"Message" message:[error localizedDescription] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil ];
             [alert1 show];
             [alert1 release];
         }
         else
         {
             
         }
     }
     ];
    [operation1 start];
}

-(void)fetch_data_from_server_about_us
{
    NSURL *url = [NSURL URLWithString:aboutUSURL];
    NSURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation1;
    operation1=[[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation1  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSString *string=[operation1.responseString stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
         string=[string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         //string=[string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
         
         NSDictionary *dict=[XMLReader dictionaryForXMLString:string  error:&error];
         [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"about_us_Data"];

         appdelegate.about_us_dic_data=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:@"about_us_Data"]];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //NSLog(@"error: %@",  [error localizedDescription]);
         if (self.alert==YES)
         {
             self.alert=NO;
             CustomAlertView *alert1=[[CustomAlertView alloc]initWithTitle:@"Message" message:[error localizedDescription] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil ];
             [alert1 show];
             [alert1 release];
         }
         else
         {
             
         }
     }
     ];
    [operation1 start];
}

-(void)fetch_data_from_server_Maps
{
    NSURL *url = [NSURL URLWithString:MapsURL];
    NSURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation1;
    operation1=[[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation1  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSString *string=[operation1.responseString stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
         string=[string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         //string=[string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
         
         NSDictionary *dict=[XMLReader dictionaryForXMLString:string  error:&error];
         [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"maps"];

         appdelegate.maps_dic_data=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:@"maps"]];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //NSLog(@"error: %@",  [error localizedDescription]);
         if (self.alert==YES)
         {
             self.alert=NO;
             CustomAlertView *alert1=[[CustomAlertView alloc]initWithTitle:@"Message" message:[error localizedDescription] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil ];
             [alert1 show];
             [alert1 release];
         }
         else
         {
             
         }
     }
     ];
    [operation1 start];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validRow:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    if([[arr_detail objectAtIndex:row] isEqualToString:@""]){
        return  false;
    }
    return true;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"number of row %d",arr_detail.count);
    return arr_detail.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self validRow:indexPath] == NO){
        return 0;
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return 80;
    }
    return 112;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self validRow:indexPath] == NO){
        return [[[UITableViewCell alloc] init] autorelease];
    }
    
    NSLog(@"%f",tableView.rowHeight);
    static NSString *CellIdentifier = @"Cell_UserGuide";
    Cell_home *cell = (Cell_home *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
        cell.backgroundView = [ [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_tab.png"] ]autorelease];
        
        [cell.selectedBackgroundView setBackgroundColor:[UIColor grayColor]];

        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    NSString *stringDetail = [arr_detail objectAtIndex:indexPath.row];
    if ([stringDetail isEqualToString:kHTMLName1]||[stringDetail isEqualToString:kHTMLName2]||[stringDetail isEqualToString:kHTMLName3]) {
        
        
        NSString *strName = [arr_detail objectAtIndex:indexPath.row];
        
        NSString *strIcon = [NSString stringWithFormat:@"%@.jpg",strName];
        
        [cell.imageView setImage:[UIImage imageNamed:strIcon]];
        cell.lbl_title.text= strName;
        cell.lbl_title.textColor = [SettingView sharedCache].textColor;
        cell.lbl_title.highlightedTextColor = [SettingView sharedCache].selectedTextColor;
        
    }
    else{
        [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[arr_detail objectAtIndex:indexPath.row]]]];
        cell.lbl_title.text=[arr_detail objectAtIndex:indexPath.row];
        cell.lbl_title.textColor = [SettingView sharedCache].textColor;
        cell.lbl_title.highlightedTextColor = [SettingView sharedCache].selectedTextColor;
        
    }
    //Font
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //Font
        cell.lbl_title.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
    }
    else
    {
        //Font
        cell.lbl_title.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:34];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *section= [arr_detail objectAtIndex:indexPath.row];
    [appdelegate sendDataTogoogleAnalytics:section];
    if([section isEqualToString:kGallery])
    {
        GalleryVC *detailVC=[[GalleryVC alloc]initWithNibName:@"GalleryVC" bundle:nil];
        detailVC.alert=self.alert;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        [detailVC release];
        
    }
    else if([section isEqualToString:kVideos])
    {
        GalleryVC *detailVC=[[GalleryVC alloc]initWithNibName:@"GalleryVC" bundle:nil];
        detailVC.alert=self.alert;
        detailVC.isFromVideo=YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        [detailVC release];
        
    }
    else if([section isEqualToString:kAppointment])
    {
        CustomWebViewViewController *coretextVC=[[[CustomWebViewViewController alloc]init]autorelease];
        [coretextVC loadURLInWebview:BookAnAppoitmentURL rowId:indexPath.row lableText:@""];
        //            [self.detailVC presentViewController:coretextVC animated:YES completion:nil];
        
        
        [self.navigationController pushViewController:coretextVC animated:YES];
        //            [coretextVC release];
        
    }
    
    else if([section isEqualToString:kLocateUs])
    {
        MapKitDisplayViewController *MapkitVC=[[MapKitDisplayViewController alloc]initWithNibName:@"MapKitDisplayViewController" bundle:nil];
        //            MapkitVC.alert=self.alert;
        //            detailVC.isFromVideo=YES;
        [self.navigationController pushViewController:MapkitVC animated:YES];
        [MapkitVC release];
        
    }
    
    else if([section isEqualToString:kArtist])
    {
        TheArtistVC *detailVC=[[TheArtistVC alloc]initWithNibName:@"TheArtistVC" bundle:nil];
        [self.navigationController pushViewController:detailVC animated:YES];
        [detailVC release];
        
    }
    else if([section isEqualToString:kAbout])
    {
        AboutusVC *detailVC=[[AboutusVC alloc]initWithNibName:@"AboutusVC" bundle:nil];
        [self.navigationController pushViewController:detailVC animated:YES];
        [detailVC release];
    }
    else if([section isEqualToString:KNews])
    {
        NSString* xib;
        if (IS_IPAD) {
            xib = @"NewsViewController_ipad";
        }
        else if (IS_WIDESCREEN) {
            xib = @"NewsViewController";
        }
        else {
            xib = @"NewsViewController_small";
        }
        NewsViewController *newsVC=[[NewsViewController alloc]initWithNibName:xib bundle:nil];
        [self.navigationController pushViewController:newsVC animated:YES];
        [newsVC release];
    }
    else{
        NSString *url = @"";
        if([section isEqualToString:kHTMLName1]){
            url = kHtmlURL1;
        }
        else
            if([section isEqualToString:kHTMLName2]){
                url = kHtmlURL2;
            }
            else{
                url = kHtmlURL3;

            }
        
        CustomWebViewViewController *coretextVC=[[[CustomWebViewViewController alloc]init]autorelease];
        [coretextVC loadURLInWebview:url rowId:indexPath.row lableText:@""];
        coretextVC.labelName = [arr_detail objectAtIndex:indexPath.row];
        
        
        [self.navigationController pushViewController:coretextVC animated:YES];
        
      
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)dealloc {
  [ivPhotographerName release];
  [super dealloc];
}
- (void)viewDidUnload {
  [ivPhotographerName release];
  ivPhotographerName = nil;
  [super viewDidUnload];
}
@end
