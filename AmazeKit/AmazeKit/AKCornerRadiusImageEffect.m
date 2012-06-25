//
//  AKCornerRadiusImageEffect.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKCornerRadiusImageEffect.h"


@implementation AKCornerRadiusImageEffect

@synthesize cornerRadii = _cornerRadii;

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	CGFloat width = [sourceImage size].width * [sourceImage scale];
	CGFloat height = [sourceImage size].height * [sourceImage scale];
	
	// Create the mask image.
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	
	CGContextRef context = CGBitmapContextCreate(NULL,
												 width,
												 height,
												 8,
												 8 * width,
												 colorSpace,
												 kCGImageAlphaNone);
		
    CGContextBeginPath(context);
    CGContextSetGrayFillColor(context, 1.0, 0.0);
    CGContextAddRect(context, CGRectMake(0.0f, 0.0f, width, height));
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
	
    CGContextSetGrayFillColor(context, 1.0, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, height / 2.0f);
    CGContextAddArcToPoint(context, 0.0f, 0.0f, width / 2.0f, 0.0f, [self cornerRadii].bottomLeft * [sourceImage scale]);
    CGContextAddArcToPoint(context, width, 0.0f, width, height / 2.0f, [self cornerRadii].bottomRight * [sourceImage scale]);
    CGContextAddArcToPoint(context, width, height, width / 2.0f, height, [self cornerRadii].topRight * [sourceImage scale]);
    CGContextAddArcToPoint(context, 0.0f, height, 0.0f, height / 2.0f, [self cornerRadii].topLeft * [sourceImage scale]);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
	
	CGImageRef mask = CGBitmapContextCreateImage(context);
	
	CGColorSpaceRelease(colorSpace);
	CGContextRelease(context);
	context = NULL;
	
	// Render the noise layer on top of the source image.
	UIGraphicsBeginImageContextWithOptions([sourceImage size], NO, 0.0f);
	context = UIGraphicsGetCurrentContext();
	
	CGContextScaleCTM(context, 1.0f, -1.0f);
	CGContextTranslateCTM(context, 0.0f, -[sourceImage size].height);
	
	CGImageRef maskedOriginalImage = CGImageCreateWithMask([sourceImage CGImage], mask);
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, [sourceImage size].width, [sourceImage size].height), maskedOriginalImage);
	
	UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	context = NULL;
	
	CGImageRelease(mask);
	CGImageRelease(maskedOriginalImage);
	
	return renderedImage;
}

@end
