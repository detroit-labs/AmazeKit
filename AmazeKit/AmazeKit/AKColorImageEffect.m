//
//  AKColorImageEffect.m
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

#import "AKColorImageEffect.h"

#import "UIColor+AZKColorStrings.h"


// KVO Constants
NSString * const AKColorImageEffectColorKeyPath = @"color";


@implementation AKColorImageEffect

@synthesize color = _color;

+ (BOOL)canRenderIndividually
{
	// A color effect *could* render individually, but rendering the color should be more efficient
	// than loading and rendering an image of the color. Also, it’ll cut down on files cached on the
	// device if colors change.
	return NO;
}

- (id)init
{
	self = [super init];
	
	if (self) {
		_color = [UIColor blackColor];
	}
	
	return self;
}

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
{
	self = [super initWithAlpha:alpha blendMode:blendMode];
	
	if (self) {
		_color = [UIColor blackColor];
	}
	
	return self;
}

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			  color:(UIColor *)color
{
	self = [self initWithAlpha:alpha blendMode:blendMode];
	
	if (self) {
		_color = color;
	}
	
	return self;
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	CGSize size = [sourceImage size];
	CGFloat scale = [sourceImage scale];
	CGImageRef sourceCGImage = [sourceImage CGImage];
	
	UIGraphicsBeginImageContextWithOptions(size, NO, scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(context, 0.0f, size.height);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	
	CGRect imageRect = CGContextGetClipBoundingBox(context);
	
	CGContextDrawImage(context, imageRect, sourceCGImage);
	
	[self applyAppearanceProperties];
	
	CGContextSetFillColorWithColor(context, [[self color] CGColor]);
	CGContextFillRect(context, imageRect);

	UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	context = NULL;
	
	return renderedImage;
}

- (NSDictionary *)representativeDictionary
{
	NSMutableDictionary *dictionary = [[super representativeDictionary] mutableCopy];
	
	[dictionary setObject:self.color.azk_hexString
                   forKey:AKColorImageEffectColorKeyPath];
	
	return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (id)initWithRepresentativeDictionary:(NSDictionary *)representativeDictionary
{
	self = [super initWithRepresentativeDictionary:representativeDictionary];
	
	if (self) {
		_color = [UIColor azk_colorWithHexString:[representativeDictionary objectForKey:AKColorImageEffectColorKeyPath]];
	}
	
	return self;
}

@end
