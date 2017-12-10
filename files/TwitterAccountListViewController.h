//
//  TwitterAccountListViewController.h
//  Everdrobe
//
//  Created by Naitik Patel on 18/10/12.
//
//

#import "Global.h"

@interface TwitterAccountListViewController : UIViewController
{
    
    NSArray *arrAccount;
    
    IBOutlet UITableView *tblView;
}

@property(nonatomic,retain) NSArray *arrAccount;

-(void)viewRefresh;
@end
