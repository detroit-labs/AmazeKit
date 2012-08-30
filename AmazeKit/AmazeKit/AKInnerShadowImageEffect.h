//
//  AKInnerShadowImageEffect.h
//  AmazeKit
//
//  Created by Jeff Kelley on 8/29/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageEffect.h"


@interface AKInnerShadowImageEffect : AKImageEffect

@property (readonly) UIColor	*color;
@property (readonly) CGFloat	radius;
@property (readonly) CGSize 	offset;

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			  color:(UIColor *)color
			 radius:(CGFloat)radius
			 offset:(CGSize)offset;

@end
