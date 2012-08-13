//
//  AKMaskImageEffect.m
//  AmazeKit
//
//  Created by Jeff Kelley on 8/6/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKMaskImageEffect.h"

#import "UIImage+AKCryptography.h"


// Constants
NSString * const kMaskImageHashKey = @"maskImageHash";


@implementation AKMaskImageEffect {
	NSString	*_maskImageHash;
}

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
	
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskImage),
										CGImageGetHeight(maskImage),
										CGImageGetBitsPerComponent(maskImage),
										CGImageGetBitsPerPixel(maskImage),
										CGImageGetBytesPerRow(maskImage),
										CGImageGetDataProvider(maskImage),
										NULL,
										YES);
	
	CGImageRef maskedOriginalImage = CGImageCreateWithMask([sourceImage CGImage], mask);
	
	UIImage *renderedImage = [[UIImage alloc] initWithCGImage:maskedOriginalImage
														scale:[sourceImage scale]
												  orientation:[sourceImage imageOrientation]];
	CGImageRelease(maskedOriginalImage);
	CGImageRelease(mask);
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
