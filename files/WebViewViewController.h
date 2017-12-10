//
//  WebViewViewController.h
//  PortfolioApp
//
//  Created by lithewall on 4/5/14.
//  Copyright (c) 2014 cybervation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewViewController : UIViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *webView;
}
@property (assign, nonatomic) NSString *filePath;
@property (retain, nonatomic) IBOutlet UILabel *labelTitle;

@property (assign, nonatomic) NSDictionary *dictWebInfo;
@end
