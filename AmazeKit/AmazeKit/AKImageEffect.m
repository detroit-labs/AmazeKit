//
//  AKImageEffect.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/11/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageEffect.h"

#import "NSString+AKCryptography.h"


static NSString * const kClassKey = @"class";
static NSString * const kAlphaKey = @"alpha";
static NSString * const kBlendModeKey = @"blendMode";

@implementation AKImageEffect

@synthesize alpha = _alpha;
@synthesize blendMode = _blendMode;

+ (BOOL)canCacheIndividually
{
	return YES;
}

- (id)init
{
	self = [super init];
	
	if (self) {
		_alpha = 1.0f;
		_blendMode = kCGBlendModeNormal;
	}
	
	return self;
}

- (void)applyAppearanceProperties
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetAlpha(context, [self alpha]);
	CGContextSetBlendMode(context, [self blendMode]);
	
	// TODO: Add more appearance properties.
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	// The default operation is a no-op.
	return sourceImage;
}

- (NSDictionary *)representativeDictionary
{
	NSDictionary *dictionary = nil;
	
	dictionary = @{
	kClassKey : NSStringFromClass([self class]),
	kAlphaKey : @([self alpha]),
	kBlendModeKey : @((int)[self blendMode])
	};
	
	return dictionary;
}

- (NSString *)representativeHash
{
	NSString *hash = nil;
	
	NSDictionary *representativeDictionary = [self representativeDictionary];
	
	if (representativeDictionary != nil) {
		NSData *jsonRepresentation = [NSJSONSerialization dataWithJSONObject:representativeDictionary
																	 options:0
																	   error:NULL];
		
		if (jsonRepresentation != nil) {
			NSString *jsonString = [[NSString alloc] initWithData:jsonRepresentation
														 encoding:NSUTF8StringEncoding];
			
			hash = [jsonString AK_sha1Hash];
		}
	}
	
	return hash;
}

+ (id)effectWithRepresentativeDictionary:(NSDictionary *)representativeDictionary
{
	Class class = NSClassFromString([representativeDictionary objectForKey:kClassKey]);
	
	AKImageEffect *effect;
	
	if (class != Nil) {
		effect = (AKImageEffect *)[[class alloc] initWithRepresentativeDictionary:representativeDictionary];
	}
	
	return effect;
}

- (id)initWithRepresentativeDictionary:(NSDictionary *)representativeDictionary
{
	self = [super init];
	
	if (self) {
		[self setAlpha:[[representativeDictionary objectForKey:kAlphaKey] floatValue]];
		[self setBlendMode:[[representativeDictionary objectForKey:kBlendModeKey] intValue]];
	}
	
	return self;
}

@end
