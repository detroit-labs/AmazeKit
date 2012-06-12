//
//  AKImageEffect.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/11/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageEffect.h"


@implementation AKImageEffect

@synthesize alpha = _alpha;
@synthesize blendMode = _blendMode;

- (id)init
{
	self = [super init];
	
	if (self) {
		_alpha = 1.0f;
		_blendMode = kCGBlendModeNormal;
	}
	
	return self;
}

- (void)applyAppearanceProperties
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetAlpha(context, [self alpha]);
	CGContextSetBlendMode(context, [self blendMode]);

	// TODO: Add more appearance properties.
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	// The default operation is a no-op.
	return sourceImage;
}

@end
