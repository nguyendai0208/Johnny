//
//  UINavigationController+autorotate.m
//  
//


#import "UINavigationController+autorotate.h"
#import "KTPhotoScrollViewController.h"
#import "SDWebImageRootViewController.h"
#import "MWPhotoBrowser.h"
@implementation UINavigationController (autorotate)
- (NSUInteger)supportedInterfaceOrientations
{
    if ([[[self viewControllers] lastObject] isKindOfClass:[MWPhotoBrowser class]])
    {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}
@end