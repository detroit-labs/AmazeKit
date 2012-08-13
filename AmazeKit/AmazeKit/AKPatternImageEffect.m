//
//  AKPatternImageEffect.m
//  AmazeKit
//
//  Created by Jeff Kelley on 7/26/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKPatternImageEffect.h"

#import "AKDrawingUtilities.h"


@implementation AKPatternImageEffect

@synthesize patternImage = _patternImage;

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
	   patternImage:(UIImage *)patternImage
{
	self = [self initWithAlpha:alpha blendMode:blendMode];
	
	if (self) {
		_patternImage = patternImage;
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

@end
