//
//  AKCornerRadiusImageEffect.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2013 Detroit Labs. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
@property (readonly) AKCornerRadii	cornerRadii;

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
		cornerRadii:(AKCornerRadii)cornerRadii;

@end
