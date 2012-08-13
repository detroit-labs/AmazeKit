//
//  AKColorImageEffect.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKColorImageEffect.h"

#import "UIColor+AKColorStrings.h"


static NSString * const kColorKey = @"color";


@implementation AKColorImageEffect

@synthesize color = _color;

+ (BOOL)canRenderIndividually
{
	// A color effect *could* render individually, but rendering the color should be more efficient
	// than loading and rendering an image of the color. Also, it’ll cut down on files cached on the
	// device if colors change.
	return NO;
}

- (id)init
{
	self = [super init];
	
	if (self) {
		_color = [UIColor blackColor];
	}
	
	return self;
}

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
{
	self = [super initWithAlpha:alpha blendMode:blendMode];
	
	if (self) {
		_color = [UIColor blackColor];
	}
	
	return self;
}

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			  color:(UIColor *)color
{
	self = [self initWithAlpha:alpha blendMode:blendMode];
	
	if (self) {
		_color = color;
	}
	
	return self;
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	CGSize size = [sourceImage size];
	CGFloat scale = [sourceImage scale];
	CGImageRef sourceCGImage = [sourceImage CGImage];
	size_t width = CGImageGetWidth(sourceCGImage);
	size_t height = CGImageGetHeight(sourceCGImage);
	
	UIGraphicsBeginImageContextWithOptions(size, NO, scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(context, 0.0f, height);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), sourceCGImage);
	
	[self applyAppearanceProperties];
	
	CGContextSetFillColorWithColor(context, [[self color] CGColor]);
	CGContextFillRect(context, CGRectMake(0.0f, 0.0f, width, height));

	UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	context = NULL;
	
	return renderedImage;
}

- (NSDictionary *)representativeDictionary
{
	NSMutableDictionary *dictionary = [[super representativeDictionary] mutableCopy];
	
	[dictionary setObject:[[self color] AK_hexString] forKey:kColorKey];
	
	return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (id)initWithRepresentativeDictionary:(NSDictionary *)representativeDictionary
{
	self = [super initWithRepresentativeDictionary:representativeDictionary];
	
	if (self) {
		_color = [UIColor AK_colorWithHexString:[representativeDictionary objectForKey:kColorKey]];
	}
	
	return self;
}

@end
