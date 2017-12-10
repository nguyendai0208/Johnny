//
//  UIImage+Overlay.h
//  PortfolioApp
//
//  Created by Long Nguyen Vu on 1/24/14.
//  Copyright (c) 2014 cybervation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Overlay)

- (UIImage *)imageWithColor:(UIColor *)color1;
+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color drawAsOverlay:(BOOL)overlay;
@end
