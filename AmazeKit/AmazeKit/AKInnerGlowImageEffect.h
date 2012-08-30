//
//  AKInnerGlowImageEffect.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/25/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKInnerShadowImageEffect.h"


@interface AKInnerGlowImageEffect : AKInnerShadowImageEffect

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			  color:(UIColor *)color
			 radius:(CGFloat)radius;

@end
