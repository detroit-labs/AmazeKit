//
//  AKGradientImageEffect.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageEffect.h"


typedef enum {
	AKGradientDirectionVertical = 0,
	AKGradientDirectionHorizontal,
} AKGradientDirection;


@interface AKGradientImageEffect : AKImageEffect

// An array of UIColor objects for the gradient. Must be at least two.
@property (readonly) NSArray	*colors;

// The direction to draw the gradient in. Defaults to vertical.
@property (readonly) AKGradientDirection	direction;

// An array of NSNumber objects with values between 0 and 1. Represents the location along the
// gradient for the color at the corresponding index. If nil, the colors are spaced evenly.
@property (readonly) NSArray	*locations;

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			 colors:(NSArray *)colors
		  direction:(AKGradientDirection)direction
		  locations:(NSArray *)locations;

@end
