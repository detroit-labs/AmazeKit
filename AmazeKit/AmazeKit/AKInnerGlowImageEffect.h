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
@property (readonly) UIColor	*color;

// The radius of the glow, in points.
@property (readonly) CGFloat	radius;

// If you know the middle is opaque, set this for performance benefits.
@property (readwrite, nonatomic, assign) CGFloat	maxEdgeDistance;

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			  color:(UIColor *)color
			 radius:(CGFloat)radius;

@end
