//
//  UIImage+AKMasking.m
//  AmazeKit
//
//  Created by Jeff Kelley on 8/29/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "UIImage+AKMasking.h"


@implementation UIImage (AKMasking)


// Credit: http://stackoverflow.com/questions/8126276/how-to-convert-uiimage-cgimagerefs-alpha-channel-to-mask
- (UIImage *)AK_reverseMaskImage
{
#define ROUND_UP(N, S) ((((N) + (S) - 1) / (S)) * (S))
	
	// Original RGBA image
	CGImageRef originalMaskImage = [self CGImage];
	float width = CGImageGetWidth(originalMaskImage);
	float height = CGImageGetHeight(originalMaskImage);
	
	// Make a bitmap context that's only 1 alpha channel
	// WARNING: the bytes per row probably needs to be a multiple of 4
	int strideLength = ROUND_UP(width * 1, 4);
	unsigned char * alphaData = calloc(strideLength * height, sizeof(unsigned char *));
	CGContextRef alphaOnlyContext = CGBitmapContextCreate(alphaData,
														  width,
														  height,
														  8,
														  strideLength,
														  NULL,
														  kCGImageAlphaOnly);
	
	// Draw the RGBA image into the alpha-only context.
	CGContextDrawImage(alphaOnlyContext, CGRectMake(0, 0, width, height), originalMaskImage);
	
	CGImageRef alphaMaskImage = CGBitmapContextCreateImage(alphaOnlyContext);
	CGContextRelease(alphaOnlyContext);
	free(alphaData);
	
	// Make a mask
	CGImageRef finalMaskImage = CGImageMaskCreate(CGImageGetWidth(alphaMaskImage),
												  CGImageGetHeight(alphaMaskImage),
												  CGImageGetBitsPerComponent(alphaMaskImage),
												  CGImageGetBitsPerPixel(alphaMaskImage),
												  CGImageGetBytesPerRow(alphaMaskImage),
												  CGImageGetDataProvider(alphaMaskImage), NULL, false);
	CGImageRelease(alphaMaskImage);
	
	UIImage *reverseMask = [[UIImage alloc] initWithCGImage:finalMaskImage
													  scale:[self scale]
												orientation:[self imageOrientation]];
	
	CGImageRelease(finalMaskImage);
	
	return reverseMask;
}

@end
