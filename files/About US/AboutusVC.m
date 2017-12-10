//
//  AboutusVC.m

//
//  Copyright (c) 2015 Kapova. All rights reserved.
//

#import "AboutusVC.h"
#import "NSString+extras.h"
@interface AboutusVC ()

@end

@implementation AboutusVC

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
    appdelegate=[[UIApplication sharedApplication]delegate];
    _lbl_photography.text = kAbout.uppercaseString;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        _imgview_title.frame=CGRectMake(0, 0, 768, 88);
        _lbl_photography.frame=CGRectMake(60, 20, 200, 44);
        _btn_photography.frame=CGRectMake(-12, 25, 50, 35);
         [_btn_photography setImage:[UIImage imageNamed:@"BACKbtn_ipad.png"] forState:UIControlStateNormal];
        lbl_name.frame=CGRectMake(14, 94, 300, 32);
        txt_desc.frame=CGRectMake(10, 120, 300, 156);
        //              tableView.frame.size.height=88.0;
        self.view.frame=CGRectMake(0, 120, 768, self.view.frame.size.height-88);
         //_lbl_photography.font = [UIFont fontWithName:@"Helvetica-Bold" size:34.0];
        //Font
        _lbl_photography.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:34];
    }
    else{
        _imgview_title.frame=CGRectMake(0, 0, 320, 39);
        //         tableView.frame=CGRectMake(0, 0, 768, self.view.frame.size.height-60);
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
    [self.btn_photography setImage:[[UIImage imageNamed:@"left_arrow.png"] imageWithColor:[SettingView sharedCache].colorBarButton] forState:UIControlStateNormal];
    [_imgview_title setImage:[UIImage imageNamed:@"categoryHeader.png"]];
    if (appdelegate.about_us_dic_data)
    {
        lbl_name.text=[NSString stringWithFormat:@"%@",[[[[[appdelegate.about_us_dic_data valueForKey:@"photographerApp_cyber"]valueForKey:@"aboutUs"]valueForKey:@"pName"]valueForKey:@"text"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        //Font
        lbl_name.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        
        txt_desc.text=[NSString stringWithFormat:@"%@",[[[[[appdelegate.about_us_dic_data valueForKey:@"photographerApp_cyber"]valueForKey:@"aboutUs"]valueForKey:@"about"]valueForKey:@"text"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        //Font
        txt_desc.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        
       
        [btn_email setTitle:[NSString stringWithFormat:@"%@",[[[[[appdelegate.about_us_dic_data valueForKey:@"photographerApp_cyber"]valueForKey:@"aboutUs"]valueForKey:@"email"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters]] forState:UIControlStateNormal];
        //Font
        btn_email.titleLabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        
        [btn_phone setTitle:[NSString stringWithFormat:@"%@",[[[[[appdelegate.about_us_dic_data valueForKey:@"photographerApp_cyber"]valueForKey:@"aboutUs"]valueForKey:@"mobible"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters]] forState:UIControlStateNormal];
        //Font
        btn_phone.titleLabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        
        [btn_website setTitle:[NSString stringWithFormat:@"%@",[[[[[appdelegate.about_us_dic_data valueForKey:@"photographerApp_cyber"]valueForKey:@"aboutUs"]valueForKey:@"web"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters]] forState:UIControlStateNormal];
        //Font
        btn_website.titleLabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [appdelegate analyticsEvent:@"ABOUT US"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)back_button_pressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(IBAction)call_number:(id)sender
{
    //[NSString stringWithFormat:@"%@",[[[[[appdelegate.dic_data valueForKey:@"photographerApp_cyber"]valueForKey:@"aboutUs"]valueForKey:@"pEmail"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters]]
    
    UIButton *btn=(UIButton *)sender;
    [appdelegate sendDataTogoogleAnalytics:[NSString stringWithFormat:@"%@ %@",AboutUsCallButton,[btn titleForState:UIControlStateNormal]]];
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"" message:[btn titleForState:UIControlStateNormal] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call", nil];
    [alert show];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        
    }
    else{
        UIApplication *myApp = [UIApplication sharedApplication];
        NSString *theCall = [NSString stringWithFormat:@"tel://%@",[btn_phone titleForState:UIControlStateNormal]];
        theCall=[theCall stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        theCall=[theCall stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        
        //NSLog(@"making call with %@",theCall);
        [myApp openURL:[NSURL URLWithString:theCall]];
    }
}

-(IBAction)open_website:(id)sender
{
    UIButton *btn=(UIButton *)sender;
     [appdelegate sendDataTogoogleAnalytics:[NSString stringWithFormat:@"%@ %@",AboutUsWebSiteButton,[btn titleForState:UIControlStateNormal]]];
    //str_url=[[NSString stringWithString:;
    NSString *    str_url=[NSString stringWithFormat:@"%@",[btn titleForState:UIControlStateNormal]];
    str_url=[str_url stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    str_url=[str_url stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",str_url]];
    if (![[UIApplication sharedApplication] openURL:url])
    {
        //NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }


}
-(IBAction)send_mail:(id)sender
{
    
    if ([MFMailComposeViewController canSendMail])
    {
        [appdelegate sendDataTogoogleAnalytics:[NSString stringWithFormat:@"%@",AboutUsEmailButton]];
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        NSArray *toRecipients = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",[[[[[appdelegate.about_us_dic_data valueForKey:@"photographerApp_cyber"]valueForKey:@"aboutUs"]valueForKey:@"email"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters]], nil];
        [mailer setToRecipients:toRecipients];
        [self presentModalViewController:mailer animated:YES];
        [mailer release];
    }
    else
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            //NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

@end
