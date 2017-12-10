//
//  TwitterAccountListViewController.m
//  Everdrobe
//
//  Created by Naitik Patel on 18/10/12.
//
//

#import "TwitterAccountListViewController.h"

@interface TwitterAccountListViewController ()

@end

@implementation TwitterAccountListViewController

@synthesize arrAccount;

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
    

    
    self.arrAccount = [[NSArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{


    
//    if (appDelegate.PHONE_OS >= 5)
    {
        
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        
        NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
        
        self.arrAccount = accountsArray;
        
        [tblView reloadData];
        
        
    }

    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    NSLog(@"Count : %d",[self.arrAccount count]);
    return [self.arrAccount count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
      //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
       /*
        UIImageView* accessoryViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [accessoryViewImage setImage:[UIImage imageNamed:@"right_arrow.png"]];
        [cell setAccessoryView:accessoryViewImage];
        [accessoryViewImage release];
        */
        //[cell setBackgroundColor:[UIColor colorWithRed:43/255.f green:43/255.f blue:43/255.f alpha:1.0]];
        
        //cell.textLabel.font = [UIFont systemFontOfSize:17];
        //Font
        cell.textLabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
    }
    
    
    //cell.backgroundColor = [UIColor clearColor];
    
    
    //cell.textLabel.textColor = [UIColor whiteColor];
    
        
        cell.textLabel.text = [[self.arrAccount objectAtIndex:indexPath.row]username];
        
    
    
    return cell;
    
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    
//    appDelegate.strTwitterEmailSelected =  [[self.arrAccount objectAtIndex:indexPath.row]username];
    
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
        // share on twitter
//    [appDelegate.objMasterViewController shareOnTwitter];
        // share on twitter with photo
   // [appDelegate.objMasterViewController shareOnTwitterWithPhoto];
    


    
    
}

#ifdef IOS_OLDER_THAN_6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#endif
#ifdef IOS_NEWER_OR_EQUAL_TO_6
-(BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#endif

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [tblView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [tblView release];
    tblView = nil;
    [super viewDidUnload];
}
@end
