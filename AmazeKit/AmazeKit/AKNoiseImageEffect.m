//
//  AKNoiseImageEffect.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/11/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKNoiseImageEffect.h"

#import "UIImage+AKPixelData.h"


@implementation AKNoiseImageEffect

@synthesize noiseType = _noiseType;

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
		  noiseType:(AKNoiseType)noiseType
{
	self = [self initWithAlpha:alpha blendMode:blendMode];
	
	if (self) {
		_noiseType = noiseType;
	}
	
	return self;
}

- (UIImage *)renderedImageForSize:(CGSize)size
						  atScale:(CGFloat)scale
{
	NSUInteger width = size.width * scale;
	NSUInteger height = size.height * scale;
	
	CGColorSpaceRef noiseColorSpace = CGColorSpaceCreateDeviceRGB();
	size_t numberOfComponents = 3;
	
	int bitsPerComponent = 8;
	int bytesPerPixel = ((numberOfComponents + 1) * bitsPerComponent) / 8;
	int bytesPerRow = bytesPerPixel * width;
	
	// Create the data buffer for the image.
	uint8_t *imageData = calloc(width * height, bytesPerPixel);
	
	for (NSUInteger x = 0; x < width; x++) {
		for (NSUInteger y = 0; y < height; y++) {
			int offset = (bytesPerRow * y) + (bytesPerPixel * x);
			
			if ([self noiseType] == AKNoiseTypeBlackAndWhite) {
				uint8_t white = arc4random_uniform(UINT8_MAX);
				uint8_t alpha = arc4random_uniform(UINT8_MAX);
				
				imageData[offset]     = (white * alpha) / UINT8_MAX;
				imageData[offset + 1] = (white * alpha) / UINT8_MAX;
				imageData[offset + 2] = (white * alpha) / UINT8_MAX;
				imageData[offset + 3] = alpha;
			}
			else if ([self noiseType] == AKNoiseTypeColor) {
				uint8_t red   = arc4random_uniform(UINT8_MAX);
				uint8_t green = arc4random_uniform(UINT8_MAX);
				uint8_t blue  = arc4random_uniform(UINT8_MAX);
				uint8_t alpha = arc4random_uniform(UINT8_MAX);
				
				imageData[offset]     = (red * alpha) / UINT8_MAX;
				imageData[offset + 1] = (blue * alpha) / UINT8_MAX;
				imageData[offset + 2] = (green * alpha) / UINT8_MAX;
				imageData[offset + 3] = alpha;
			}
		}
	}
	
	CGContextRef noiseContext = CGBitmapContextCreate((void *)imageData,
													  width,
													  height,
													  bitsPerComponent,
													  bytesPerRow,
													  noiseColorSpace,
													  kCGImageAlphaPremultipliedLast);
	
	CGImageRef renderedImageRef = CGBitmapContextCreateImage(noiseContext);
	
	UIImage *renderedImage = [[UIImage alloc] initWithCGImage:renderedImageRef
														scale:scale
												  orientation:UIImageOrientationUp];
	
	CGImageRelease(renderedImageRef);
	CGContextRelease(noiseContext);
	CGColorSpaceRelease(noiseColorSpace);
	free(imageData);

	return renderedImage;
}

@end
