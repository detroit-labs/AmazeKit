//
//  AKCornerRadiusImageEffect.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageEffect.h"


typedef struct {
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
} AKCornerRadii;

static inline AKCornerRadii
AKCornerRadiiMake(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight)
{
	AKCornerRadii radii;
	
	radii.topLeft = topLeft;
	radii.topRight = topRight;
	radii.bottomLeft = bottomLeft;
	radii.bottomRight = bottomRight;

	return radii;
}

@interface AKCornerRadiusImageEffect : AKImageEffect

// The corner radii can be set independently.
@property (assign) AKCornerRadii	cornerRadii;

@end
