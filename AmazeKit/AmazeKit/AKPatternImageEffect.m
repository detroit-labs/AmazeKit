//
//  AKPatternImageEffect.m
//  AmazeKit
//
//  Created by Jeff Kelley on 7/26/12.
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


#import "AKPatternImageEffect.h"

#import "UIImage+AZKCryptography.h"

#import "AKDrawingUtilities.h"


// Constants
NSString * const kPatternImageHashKey = @"patternImageHash";


@implementation AKPatternImageEffect {
	NSString	*_patternImageHash;
}

@synthesize patternImage = _patternImage;

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
	   patternImage:(UIImage *)patternImage
{
	self = [self initWithAlpha:alpha blendMode:blendMode];
	
	if (self) {
		_patternImage = patternImage;
		_patternImageHash = patternImage.azk_sha1Hash;
	}
	
	return self;
}

- (UIImage *)renderedImageForSize:(CGSize)size
						  atScale:(CGFloat)scale
{
	CGImageRef patternTileImageRef = [[self patternImage] CGImage];
	CGSize patternImageSize = AKCGSizeMakeWithScale([[self patternImage] size],
													[[self patternImage] scale]);
	
	UIGraphicsBeginImageContextWithOptions(size, NO, scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextDrawTiledImage(context, CGRectMake(0.0f,
												0.0f,
												patternImageSize.width / scale,
												patternImageSize.height / scale),
							patternTileImageRef);
	
	UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	context = NULL;
	
	return renderedImage;
}

- (NSDictionary *)representativeDictionary
{
	NSMutableDictionary *dictionary = [[super representativeDictionary] mutableCopy];
	
	[dictionary setObject:_patternImageHash forKey:kPatternImageHashKey];
	
	return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
