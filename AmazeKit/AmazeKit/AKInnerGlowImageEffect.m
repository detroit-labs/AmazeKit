//
//  AKInnerGlowImageEffect.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/25/12.
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


#import "AKInnerGlowImageEffect.h"

#import "UIImage+AZKPixelData.h"

#import "AKDrawingUtilities.h"


static const CGFloat kDefaultRadius = 10.0f;


@implementation AKInnerGlowImageEffect

- (id)initWithAlpha:(CGFloat)alpha blendMode:(CGBlendMode)blendMode
{
	return [super initWithAlpha:alpha
					  blendMode:blendMode
						  color:[UIColor blackColor]
						 radius:kDefaultRadius
						 offset:CGSizeZero];
}

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			  color:(UIColor *)color
			 radius:(CGFloat)radius
{
	return [super initWithAlpha:alpha
					  blendMode:blendMode
						  color:color
						 radius:radius
						 offset:CGSizeZero];
}

@end
