//
//  AKInnerShadowImageEffect.m
//  AmazeKit
//
//  Created by Jeff Kelley on 8/29/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKInnerShadowImageEffect.h"

#import "UIColor+AKColorStrings.h"
#import "UIImage+AKMasking.h"


// Defaults
static const CGFloat kDefaultRadius = 10.0f;

// Archiving Keys
static NSString * const kColorKey = @"color";
static NSString * const kRadiusKey = @"radius";
static NSString * const kOffsetKey = @"offset";


@implementation AKInnerShadowImageEffect

@synthesize color = _color;
@synthesize radius = _radius;
@synthesize offset = _offset;

#pragma mark - Object Lifecycle

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
{
	self = [super initWithAlpha:alpha blendMode:blendMode];
	
	if (self) {
		_color = [UIColor blackColor];
		_radius = kDefaultRadius;
		_offset = CGSizeZero;
	}
	
	return self;
}

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			  color:(UIColor *)color
			 radius:(CGFloat)radius
			 offset:(CGSize)offset
{
	self = [super initWithAlpha:alpha blendMode:blendMode];
	
	if (self) {
		_color = color;
		_radius = radius;
		_offset = offset;
	}
	
	return self;
}

#pragma mark - Image Effect Lifecycle

+ (BOOL)canRenderIndividually
{
	return NO;
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	UIImage *reverseMask = [sourceImage AK_reverseMaskImage];
	
	CGSize originalImageSize = [sourceImage size];
	CGFloat originalImageWidth = originalImageSize.width;
	CGFloat originalImageHeight = originalImageSize.height;
	CGFloat radius = [self radius];
	CGFloat frameWidth = originalImageWidth + (2.0f * radius);
	CGFloat frameHeight = originalImageHeight + (2.0f * radius);
	
	// Context 1: Draw the outline of the view to use it to cast a shadow
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(frameWidth,
													  frameHeight),
										   NO,
										   [sourceImage scale]);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect bounds = CGContextGetClipBoundingBox(context);
	
	CGContextSetFillColorWithColor(context, [[self color] CGColor]);
	
	CGContextTranslateCTM(context, 0.0f, frameHeight);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	
	// Color in the top, left, right, and bottom.
	CGContextFillRect(context, CGRectMake(0.0f, 0.0f, frameWidth, radius));
	CGContextFillRect(context, CGRectMake(0.0f, 0.0f, radius, frameHeight));
	CGContextFillRect(context, CGRectMake(originalImageWidth + radius, 0.0f, radius, frameHeight));
	CGContextFillRect(context, CGRectMake(0.0f, originalImageHeight + radius, frameWidth, radius));
	
	CGContextClipToMask(context,
						CGRectMake(radius,
								   radius,
								   originalImageWidth,
								   originalImageHeight),
						[reverseMask CGImage]);
	
	CGContextFillRect(context, bounds);
	
	UIImage *shadowCastingImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	// Context 2: Draw the original image, then the outer border with a shadow, all maksed to the
	//            original image
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(frameWidth,
													  frameHeight),
										   NO,
										   [sourceImage scale]);
	
	context = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(context, 0.0f, frameHeight);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	
	CGRect originalImageRect = CGRectMake(radius,
										  radius,
										  originalImageWidth,
										  originalImageHeight);
	
	CGContextClipToMask(context, originalImageRect, [sourceImage CGImage]);
	
	CGContextDrawImage(context, originalImageRect, [sourceImage CGImage]);
	
	CGContextSetShadowWithColor(context, [self offset], radius, [[self color] CGColor]);
	
	CGContextSetAlpha(context, [self alpha]);
	CGContextSetBlendMode(context, [self blendMode]);
	
	CGContextDrawImage(context,
					   CGRectMake(0.0f, 0.0f, frameWidth, frameHeight),
					   [shadowCastingImage CGImage]);
	
	UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	// Context 3: Draw the image with shadow in a smaller context to return an image with the same
	//            size as our original.
	UIGraphicsBeginImageContextWithOptions(originalImageSize, NO, [sourceImage scale]);
	
	context = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(context, 0.0f, originalImageHeight);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	
	CGContextClipToMask(context, CGContextGetClipBoundingBox(context), [sourceImage CGImage]);
	
	CGContextDrawImage(context, CGRectMake(-radius,
										   -radius,
										   frameWidth,
										   frameHeight),
					   [maskedImage CGImage]);
	
	UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return finalImage;
}

- (NSDictionary *)representativeDictionary
{
	NSMutableDictionary *dictionary = [[super representativeDictionary] mutableCopy];
	
	[dictionary setObject:[[self color] AK_hexString] forKey:kColorKey];
	[dictionary setObject:@([self radius]) forKey:kRadiusKey];
	[dictionary setObject:NSStringFromCGSize([self offset]) forKey:kOffsetKey];
	
	return [NSDictionary dictionaryWithDictionary:dictionary];
}

#pragma mark -

@end
