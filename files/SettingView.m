//
//  SettingView.m

//
//
//  Copyright (c) Kapova. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView
@synthesize isBookAnAppoitment;
@synthesize isLocateUSAvailabel;
@synthesize isPusNotification;
@synthesize isVideoAvailabel;
@synthesize  isAboutUS;
@synthesize colorBarButton;
@synthesize appBackgroundColor;


static SettingView* Shared = nil;

+ (SettingView*)sharedCache {
    if (!Shared) {
        Shared = [[SettingView alloc] init];
        
    }
    return Shared;
}

@end
