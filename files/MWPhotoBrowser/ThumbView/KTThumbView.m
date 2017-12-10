//
//  KTThumbView.m
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/3/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTThumbView.h"
#import "KTThumbsViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation KTThumbView

@synthesize controller = controller_;
@synthesize activityIndicator=_activityIndicator;
- (void)dealloc 
{
   [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
   if (self = [super initWithFrame:frame]) {

      [self addTarget:self
               action:@selector(didTouch:)
     forControlEvents:UIControlEventTouchUpInside];
       self.activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
       if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
       {
           self.activityIndicator.center= CGPointMake(64,64);
       }
       else{
          self.activityIndicator.center= CGPointMake(25+12.5,25+12.5); 
       }

       
       [self addSubview:self.activityIndicator];
       [self.activityIndicator stopAnimating];
       [self.activityIndicator setHidesWhenStopped:YES];
       //[self.activityIndicator setFrame:self.frame];
       //
      [self setClipsToBounds:YES];
      // If the thumbnail needs to be scaled, it should mantain its aspect
      // ratio.
      [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
   }
   return self;
}

- (void)didTouch:(id)sender 
{
   if (controller_)
   {
      [controller_ didSelectThumbAtIndex:[self tag]];
   }
}

- (void)setThumbImage:(UIImage *)newImage 
{
    [self setImage:newImage forState:UIControlStateNormal];
}

- (void)setHasBorder:(BOOL)hasBorder
{
   if (hasBorder) {
      self.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
      self.layer.borderWidth = 1;
   } else {
      self.layer.borderColor = nil;
   }
}


@end
