//
//  CustomWebViewViewController.m
//  PoeniCritics
//
//  Created by Kapova.
//
//

#import "CustomWebViewViewController.h"
#import "Global.h"
#import "UIImage+Overlay.h"

@interface CustomWebViewViewController ()<UIWebViewDelegate>

@end

@implementation CustomWebViewViewController

@synthesize safariBtn;
@synthesize nextBtn;
@synthesize PreviousBtn;
@synthesize closeBtn;
@synthesize webviewURL;
@synthesize loadingView;

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
    
    self.view.backgroundColor = [SettingView sharedCache].appBackgroundColor;
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    if(self.labelName){
        textlabel.text = [self.labelName uppercaseString];
        
    }else{
        textlabel.text = [kAppointment uppercaseString];
    }
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Webview Methods

-(void) InitializeWebView
{
    
    webview=[[[UIWebView alloc]init]autorelease];
    CGRect viewframe=self.view.frame;
    behindview=[[[UIView alloc]initWithFrame:CGRectMake(0,0,viewframe.size.width, viewframe.size.height)]autorelease];
    behindview.backgroundColor=[UIColor darkGrayColor];
    
    view=[[[UIView alloc]initWithFrame:CGRectMake(0,0,viewframe.size.width, viewframe.size.height)]autorelease];
    view.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleTopMargin;
   
    UIView *closebuttonview;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        webview.frame=CGRectMake(view.frame.origin.x,view.frame.origin.y+88,view.frame.size.width, view.frame.size.height);
        webview.autoresizingMask=  UIViewAutoresizingFlexibleBottomMargin ;
        webview.delegate=self;
        closebuttonview=[[[UIView alloc]initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 88)]autorelease];
        
        
        UIColor *color = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"categoryHeader"]];
        closebuttonview.backgroundColor = color;
        [color release];
        
        closebuttonview.backgroundColor=[[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"categoryHeader"]]autorelease];
        //[closebuttonview setBackgroundColor:[UIColor blackColor]];
        
        [view addSubview:webview];
        [view addSubview:closebuttonview];
        [webview setBackgroundColor:[UIColor clearColor]];
        [webview setClipsToBounds:YES];
        [behindview addSubview:view];
        
        
        [self.view addSubview:behindview];
        //    CGRect finalFrame = behindview.frame;
        //    [behindview setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        //    [UIView animateWithDuration:0.3 animations:^{
        //        //        [self.navigationController setNavigationBarHidden:YES];
        //        [self.view addSubview:behindview];
        //        [behindview setFrame:finalFrame];
        //    }];
        
        
        self.closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        [self.closeBtn setImage:[UIImage imageNamed:@"BACKbtn_ipad.png"] forState:UIControlStateNormal];
        [self.closeBtn setImage:[[UIImage imageNamed:@"BACKbtn_ipad.png"] imageWithColor:[SettingView sharedCache].colorBarButton] forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(CloseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.closeBtn.frame=CGRectMake(closebuttonview.frame.origin.x+12, 20, 50, 50);
        
        self.safariBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.safariBtn setImage:[UIImage imageNamed:@"safari"] forState:UIControlStateNormal];
        [self.safariBtn addTarget:self action:@selector(SafariClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.safariBtn.frame=CGRectMake(closebuttonview.frame.origin.x+60, 12,23,23);
        
        self.PreviousBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.PreviousBtn setImage:[UIImage imageNamed:@"back_active"] forState:UIControlStateNormal];
        [self.PreviousBtn addTarget:self action:@selector(goBackClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.PreviousBtn.frame=CGRectMake(closebuttonview.frame.size.width-60, 12, 23, 23);
        
        self.nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [ self.nextBtn setImage:[UIImage imageNamed:@"forword_active"] forState:UIControlStateNormal];
        [ self.nextBtn addTarget:self action:@selector(goNextClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.nextBtn.frame=CGRectMake(closebuttonview.frame.size.width-30, 12, 23, 23);
        
        textlabel=[[UILabel alloc]initWithFrame:CGRectMake(180, 0, 400, 88)];
        if(self.labelName){
            textlabel.text = [self.labelName uppercaseString];

        }else{
            textlabel.text = [kAppointment uppercaseString];
        }
        
        //textlabel.font=[UIFont boldSystemFontOfSize:34];
        //Font
        textlabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:34];
        textlabel.textAlignment=UITextAlignmentCenter;
        textlabel.textColor = [SettingView sharedCache].textColor;
        textlabel.backgroundColor=[UIColor clearColor];

        [closebuttonview setClipsToBounds:YES];

        [closebuttonview addSubview:self.closeBtn];
        [closebuttonview addSubview:textlabel];
        //    [closebuttonview bringSubviewToFront:button];
        
        
    }
    else{
        webview.frame=CGRectMake(view.frame.origin.x,view.frame.origin.y+45,view.frame.size.width, view.frame.size.height);
        webview.autoresizingMask=  UIViewAutoresizingFlexibleBottomMargin ;
        webview.delegate=self;
        closebuttonview=[[[UIView alloc]initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 45)]autorelease];
        UIColor *color = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"categoryHeader"]];
        closebuttonview.backgroundColor = color;
        [color release];
        
        closebuttonview.backgroundColor=[[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"categoryHeader"]]autorelease];
        //[closebuttonview setBackgroundColor:[UIColor blackColor]];
        
        [view addSubview:webview];
        [view addSubview:closebuttonview];
        [webview setBackgroundColor:[UIColor clearColor]];
        [webview setClipsToBounds:YES];
        [behindview addSubview:view];
        
        
        [self.view addSubview:behindview];
        
        
        self.closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        [self.closeBtn setImage:[UIImage imageNamed:@"left_arrow.png"] forState:UIControlStateNormal];
        [self.closeBtn setImage:[[UIImage imageNamed:@"left_arrow.png"] imageWithColor:[SettingView sharedCache].colorBarButton] forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(CloseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        self.closeBtn.frame=CGRectMake(closebuttonview.frame.origin.x+14, 3, 23, 44);
        
        self.safariBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.safariBtn setImage:[UIImage imageNamed:@"safari"] forState:UIControlStateNormal];
        [self.safariBtn addTarget:self action:@selector(SafariClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.safariBtn.frame=CGRectMake(closebuttonview.frame.origin.x+60, 12,23,23);
        
        self.PreviousBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.PreviousBtn setImage:[UIImage imageNamed:@"back_active"] forState:UIControlStateNormal];
        [self.PreviousBtn addTarget:self action:@selector(goBackClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.PreviousBtn.frame=CGRectMake(closebuttonview.frame.size.width-60, 12, 23, 23);
        
        self.nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [ self.nextBtn setImage:[UIImage imageNamed:@"forword_active"] forState:UIControlStateNormal];
        [ self.nextBtn addTarget:self action:@selector(goNextClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.nextBtn.frame=CGRectMake(closebuttonview.frame.size.width-30, 12, 23, 23);
        textlabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
        if(self.labelName){
            textlabel.text = [self.labelName uppercaseString];
            
        }else{
            textlabel.text = [kAppointment uppercaseString];
        }
        
        //textlabel.font=[UIFont boldSystemFontOfSize:17];
        //Font
        textlabel.font = [UIFont fontWithName:[SettingView sharedCache].fontName size:17];
        textlabel.textAlignment=UITextAlignmentCenter;
        textlabel.textColor = [SettingView sharedCache].textColor;
        textlabel.backgroundColor=[UIColor clearColor];
        //    [[closebuttonview layer] setCornerRadius:5];
        [closebuttonview setClipsToBounds:YES];

        [closebuttonview addSubview:self.closeBtn];
        [closebuttonview addSubview:textlabel];
        //    [closebuttonview bringSubviewToFront:button];
    }
   
    
   
    
}
-(void)CloseButtonClicked:(id)sender
{
    //    webview=nil;
    //    behindview=nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
//    CGRect finalFrame =CGRectMake(0, self.view.frame.size.height+110, self.view.frame.size.width, self.view.frame.size.height) ;
//    [behindview setFrame:behindview.frame];
//    [UIView animateWithDuration:0.3 animations:^{
//        [behindview setFrame:finalFrame];
//        
//    }];
}
-(void)SafariClicked:(id)sender
{
    [[UIApplication sharedApplication]openURL:self.webviewURL];
}
-(void)goBackClicked:(id)sender
{
    [webview goBack];
}
-(void)goNextClicked:(id)sender
{
    [webview goForward];
}

// Load URL in web view for different media

-(void)loadURLInWebview:(NSString *)str rowId:(int)rowindex lableText:(NSString *)text
{
    [self InitializeWebView];
    NSURLRequest *request = nil ;

    if ([str rangeOfString:@"http://"].location == NSNotFound && [str rangeOfString:@"https://"].location == NSNotFound) {

        webview.scalesPageToFit = false;
        
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:str ofType:@"html"];
        
        NSString *html = [NSString stringWithContentsOfFile:htmlPath
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
        NSURL *url = [NSURL fileURLWithPath:
                      [NSString stringWithFormat:@"%@/",
                       [[NSBundle mainBundle] bundlePath]]
                      ];
        request=  [NSURLRequest requestWithURL:url];
        self.webviewURL=request.URL;
        
        [webview loadHTMLString:html baseURL:[NSURL fileURLWithPath:
                                              [NSString stringWithFormat:@"%@/",
                                               [[NSBundle mainBundle] bundlePath]]
                                              ]];

        
    }
    else {
        NSURL *url = [NSURL URLWithString:str];
        request=  [NSURLRequest requestWithURL:url];
        self.webviewURL=request.URL;
        [webview loadRequest:request];
    }
    
    
    
    

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    if(isLoading==NO)
    {
//        loadingView = [PoeniCriticsDAO allocGetLoadingScreen];
        [webview addSubview:loadingView];
    }
    isLoading=YES;
    [self UpdateToolbar];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webviewURL=webView.request.URL;
    [loadingView removeFromSuperview];
    isLoading=NO;
    [self UpdateToolbar];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self UpdateToolbar];
}
-(void)UpdateToolbar
{
    self.PreviousBtn.enabled=webview.canGoBack;
    self.nextBtn.enabled=webview.canGoForward;
}

- (void)dealloc{
    [super dealloc];
    
    if(textlabel){
        textlabel = nil;
    }
}
@end
