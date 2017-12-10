//
//  MapKitDisplayViewController.h
//  MapKitDisplay
//
//  Copyright Kapova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
@class DisplayMap;

@interface MapKitDisplayViewController : UIViewController <MKMapViewDelegate> {
	
	IBOutlet MKMapView *mapView;
    AppDelegate *appdel;
}
@property (retain, nonatomic) IBOutlet UIButton *button_back;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
- (IBAction)back_button_pressed:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *imageview_titile;
@property (retain, nonatomic) IBOutlet UILabel *lbl_photography;

@end

