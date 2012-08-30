//
//  AKInnerGlowImageEffect.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/25/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKInnerGlowImageEffect.h"

#import "UIImage+AKPixelData.h"

#import "AKDrawingUtilities.h"


static const CGFloat kDefaultRadius = 10.0f;


@implementation AKInnerGlowImageEffect

- (id)initWithAlpha:(CGFloat)alpha blendMode:(CGBlendMode)blendMode
{
	return [super initWithAlpha:alpha
					  blendMode:blendMode
						  color:[UIColor blackColor]
						 radius:kDefaultRadius
						 offset:CGSizeZero];
}

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			  color:(UIColor *)color
			 radius:(CGFloat)radius
{
	return [super initWithAlpha:alpha
					  blendMode:blendMode
						  color:color
						 radius:radius
						 offset:CGSizeZero];
}

@end
