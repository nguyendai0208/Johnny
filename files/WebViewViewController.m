//
//  WebViewViewController.m
//  PortfolioApp
//
//  Created by lithewall on 4/5/14.
//  Copyright (c) 2014 cybervation. All rights reserved.
//

#import "WebViewViewController.h"
#import "Global.h"
@interface WebViewViewController ()

@end

@implementation WebViewViewController

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
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    //D3H-IP: remove webView.
//    self.labelTitle.text = [self.dictWebInfo objectForKey:kHTMLDisplayName];
//    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:[self.dictWebInfo objectForKey:kHTMLFileName] ofType:@"html"];
    webView.scalesPageToFit = false;

    
    NSString *html = [NSString stringWithContentsOfFile:self.filePath
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
    [webView loadHTMLString:html
                    baseURL:[NSURL fileURLWithPath:
                             [NSString stringWithFormat:@"%@/",
                              [[NSBundle mainBundle] bundlePath]]
                             ]];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_labelTitle release];
    if(webView){
        [webView release];
    }
    if(self.filePath){
        self.filePath = nil;
    }
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLabelTitle:nil];
    [super viewDidUnload];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"Request info %@ relative string: %@",request, request.URL.relativeString);
    return YES;
}



- (IBAction)pressBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
