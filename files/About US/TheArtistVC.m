//
//  AboutusVC.m

//
//
//  Copyright (c) Kapova. All rights reserved.
//

#import "TheArtistVC.h"
#import "NSString+extras.h"
#import "UIImage+Overlay.h"

@interface TheArtistVC ()

@end

@implementation TheArtistVC

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
    
    _lbl_photography.text = [kArtist uppercaseString];
    _lbl_photography.textColor = [SettingView sharedCache].textColor;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        _imgview_title.frame=CGRectMake(0, 0, 768, 88);
        _lbl_photography.frame=CGRectMake(60, 20, 200, 44);
        _btn_photography.frame=CGRectMake(-10, 25, 50, 35);
        [_btn_photography setImage:[[UIImage imageNamed:@"BACKbtn_ipad.png"] imageWithColor:[SettingView sharedCache].colorBarButton] forState:UIControlStateNormal];
        
//        [_btn_photography setImage:[UIImage imageNamed:@"BACKbtn_ipad.png"] forState:UIControlStateNormal];
        lbl_name.frame=CGRectMake(30, 107, 300, 36);
        txt_desc.frame=CGRectMake(23, 161, 286, 156);
        //_lbl_photography.font = [UIFont fontWithName:@"Helvetica-Bold" size:34.0];
        //Font
        _lbl_photography.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:34];
        [imgview setImage:[UIImage imageNamed:@"ArtistPage_contact_bk_iPad.png" ]];
        imgview.frame=CGRectMake(28, 370, 282, 237);
        btn_email.frame=CGRectMake(40, 370, 276, 43);
        btn_phone.frame=CGRectMake(40, 420, 276, 43);
        btn_website.frame=CGRectMake(40, 470, 276, 43);
        btn_Facebook.frame=CGRectMake(47, 515, 276, 43);
        btn_twitter.frame=CGRectMake(44, 560, 276, 43);

        //              tableView.frame.size.height=88.0;
        self.view.frame=CGRectMake(0, 140, 768, self.view.frame.size.height-88);
    
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200,44)];
//        titleLabel.backgroundColor = [UIColor clearColor];
//        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:34.0];
//        titleLabel.textColor=[UIColor whiteColor];
//        titleLabel.textAlignment = UITextAlignmentCenter;
//        titleLabel.text = self.title;
//        self.navigationItem.titleView = titleLabel;
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
        [_btn_photography setImage:[[UIImage imageNamed:@"left_arrow.png"] imageWithColor:[SettingView sharedCache].colorBarButton] forState:UIControlStateNormal];
    }
    
    _btn_photography.tintColor = [SettingView sharedCache].colorBarButton;
    [_imgview_title setImage:[UIImage imageNamed:@"categoryHeader"]];
    
    if (appdelegate.dic_data)
    {
        lbl_name.text=[NSString stringWithFormat:@"%@",[[[[[appdelegate.dic_data valueForKey:@"photographerApp_about"]valueForKey:@"theArtist"]valueForKey:@"aName"]valueForKey:@"text"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        lbl_name.textColor = [SettingView sharedCache].textColor;
        //Font
        lbl_name.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        
        txt_desc.text=[NSString stringWithFormat:@"%@",[[[[[[appdelegate.dic_data valueForKey:@"photographerApp_about"]valueForKey:@"theArtist"]valueForKey:@"pAbout"]valueForKey:@"text"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        txt_desc.textColor = [SettingView sharedCache].textColor;
        //Font
        txt_desc.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        
        
        [btn_email setTitle:[NSString stringWithFormat:@"%@",[[[[[appdelegate.dic_data valueForKey:@"photographerApp_about"]valueForKey:@"theArtist"]valueForKey:@"pEmail"]valueForKey:@"text"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] forState:UIControlStateNormal];
        btn_email.titleLabel.textColor = [SettingView sharedCache].textColor;
        [btn_email setTitleColor:[SettingView sharedCache].textColor forState:UIControlStateNormal];
        [btn_email setTitleColor:[SettingView sharedCache].selectedTextColor forState:UIControlStateHighlighted];
        //Font
        btn_email.titleLabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        
        [btn_phone setTitle:[NSString stringWithFormat:@"%@",[[[[[appdelegate.dic_data valueForKey:@"photographerApp_about"]valueForKey:@"theArtist"]valueForKey:@"mobible"]valueForKey:@"text"]stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]] forState:UIControlStateNormal];
        btn_phone.titleLabel.textColor = [SettingView sharedCache].textColor;
        [btn_phone setTitleColor:[SettingView sharedCache].textColor forState:UIControlStateNormal];
        [btn_phone setTitleColor:[SettingView sharedCache].selectedTextColor forState:UIControlStateHighlighted];
        //Font
        btn_phone.titleLabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        [btn_website setTitle:[NSString stringWithFormat:@"%@",[[[[[appdelegate.dic_data valueForKey:@"photographerApp_about"]valueForKey:@"theArtist"]valueForKey:@"pWeb"]valueForKey:@"text"]stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]] forState:UIControlStateNormal];
        btn_website.titleLabel.textColor = [SettingView sharedCache].textColor;
        [btn_website setTitleColor:[SettingView sharedCache].textColor forState:UIControlStateNormal];
        [btn_website setTitleColor:[SettingView sharedCache].selectedTextColor forState:UIControlStateHighlighted];
        //Font
        btn_website.titleLabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        
         [btn_Facebook setTitle:[NSString stringWithFormat:@"%@",[[[[[appdelegate.dic_data valueForKey:@"photographerApp_about"]valueForKey:@"theArtist"]valueForKey:@"pFB"]valueForKey:@"text"]stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]] forState:UIControlStateNormal];
        btn_Facebook.titleLabel.textColor = [SettingView sharedCache].textColor;
        [btn_Facebook setTitleColor:[SettingView sharedCache].textColor forState:UIControlStateNormal];
        [btn_Facebook setTitleColor:[SettingView sharedCache].selectedTextColor forState:UIControlStateHighlighted];
        //Font
        btn_Facebook.titleLabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:14];
         [btn_twitter setTitle:[NSString stringWithFormat:@"%@",[[[[[appdelegate.dic_data valueForKey:@"photographerApp_about"]valueForKey:@"theArtist"]valueForKey:@"ptwitter"]valueForKey:@"text"]stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]] forState:UIControlStateNormal];
        btn_twitter.titleLabel.textColor = [SettingView sharedCache].textColor;
        [btn_twitter setTitleColor:[SettingView sharedCache].textColor forState:UIControlStateNormal];
        [btn_twitter setTitleColor:[SettingView sharedCache].selectedTextColor forState:UIControlStateHighlighted];
        //Font
        btn_twitter.titleLabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
    }
    //txt_desc.textAlignment = NSTextAlignmentJustified;
}

- (void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = [SettingView sharedCache].appBackgroundColor;
    [super viewWillAppear:animated];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [btnShare setImage:[[UIImage imageNamed:@"shareBTN_iPad.png"] imageWithColor:[SettingView sharedCache].colorBarButton] forState:UIControlStateNormal];
        btnShare.center = CGPointMake(723, 44);
    }
    else{
        [btnShare setImage:[[UIImage imageNamed:@"shareBTN_iPhone_7.png"] imageWithColor:[SettingView sharedCache].colorBarButton] forState:UIControlStateNormal];
        
    }
    
    btnShare.tintColor = [SettingView sharedCache].colorBarButton;
    //Font
    btnShare.titleLabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
     [appdelegate analyticsEvent:@"THE ARTIST"];
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
    UIButton *btn=(UIButton *)sender;
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"" message:[btn titleForState:UIControlStateNormal] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call", nil];
    [alert show];

    [appdelegate sendDataTogoogleAnalytics:[NSString stringWithFormat:@"%@ %@",ArtistCallButton,[btn titleForState:UIControlStateNormal]]];
    
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
//str_url=[[NSString stringWithString:;
    NSString *    str_url=[NSString stringWithFormat:@"%@",[btn titleForState:UIControlStateNormal]];
    [appdelegate sendDataTogoogleAnalytics:[NSString stringWithFormat:@"%@ %@",ArtistWebSiteButton,[btn titleForState:UIControlStateNormal]]];
    
    str_url=[str_url stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    str_url=[str_url stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",str_url]];
    if (![[UIApplication sharedApplication] openURL:url])
    {
        //NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
//[NSString stringWithFormat:@"%@",[[[[[appdelegate.dic_data valueForKey:@"photographerApp_about"]valueForKey:@"theArtist"]valueForKey:@"pEmail"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters]]
}
-(IBAction)send_mail:(id)sender
{
    
    if ([MFMailComposeViewController canSendMail])
    {
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        [appdelegate sendDataTogoogleAnalytics:[NSString stringWithFormat:@"%@",ArtistEmailButton]];
        mailer.mailComposeDelegate = self;
        NSArray *toRecipients = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",[[[[[appdelegate.dic_data valueForKey:@"photographerApp_about"]valueForKey:@"theArtist"]valueForKey:@"pEmail"]valueForKey:@"text"]stringByTrimmingLeadingWhitespaceAndNewlineCharacters]], nil];
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

- (void)dealloc {
    [btn_twitter release];
    if(btnShare)
    [btnShare release];
    [super dealloc];
}
- (void)viewDidUnload {
    [btn_twitter release];
    btn_twitter = nil;
    
    
    [super viewDidUnload];
}
- (IBAction)btn_facebookClicked:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    //str_url=[[NSString stringWithString:;
    NSString *    str_url=[NSString stringWithFormat:@"%@",[btn titleForState:UIControlStateNormal]];
    str_url=[str_url stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    str_url=[str_url stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSURL *url=[NSURL URLWithString:str_url];
    [appdelegate sendDataTogoogleAnalytics:[NSString stringWithFormat:@"%@",ArtistFacebookButton]];
    url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",str_url]];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://google.com"]];
    if (![[UIApplication sharedApplication] openURL:url])
    {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }

}

- (IBAction)btn_twitterClicked:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    //str_url=[[NSString stringWithString:;
    NSString *    str_url=[NSString stringWithFormat:@"%@",[btn titleForState:UIControlStateNormal]];
    str_url=[str_url stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    str_url=[str_url stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str_url=[str_url stringByReplacingOccurrencesOfString:@"@" withString:@""];
//    NSURL *url=[NSURL URLWithString:str_url];
    [appdelegate sendDataTogoogleAnalytics:[NSString stringWithFormat:@"%@",ArtistTwitterButton]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@",str_url]];
    [[UIApplication sharedApplication] openURL:url];
//    if (![[UIApplication sharedApplication] openURL:url])
//    {
//        //NSLog(@"%@%@",@"Failed to open url:",[url description]);
//    }
}

//d3H: show default action.

- (IBAction)pressShare:(id)sender{
   
    
    NSString *textObject = kShareTextArtist;
    NSString *urlString = kShareLinkApp;
    NSURL *url = [NSURL URLWithString:urlString];
    UIImage *image = [UIImage imageNamed:kShareIconName];
    
    NSArray *activityItems = [NSArray arrayWithObjects:textObject, url,
                                 image,
                              nil];
    
    
    UIActivityViewController *avc = [[[UIActivityViewController alloc]
                                      initWithActivityItems:activityItems
                                      applicationActivities:nil] autorelease];
    avc.excludedActivityTypes =
    [AppDelegate getArrayNotDisplay];
    [self presentViewController:avc animated:YES completion:nil];
    

}
@end
