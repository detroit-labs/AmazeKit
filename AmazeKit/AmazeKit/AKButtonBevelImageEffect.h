//
//  AKButtonBevelImageEffect.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageEffect.h"


typedef enum {
	AKButtonBevelDirectionUp = 0,
	AKButtonBevelDirectionDown
} AKButtonBevelDirection;


@interface AKButtonBevelImageEffect : AKImageEffect

// “Up,” the default, has a shine on top and a shadow on bottom. “Down” is the reverse.
@property (readonly) AKButtonBevelDirection	bevelDirection;

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
	 bevelDirection:(AKButtonBevelDirection)bevelDirection;

@end
