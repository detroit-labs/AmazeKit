//
//  AKMaskImageEffect.m
//  AmazeKit
//
//  Created by Jeff Kelley on 8/6/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKMaskImageEffect.h"


@implementation AKMaskImageEffect

+ (BOOL)canCacheIndividually
{
	return NO;
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	// Render the noise layer on top of the source image.
	UIGraphicsBeginImageContextWithOptions([sourceImage size], NO, 0.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextScaleCTM(context, 1.0f, -1.0f);
	CGContextTranslateCTM(context, 0.0f, -[sourceImage size].height);
	
	CGImageRef maskImageRef = [[self maskImage] CGImage];
	
	CGImageRef maskedOriginalImage = CGImageCreateWithMask([sourceImage CGImage], maskImageRef);
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, [sourceImage size].width, [sourceImage size].height), maskedOriginalImage);
	
	UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	context = NULL;
	
	return renderedImage;
}

@end
