//
//  AKMutableColorImageEffect.m
//  AmazeKit
//
//  Created by Jeff Kelley on 8/11/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKMutableColorImageEffect.h"


@implementation AKMutableColorImageEffect

@synthesize color = _color;

+ (BOOL)isImmutable
{
	return NO;
}

@end
