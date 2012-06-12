//
//  AKGradientImageEffect.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageEffect.h"


typedef enum {
	AKGradientDirectionHorizontal,
	AKGradientDirectionVertical
} AKGradientDirection;


@interface AKGradientImageEffect : AKImageEffect

// An array of UIColor objects for the gradient. Must be at least two.
@property (strong) NSArray	*colors;

// The direction to draw the gradient in. Defaults to vertical.
@property (assign) AKGradientDirection	direction;

// An array of NSNumber objects with values between 0 and 1. Represents the location along the
// gradient for the color at the corresponding index. If nil, the colors are spaced evenly.
@property (strong) NSArray	*locations;

@end
