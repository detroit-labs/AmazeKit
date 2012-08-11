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

NSString *NSStringFromAKCornerRadii(AKCornerRadii radii);
AKCornerRadii AKCornerRadiiFromNSString(NSString *string);

extern const AKCornerRadii AKCornerRadiiZero;

@interface AKCornerRadiusImageEffect : AKImageEffect

// The corner radii can be set independently.
@property (assign, readonly) AKCornerRadii	cornerRadii;

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
		cornerRadii:(AKCornerRadii)cornerRadii;

@end
