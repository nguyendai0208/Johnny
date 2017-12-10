//
//  LBYouTubePlayerController.m
//  LBYouTubeView
//
//  Created by Laurin Brandner on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LBYouTubePlayerController.h"

@interface LBYouTubePlayerController () 

@property (nonatomic, strong) LBYouTubeExtractor* extractor;

-(void)_setupWithYouTubeURL:(NSURL*)URL quality:(LBYouTubeVideoQuality)quality;

-(void)_didSuccessfullyExtractYouTubeURL:(NSURL*)videoURL;
-(void)_failedExtractingYouTubeURLWithError:(NSError*)error;

@end
@implementation LBYouTubePlayerController

@synthesize delegate, extractor;
@synthesize hud;

#pragma mark Initialization

-(id)initWithYouTubeURL:(NSURL *)URL quality:(LBYouTubeVideoQuality)quality {
    
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    for (NSString* parameter in [URL.query componentsSeparatedByString:@"&"]) {
        NSArray* pair = [parameter componentsSeparatedByString:@"="];
        if([pair count] == 2) {
            [parameters setObject:pair[1] forKey:pair[0]];
        }
    }
    [UIApplication sharedApplication].statusBarHidden=YES;
    return [self initWithYouTubeID:parameters[@"v"] quality:quality];
}

- (void)setURL:(NSURL *)URL quality:(LBYouTubeVideoQuality)quality {
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    for (NSString* parameter in [URL.query componentsSeparatedByString:@"&"]) {
        NSArray* pair = [parameter componentsSeparatedByString:@"="];
        if([pair count] == 2) {
            [parameters setObject:pair[1] forKey:pair[0]];
        }
    }
    [self _setupWithYouTubeURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", parameters[@"v"]]] quality:quality];
}
- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}
-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if (toInterfaceOrientation==UIInterfaceOrientationPortrait || toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    }
    return NO;
}

-(id)initWithYouTubeID:(NSString *)youTubeID quality:(LBYouTubeVideoQuality)quality {
    self = [super init];
    if (self) {
        [self _setupWithYouTubeURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", youTubeID]] quality:quality];
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Please Wait...";

    }
    return self;
}

-(void)_setupWithYouTubeURL:(NSURL *)URL quality:(LBYouTubeVideoQuality)quality {
    self.delegate = nil;
    
    self.extractor = [[LBYouTubeExtractor alloc] initWithURL:URL quality:quality];
    self.extractor.delegate = self;
    [self.extractor startExtracting];
}

#pragma mark -
#pragma mark Memory

-(void)dealloc {
    self.extractor.delegate = nil;
}

#pragma mark -
#pragma mark Delegate Calls

-(void)_didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL {
    if ([self.delegate respondsToSelector:@selector(youTubePlayerViewController:didSuccessfullyExtractYouTubeURL:)]) {
        [self.delegate youTubePlayerViewController:self didSuccessfullyExtractYouTubeURL:videoURL];
    }
}

-(void)_failedExtractingYouTubeURLWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(youTubePlayerViewController:failedExtractingYouTubeURLWithError:)]) {
        [self.delegate youTubePlayerViewController:self failedExtractingYouTubeURLWithError:error];
    }
}

#pragma mark -
#pragma mark LBYouTubeExtractorDelegate

-(void)youTubeExtractor:(LBYouTubeExtractor *)extractor didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL {
    [self _didSuccessfullyExtractYouTubeURL:videoURL];
    
   
    self.contentURL = videoURL;
    self.controlStyle=MPMovieControlStyleFullscreen;
    [self play];
     [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)youTubeExtractor:(LBYouTubeExtractor *)extractor failedExtractingYouTubeURLWithError:(NSError *)error {
    [self _failedExtractingYouTubeURLWithError:error];
}

#pragma mark -

@end
