//
//  AKMaskImageEffect.m
//  AmazeKit
//
//  Created by Jeff Kelley on 8/6/12.
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


#import "AKMaskImageEffect.h"

#import "UIImage+AKCryptography.h"


// Constants
NSString * const kMaskImageHashKey = @"maskImageHash";


@implementation AKMaskImageEffect {
	NSString	*_maskImageHash;
}

@synthesize maskImage = _maskImage;

+ (BOOL)canRenderIndividually
{
	return NO;
}

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
		  maskImage:(UIImage *)maskImage
{
	self = [self initWithAlpha:alpha blendMode:blendMode];
	
	if (self) {
		_maskImage = maskImage;
		_maskImageHash = [maskImage AK_sha1Hash];
	}
	
	return self;
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	CGImageRef maskImageRef = [[self maskImage] CGImage];
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();

	CGContextRef context = CGBitmapContextCreate(NULL,
												 CGImageGetWidth(maskImageRef),
												 CGImageGetHeight(maskImageRef),
												 8,
												 CGImageGetWidth(maskImageRef),
												 colorSpace,
												 kCGImageAlphaNone);
	
	CGContextDrawImage(context,
					   CGRectMake(0.0f,
								  0.0f,
								  CGImageGetWidth(maskImageRef),
								  CGImageGetHeight(maskImageRef)),
					   maskImageRef);
	
	CGImageRef maskImage = CGBitmapContextCreateImage(context);
		
	CGImageRef maskedOriginalImage = CGImageCreateWithMask([sourceImage CGImage], maskImage);
	
	UIImage *renderedImage = [[UIImage alloc] initWithCGImage:maskedOriginalImage
														scale:[sourceImage scale]
												  orientation:[sourceImage imageOrientation]];
	CGImageRelease(maskedOriginalImage);
	CGImageRelease(maskImage);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
	return renderedImage;
}

- (NSDictionary *)representativeDictionary
{
	NSMutableDictionary *dictionary = [[super representativeDictionary] mutableCopy];
	
	[dictionary setObject:_maskImageHash forKey:kMaskImageHashKey];
	
	return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
