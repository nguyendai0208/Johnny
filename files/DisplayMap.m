//
//  DisplayMap.m
//  MapKitDisplay
//
//  Created by Chakra on 12/07/10.
//  Copyright 2010 Kapova. All rights reserved.
//

#import "DisplayMap.h"


@implementation DisplayMap

@synthesize coordinate,title,subtitle;


-(void)dealloc{
	[title release];
	[super dealloc];
}

@end