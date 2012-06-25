//
//  AKButtonBevelImageEffect.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageEffect.h"


typedef enum {
	AKButtonBevelDirectionUp,
	AKButtonBevelDirectionDown
} AKButtonBevelDirection;


@interface AKButtonBevelImageEffect : AKImageEffect

// “Up,” the default, has a shine on top and a shadow on bottom. “Down” is the reverse.
@property AKButtonBevelDirection	bevelDirection;

@end
