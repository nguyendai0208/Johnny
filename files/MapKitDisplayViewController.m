//
//  MapKitDisplayViewController.m
//  MapKitDisplay
//
//  
//  Copyright Kapova. All rights reserved.
//

#import "MapKitDisplayViewController.h"
#import "DisplayMap.h"
#import "NSString+extras.h"
#import "UIImage+Overlay.h"

@implementation MapKitDisplayViewController

@synthesize mapView;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.view.backgroundColor = [SettingView sharedCache].appBackgroundColor;
    
	[mapView setMapType:MKMapTypeStandard];
	[mapView setZoomEnabled:YES];
	[mapView setScrollEnabled:YES];
	
	
	
	[mapView setDelegate:self];
	
	
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        _imageview_titile.frame=CGRectMake(0, 0, 768, 88);
        [_imageview_titile setImage:[UIImage imageNamed:@"categoryHeader.png"]];
        
        _lbl_photography.frame=CGRectMake(90, 20, 200, 44);
        //_lbl_photography.font=[UIFont boldSystemFontOfSize:34.0];
        //Font
        _lbl_photography.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:34];
        _lbl_photography.text = [kLocateUs uppercaseString];
        _lbl_photography.textColor = [SettingView sharedCache].textColor;
        _button_back.frame=CGRectMake(-12, 30, 50, 35);
//        [_button_back setImage:[UIImage imageNamed:@"BACKbtn_ipad.png"] forState:UIControlStateNormal];
        [_button_back setImage:[[UIImage imageNamed:@"BACKbtn_ipad.png"] imageWithColor:[SettingView sharedCache].colorBarButton] forState:UIControlStateNormal];
        //              tableView.frame.size.height=88.0;
        mapView.frame=CGRectMake(0, 88, 320, self.view.frame.size.height-88);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200,44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        //titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        //Font
        titleLabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        titleLabel.textColor=[SettingView sharedCache].textColor;
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = self.title;
        self.navigationItem.titleView = titleLabel;
    }
    else{
        _imageview_titile.frame=CGRectMake(0, 0, 320, 44);
        [_imageview_titile setImage:[UIImage imageNamed:@"categoryHeader.png"]];
        _lbl_photography.text=[kLocateUs uppercaseString];
        _lbl_photography.textColor = [SettingView sharedCache].textColor;
        //Font
        _lbl_photography.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-25, 0, 200,44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        //titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        //Font
        titleLabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        titleLabel.textColor=[SettingView sharedCache].textColor;
        titleLabel.textAlignment = ([self.title length] < 10 ? UITextAlignmentCenter : UITextAlignmentCenter);
        titleLabel.text = self.title;
        self.navigationItem.titleView = titleLabel;
        [titleLabel release];
        
        [_button_back setImage:[[UIImage imageNamed:@"left_arrow.png"] imageWithColor:[SettingView sharedCache].colorBarButton] forState:UIControlStateNormal];
    }
    [self navigationController].navigationBarHidden = YES;
    
    
    
//    [self setNavibationBackImage];
    appdel=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.maps_dic_data)
    {
        //        NSArray *arrlocations=[NSString stringWithFormat:@"%@",[[[appdel.maps_dic_data valueForKey:@"photographerApp_map"]valueForKey:@"mLocations"]valueForKey:@"locationN" ]];
        for (int i=0; i<[[[[appdel.maps_dic_data valueForKey:@"photographerApp_map"]valueForKey:@"mLocations"]valueForKey:@"locationN"] count]; i++)
        {
            id text=[[[appdel.maps_dic_data valueForKey:@"photographerApp_map"]valueForKey:@"mLocations"]valueForKey:@"locationN"];
            
            if ( [text isKindOfClass:[NSDictionary class]]) {
                DisplayMap *ann = [[DisplayMap alloc] init];
                ann.title =[[[text valueForKey:@"nameBranch"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
                ann.subtitle=[[[text valueForKey:@"addressBranch"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
                
                NSString *loactionstr=[[[text valueForKey:@"locBranch"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
                NSString *lat=[[loactionstr componentsSeparatedByString:@","]objectAtIndex:0];
                NSString *lng=[[loactionstr componentsSeparatedByString:@","]objectAtIndex:1];
                
                
                MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
                region.center.latitude =[lat doubleValue]  ;
                region.center.longitude = [lng doubleValue];
                region.span.longitudeDelta = 0.023f;
                region.span.latitudeDelta = 0.023f;
                ann.coordinate = region.center;
                [mapView addAnnotation:ann];
                [mapView setRegion:region animated:YES];
            }
            else{
                NSDictionary *dict=[[[[appdel.maps_dic_data valueForKey:@"photographerApp_map"]valueForKey:@"mLocations"]valueForKey:@"locationN"] objectAtIndex:i];
                DisplayMap *ann = [[DisplayMap alloc] init];
                ann.title =[[[dict valueForKey:@"nameBranch"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
                ann.subtitle=[[[dict valueForKey:@"addressBranch"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
                
                NSString *loactionstr=[[[dict valueForKey:@"locBranch"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
                NSString *lat=[[loactionstr componentsSeparatedByString:@","]objectAtIndex:0];
                NSString *lng=[[loactionstr componentsSeparatedByString:@","]objectAtIndex:1];
                
                
                MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
                region.center.latitude =[lat doubleValue]  ;
                region.center.longitude = [lng doubleValue];
                region.span.longitudeDelta = 0.023f;
                region.span.latitudeDelta = 0.023f;
                ann.coordinate = region.center;
                [mapView addAnnotation:ann];
                [mapView setRegion:region animated:YES];
            }
            
        }
        
        
        
        //       int count= [[[[appdel.maps_dic_data valueForKey:@"photographerApp_map"]valueForKey:@"mLocations"]valueForKey:@"locationN"] count];
        
        //        NSLog(@"%d",count);
    }
    
}




-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
 (id <MKAnnotation>)annotation {
	MKPinAnnotationView *pinView = nil; 
	if(annotation != mapView.userLocation) 
	{
		static NSString *defaultPinID = @"com.invasivecode.pin";
		pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
		if ( pinView == nil ) pinView = [[[MKPinAnnotationView alloc]
										  initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];

		pinView.pinColor = MKPinAnnotationColorRed; 
		pinView.canShowCallout = YES;
		pinView.animatesDrop = YES;
		} 
	else {
		[mapView.userLocation setTitle:@"I am here"];
	}
	return pinView;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setLbl_photography:nil];
    [self setImageview_titile:nil];
    [self setButton_back:nil];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[mapView release];
    [_button_back release];
    [_imageview_titile release];
    [_lbl_photography release];
    [super dealloc];
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

- (IBAction)back_button_pressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
