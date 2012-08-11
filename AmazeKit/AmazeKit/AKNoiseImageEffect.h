//
//  AKNoiseImageEffect.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/11/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageEffect.h"


typedef enum {
	AKNoiseTypeBlackAndWhite = 0,
	AKNoiseTypeColor
} AKNoiseType;


@interface AKNoiseImageEffect : AKImageEffect

@property (assign, readonly) AKNoiseType	noiseType;

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
		  noiseType:(AKNoiseType)noiseType;

@end
