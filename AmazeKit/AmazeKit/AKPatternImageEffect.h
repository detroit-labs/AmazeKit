//
//  AKPatternImageEffect.h
//  AmazeKit
//
//  Created by Jeff Kelley on 7/26/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageEffect.h"


@interface AKPatternImageEffect : AKImageEffect

@property (strong, readonly) UIImage	*patternImage;

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
	   patternImage:(UIImage *)patternImage;

@end
