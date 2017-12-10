//
//  SettingView.h

//
//
//  Copyright (c) Kapova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingView : NSObject
{
    BOOL isVideoAvailabel;
    BOOL isLocateUSAvailabel;
    BOOL isBookAnAppoitment;
    BOOL isPusNotification;
    BOOL isAboutUS;
    UIColor* colorBarButton;
    UIColor* textColor;
    UIColor* selectedTextColor;
    UIColor* appBackgroundColor;
}

@property (nonatomic) BOOL isVideoAvailabel;
@property (nonatomic)BOOL isLocateUSAvailabel;
@property (nonatomic)BOOL isBookAnAppoitment;
@property (nonatomic)BOOL isPusNotification;
@property (nonatomic)BOOL isAboutUS;
@property (nonatomic) BOOL isHTML1Available;
@property (nonatomic) BOOL isHTML2Available;
@property (nonatomic) BOOL isHTML3Available;
@property (nonatomic) BOOL isNewsAndEvents;
@property (nonatomic) BOOL isDisplayPhotographer;

@property (nonatomic, strong)UIColor* colorBarButton;
@property (nonatomic, strong)UIColor* textColor;
@property (nonatomic, strong)UIColor* selectedTextColor;
@property (nonatomic, strong)UIColor* appBackgroundColor;
//Font name & font size
@property (nonatomic, retain) NSString* fontName;

+ (SettingView*)sharedCache;

@end
