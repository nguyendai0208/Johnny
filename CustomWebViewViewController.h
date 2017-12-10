//
//  CustomWebViewViewController.h
//  PoeniCritics
//
//  Created by Kapova.
//
//

#import <UIKit/UIKit.h>

@interface CustomWebViewViewController : UIViewController
{
    UIView *view;
    UIView *behindview;
    UIWebView *webview;
    NSURL *webviewURL;
    UIButton *closeBtn;
    UIButton *safariBtn;
    UIButton *nextBtn;
    UIButton *PreviousBtn;
    BOOL isLoading;
    UILabel *textlabel;
    UIView *loadingView; // CE
}
@property (nonatomic, retain) UIView *loadingView; // CE
@property (retain, nonatomic) NSString* id_imdb;
@property (nonatomic, strong)NSURL *webviewURL;
@property (nonatomic, strong)UIButton *closeBtn;
@property (nonatomic, strong)UIButton *safariBtn;
@property (nonatomic, strong)UIButton *nextBtn;
@property (nonatomic, strong)UIButton *PreviousBtn;
@property (nonatomic, strong) NSString *labelName;
-(void)loadURLInWebview:(NSString *)str rowId:(int)rowindex lableText:(NSString *)text;
@end
