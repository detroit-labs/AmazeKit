//
//  AKPatternImageEffect.m
//  AmazeKit
//
//  Created by Jeff Kelley on 7/26/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKPatternImageEffect.h"


@implementation AKPatternImageEffect

@synthesize patternImage = _patternImage;

+ (BOOL)canCacheIndividually
{
	// The caching implementation of the pattern caches the tile.
	return NO;
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	// Create the noise layer.
	NSUInteger width = [sourceImage size].width * [sourceImage scale];
	NSUInteger height = [sourceImage size].height * [sourceImage scale];
	
	CGImageRef patternTileImageRef = [[self patternImage] CGImage];
	
	// Render the pattern tile on top of the source image.
	UIGraphicsBeginImageContextWithOptions([sourceImage size], NO, 0.0f);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), [sourceImage CGImage]);
	
	[self applyAppearanceProperties];
	
	CGContextDrawTiledImage(context, CGRectMake(0.0f,
												0.0f,
												[[self patternImage] size].width * [[self patternImage] scale],
												[[self patternImage] size].height * [[self patternImage] scale]),
							patternTileImageRef);
	
	UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	context = NULL;
	
	return renderedImage;
}

@end
