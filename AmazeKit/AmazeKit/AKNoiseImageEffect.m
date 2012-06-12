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

- (id)init
{
	self = [super init];
	
	if (self) {
		_noiseType = AKNoiseTypeBlackAndWhite;
	}
	
	return self;
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	// Create the noise layer.
	UIGraphicsBeginImageContextWithOptions([sourceImage size], NO, 0.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
		
	NSUInteger width = [sourceImage size].width;
	NSUInteger height = [sourceImage size].height;
	
	// TODO: Fix for Retina
	for (NSUInteger x = 0; x < width; x++) {
		for (NSUInteger y = 0; y < height; y++) {
			UIColor *color = [UIColor blackColor];
			
			if ([self noiseType] == AKNoiseTypeBlackAndWhite) {
				int32_t white = arc4random_uniform(255);
				int32_t alpha = arc4random_uniform(255);
				
				color = [UIColor colorWithWhite:(CGFloat)white / 255.0f
										  alpha:(CGFloat)alpha / 255.0f];
			}
			else if ([self noiseType] == AKNoiseTypeColor) {
				int32_t red   = arc4random_uniform(255);
				int32_t green = arc4random_uniform(255);
				int32_t blue  = arc4random_uniform(255);
				int32_t alpha = arc4random_uniform(255);
				
				color = [UIColor colorWithRed:(CGFloat)red / 255.0f
										green:(CGFloat)green / 255.0f
										 blue:(CGFloat)blue / 255.0f
										alpha:(CGFloat)alpha / 255.0f];
			}
			
			CGContextSetFillColorWithColor(context, [color CGColor]);
			CGContextFillRect(context, CGRectMake((CGFloat)x, (CGFloat)y, 1.0f, 1.0f));
		}
	}
	
	UIImage *layerImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	context = NULL;
	
	// Render the noise layer on top of the source image.
	UIGraphicsBeginImageContextWithOptions([sourceImage size], NO, 0.0f);
	context = UIGraphicsGetCurrentContext();
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), [sourceImage CGImage]);
	
	[self applyAppearanceProperties];
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), [layerImage CGImage]);
	
	UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	context = NULL;
	
	return renderedImage;
}

@end
