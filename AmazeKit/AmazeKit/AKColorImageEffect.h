//
//  AKColorImageEffect.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageEffect.h"


// KVO Constants
extern NSString * const AKColorImageEffectColorKeyPath;


@interface AKColorImageEffect : AKImageEffect

// The color to paint in the image.
@property (readonly) UIColor	*color;

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			  color:(UIColor *)color;

@end
