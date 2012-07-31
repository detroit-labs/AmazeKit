//
//  AKGradientImageEffect.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKGradientImageEffect.h"

#import "UIColor+AKColorStrings.h"


static NSString * const kColorsKey = @"colors";
static NSString * const kDirectionKey = @"direction";
static NSString * const kLocationsKey = @"locations";


@implementation AKGradientImageEffect

@synthesize colors = _colors;
@synthesize direction = _direction;
@synthesize locations = _locations;

- (id)init
{
	self = [super init];
	
	if (self) {
		_direction = AKGradientDirectionVertical;
	}
	
	return self;
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	// Create the gradient layer.
	UIGraphicsBeginImageContextWithOptions([sourceImage size], NO, 0.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat width = [sourceImage size].width;
	CGFloat height = [sourceImage size].height;
	
	// Decode the Objective-C objects to their CoreFoundation counterparts.
	__block NSArray *colors = @[];
	
	[[self colors] enumerateObjectsWithOptions:0
									usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
										UIColor *color = (UIColor *)obj;
										
										if ([color isKindOfClass:[UIColor class]]) {
											CGColorRef colorRef = [color CGColor];
											
											colors = [colors arrayByAddingObject:(__bridge id)colorRef];
										}
									}];
	
	CGFloat *locations = NULL;
	
	if ([self locations] != nil) {
		locations = malloc([[self locations] count] * sizeof(CGFloat));
		
		for (NSUInteger i = 0; i < [[self locations] count]; i++) {
			locations[i] = [[[self locations] objectAtIndex:i] floatValue];
		}
	}
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
														(__bridge CFArrayRef)colors,
														(const CGFloat *)locations);
	
	CGPoint startPoint = CGPointZero;
	CGPoint endPoint = CGPointZero;
	
	if ([self direction] == AKGradientDirectionVertical) {
		startPoint = CGPointMake(width / 2.0f, 0.0f);
		endPoint   = CGPointMake(width / 2.0f, height);
	}
	else if ([self direction] == AKGradientDirectionHorizontal) {
		startPoint = CGPointMake(0.0f, height / 2.0f);
		endPoint   = CGPointMake(width, height / 2.0f);
	}
	
	CGContextDrawLinearGradient(context,
								gradient,
								startPoint,
								endPoint,
								0);
	
	UIImage *layerImage = UIGraphicsGetImageFromCurrentImageContext();
	
	CGColorSpaceRelease(colorSpace);
	CGGradientRelease(gradient);

	if (locations != NULL) {
		free(locations);
	}

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
	
	NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:[[self colors] count]];
	
	for (UIColor *color in [self colors]) {
		[colors addObject:[color AK_hexString]];
	}
	
	[dictionary setObject:colors forKey:kColorsKey];	
	[dictionary setObject:@((int)[self direction]) forKey:kDirectionKey];
	
	if ([self locations] != nil) {
		[dictionary setObject:[self locations] forKey:kLocationsKey];
	}
	
	return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (id)initWithRepresentativeDictionary:(NSDictionary *)representativeDictionary
{
	self = [super initWithRepresentativeDictionary:representativeDictionary];
	
	if (self) {
		NSArray *colors = [representativeDictionary objectForKey:kColorsKey];
		NSMutableArray *parsedColors = [[NSMutableArray alloc] initWithCapacity:[colors count]];
		
		for (NSString *hexString in colors) {
			[parsedColors addObject:[UIColor AK_colorWithHexString:hexString]];
		}
		
		[self setColors:[NSArray arrayWithArray:parsedColors]];
		[self setDirection:[[representativeDictionary objectForKey:kDirectionKey] intValue]];
		[self setLocations:[representativeDictionary objectForKey:kLocationsKey]];
	}
	
	return self;
}

@end
