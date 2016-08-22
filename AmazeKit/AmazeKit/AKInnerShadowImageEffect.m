//
//  AKInnerShadowImageEffect.m
//  AmazeKit
//
//  Created by Jeff Kelley on 8/29/12.
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


#import "AKInnerShadowImageEffect.h"

#import "UIColor+AZKColorStrings.h"
#import "UIImage+AZKMasking.h"


// Defaults
static const CGFloat kDefaultRadius = 10.0f;

// Archiving Keys
static NSString * const kColorKey = @"color";
static NSString * const kRadiusKey = @"radius";
static NSString * const kOffsetKey = @"offset";


@implementation AKInnerShadowImageEffect

@synthesize color = _color;
@synthesize radius = _radius;
@synthesize offset = _offset;

#pragma mark - Object Lifecycle

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
{
	self = [super initWithAlpha:alpha blendMode:blendMode];
	
	if (self) {
		_color = [UIColor blackColor];
		_radius = kDefaultRadius;
		_offset = CGSizeZero;
	}
	
	return self;
}

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			  color:(UIColor *)color
			 radius:(CGFloat)radius
			 offset:(CGSize)offset
{
	self = [super initWithAlpha:alpha blendMode:blendMode];
	
	if (self) {
		_color = color;
		_radius = radius;
		_offset = offset;
	}
	
	return self;
}

#pragma mark - Image Effect Lifecycle

+ (BOOL)canRenderIndividually
{
	return NO;
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	UIImage *reverseMask = sourceImage.azk_reverseMaskImageNoFeather;
	
	CGSize originalImageSize = [sourceImage size];
	CGFloat originalImageWidth = originalImageSize.width;
	CGFloat originalImageHeight = originalImageSize.height;
	CGFloat radius = [self radius];
	CGFloat frameWidth = originalImageWidth + (2.0f * radius);
	CGFloat frameHeight = originalImageHeight + (2.0f * radius);
	
	// Context 1: Draw the outline of the view to use it to cast a shadow
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(frameWidth,
													  frameHeight),
										   NO,
										   [sourceImage scale]);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect bounds = CGContextGetClipBoundingBox(context);
	
	CGContextSetFillColorWithColor(context, [[self color] CGColor]);
	
	CGContextTranslateCTM(context, 0.0f, frameHeight);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	
	// Color in the top, left, right, and bottom.
	CGContextFillRect(context, CGRectMake(0.0f, 0.0f, frameWidth, radius));
	CGContextFillRect(context, CGRectMake(0.0f, 0.0f, radius, frameHeight));
	CGContextFillRect(context, CGRectMake(originalImageWidth + radius, 0.0f, radius, frameHeight));
	CGContextFillRect(context, CGRectMake(0.0f, originalImageHeight + radius, frameWidth, radius));
	
	CGContextClipToMask(context,
						CGRectMake(radius,
								   radius,
								   originalImageWidth,
								   originalImageHeight),
						[reverseMask CGImage]);
	
	CGContextFillRect(context, bounds);
	
	UIImage *shadowCastingImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	// Context 2: Draw the outer border with a shadow, maksed to the original image
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(frameWidth,
													  frameHeight),
										   NO,
										   [sourceImage scale]);
	
	context = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(context, 0.0f, frameHeight);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	
	CGRect originalImageRect = CGRectMake(radius,
										  radius,
										  originalImageWidth,
										  originalImageHeight);
	
	CGContextClipToMask(context, originalImageRect, [sourceImage CGImage]);
	
	CGContextSetShadowWithColor(context, [self offset], radius, [[self color] CGColor]);
	
	CGContextDrawImage(context,
					   CGRectMake(0.0f, 0.0f, frameWidth, frameHeight),
					   [shadowCastingImage CGImage]);
	
	UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	// Context 3: Draw the image with shadow in a smaller context to return an image with the same
	//            size as our original.
	UIGraphicsBeginImageContextWithOptions(originalImageSize, NO, [sourceImage scale]);
	
	context = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(context, 0.0f, originalImageHeight);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	
	CGContextClipToMask(context, CGContextGetClipBoundingBox(context), [sourceImage CGImage]);
	
	CGContextDrawImage(context, CGRectMake(-radius,
										   -radius,
										   frameWidth,
										   frameHeight),
					   [maskedImage CGImage]);
	
	UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	// Context 4: Render the original image, then the shadow with appearance options.
	UIGraphicsBeginImageContextWithOptions(originalImageSize, NO, [sourceImage scale]);
	context = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(context, 0.0f, originalImageHeight);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, originalImageWidth, originalImageHeight), [sourceImage CGImage]);
	
	[self applyAppearanceProperties];
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, originalImageWidth, originalImageHeight), [shadowImage CGImage]);
	
	UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return renderedImage;
}

- (NSDictionary *)representativeDictionary
{
	NSMutableDictionary *dictionary = [[super representativeDictionary] mutableCopy];
	
	[dictionary setObject:self.color.azk_hexString forKey:kColorKey];
	[dictionary setObject:@([self radius]) forKey:kRadiusKey];
	[dictionary setObject:NSStringFromCGSize([self offset]) forKey:kOffsetKey];
	
	return [NSDictionary dictionaryWithDictionary:dictionary];
}

#pragma mark -

@end
