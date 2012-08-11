//
//  AKInnerGlowImageEffect.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/25/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageEffect.h"


@interface AKInnerGlowImageEffect : AKImageEffect

// The color of the glow. Defaults to white.
@property (strong, readonly) UIColor	*color;

// The radius of the glow, in points.
@property (assign, readonly) CGFloat	radius;

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			  color:(UIColor *)color
			 radius:(CGFloat)radius;

@end
