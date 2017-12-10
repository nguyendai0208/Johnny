//
//  MessageTempClass.m
//  RadioListner
//
//  Created by Raghav on 07/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageTempClass.h"
#import "AppDelegate.h"

@implementation MessageTempClass
@synthesize message,classreference;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self messageclass];
}
-(void)messageclass
{
     	picker=[[MFMessageComposeViewController alloc]init];
	picker.messageComposeDelegate = self;
	[picker setRecipients:nil];
//	NSString *str=[NSString stringWithFormat:@"I am listening to %@ on ListenArabic.com iPhone Pro app download now. http://itunes.apple.com/us/app/arabic-radios-live-listenarabic.com/id444355267?mt=8",CurrentStation];
    NSString *str=MessageShare;
	picker.body=str;
	[self presentModalViewController:picker animated:NO];
    
}
#pragma mark MFMessageComposeViewController
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller1 didFinishWithResult:(MessageComposeResult)result {
	
	switch (result)
	{
			
		case MessageComposeResultCancelled:
		{
			UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Stop" message:@" Cancelled " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
			alertView=nil;
		}
			break;
		case MessageComposeResultSent:
		{
			UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Success" message:@" Message has been sent ! " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
			alertView=nil;
		}
			break;
		case MessageComposeResultFailed:
		{
			UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Failed " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
			alertView=nil;
		}
			break;
		default:
		{
			UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@" Unknown Error " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
			alertView=nil;
		}
			break;
	}
	[self dismissModalViewControllerAnimated:NO];
	[self.view removeFromSuperview];
	[[classreference view] removeFromSuperview];
	
	
	
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
