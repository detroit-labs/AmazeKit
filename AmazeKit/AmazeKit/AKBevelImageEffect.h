//
//  AKBevelImageEffect.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageEffect.h"


@interface AKBevelImageEffect : AKImageEffect

// The color of the bevel.
@property (strong) UIColor	*color;

// The maximum radius of the bevel.
@property (assign) CGFloat	radius;

@end
