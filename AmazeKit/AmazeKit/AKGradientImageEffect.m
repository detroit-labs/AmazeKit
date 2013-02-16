//
//  AKGradientImageEffect.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2013 Detroit Labs. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			 colors:(NSArray *)colors
		  direction:(AKGradientDirection)direction
		  locations:(NSArray *)locations
{
	self = [self initWithAlpha:alpha blendMode:blendMode];
	
	if (self) {
		_colors = [colors copy];
		_direction = direction;
		_locations = [locations copy];
	}
	
	return self;
}

- (UIImage *)renderedImageForSize:(CGSize)size
						  atScale:(CGFloat)scale
{
	// Create the gradient layer.
	UIGraphicsBeginImageContextWithOptions(size, NO, scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat width = size.width;
	CGFloat height = size.height;
	
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
	
	UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
	if (locations != NULL) {
		free(locations);
	}
		
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
		
		_colors = [NSArray arrayWithArray:parsedColors];
		_direction = [[representativeDictionary objectForKey:kDirectionKey] intValue];
		_locations = [representativeDictionary objectForKey:kLocationsKey];
	}
	
	return self;
}

@end
