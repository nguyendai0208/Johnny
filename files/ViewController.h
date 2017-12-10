//
//  ViewController.h

//

//  Copyright (c) Kapova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ViewController : UIViewController<NSXMLParserDelegate>
{
    IBOutlet UIImageView *cover_image;
    AppDelegate *appdelegate;
    IBOutlet UILabel *lbl_photographername;
    IBOutlet UIImageView *ivPhotographerName;
    NSMutableArray *arr_detail;
    IBOutlet UITableView *tbl_video_list;
    BOOL alert;
    NSArray *arrayHTMLIndex;//d3H: create array html.
    
}
@property(nonatomic,readwrite)BOOL alert;
-(void)fetch_data_from_server;
@end
