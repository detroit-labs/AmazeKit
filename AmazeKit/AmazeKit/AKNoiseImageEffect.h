//
//  AKNoiseImageEffect.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/11/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageEffect.h"


typedef enum {
	AKNoiseTypeColor,
	AKNoiseTypeBlackAndWhite
} AKNoiseType;


@interface AKNoiseImageEffect : AKImageEffect

@property (assign) AKNoiseType	noiseType;

@end
