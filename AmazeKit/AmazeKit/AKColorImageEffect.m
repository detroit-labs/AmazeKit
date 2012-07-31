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

- (id)init
{
	self = [super init];
	
	if (self) {
		_color = [UIColor blackColor];
	}
	
	return self;
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	// Create the color layer.
	UIGraphicsBeginImageContextWithOptions([sourceImage size], NO, 0.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat width = [sourceImage size].width;
	CGFloat height = [sourceImage size].height;
	
	CGContextSetFillColorWithColor(context, [[self color] CGColor]);
	
	CGContextFillRect(context, CGRectMake(0.0f, 0.0f, width, height));
	
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
		[self setColor:[UIColor AK_colorWithHexString:[representativeDictionary objectForKey:kColorKey]]];
	}
	
	return self;
}

@end
