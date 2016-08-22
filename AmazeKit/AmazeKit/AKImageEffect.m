//
//  AKImageEffect.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/11/12.
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


#import "AKImageEffect.h"

#import "NSString+AZKCryptography.h"

#import "AKDrawingUtilities.h"
#import "AKFileManager.h"


// KVO Constants
NSString * const AKImageEffectDirtyKeyPath = @"dirty";


// Representation Constants
static NSString * const kClassKey = @"class";
static NSString * const kAlphaKey = @"alpha";
static NSString * const kBlendModeKey = @"blendMode";

@implementation AKImageEffect {
	NSString	*_cachedHash;
	NSLock  	*_renderLock;
}

@synthesize alpha = _alpha;
@synthesize blendMode = _blendMode;
@synthesize dirty = _dirty;

#pragma mark - Image Caching

+ (BOOL)canRenderIndividually
{
	return YES;
}

- (void)cacheRenderedImage:(UIImage *)image
{
	[[AKFileManager defaultManager] cacheImage:image
									   forHash:[self representativeHash]];
}

- (UIImage *)previouslyRenderedImageForSize:(CGSize)size
									atScale:(CGFloat)scale
{
	return [[AKFileManager defaultManager] cachedImageForHash:[self representativeHash]
													   atSize:size
													withScale:scale];
}

#pragma mark -

+ (BOOL)isImmutable
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

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
{
	self = [super init];
	
	if (self) {
		_alpha = alpha;
		_blendMode = blendMode;
	}
	
	return self;
}

- (BOOL)isEqual:(id)object
{
	BOOL isEqual = NO;
	
	AKImageEffect *other = (AKImageEffect *)object;
	
	if ([other isKindOfClass:[self class]]) {
		if (fabs([other alpha] - [self alpha]) < FLT_EPSILON &&
			[other blendMode] == [self blendMode]) {
			isEqual = YES;
		}
	}
	
	return isEqual;
}

- (void)applyAppearanceProperties
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetAlpha(context, [self alpha]);
	CGContextSetBlendMode(context, [self blendMode]);
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	CGSize size = [sourceImage size];
	CGFloat scale = [sourceImage scale];
	
	UIImage *finalImage = sourceImage;
	UIImage *renderedImage = nil;
	
	if ([[self class] canRenderIndividually] == YES) {
		renderedImage = [self previouslyRenderedImageForSize:size
													 atScale:scale];
	}
	
	if (renderedImage == nil && [[self class] canRenderIndividually]) {
		renderedImage = [self renderedImageForSize:size
										   atScale:scale];
		
		[self cacheRenderedImage:renderedImage];
	}
	
	if (renderedImage != nil) {
		UIGraphicsBeginImageContextWithOptions(size, NO, scale);
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGRect imageRect = CGContextGetClipBoundingBox(context);
		[sourceImage drawInRect:imageRect];

		[renderedImage drawInRect:imageRect
						blendMode:[self blendMode]
							alpha:[self alpha]];
		
		finalImage = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();
		context = NULL;
	}
	
	return finalImage;
}

- (UIImage *)renderedImageForSize:(CGSize)size atScale:(CGFloat)scale
{
	// The default implementation is a no-op.
	return nil;
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
	
	if ([[self class] isImmutable] || [self isDirty] == NO) {
		hash = _cachedHash;
	}
	
	if (hash == nil) {
		NSDictionary *representativeDictionary = [self representativeDictionary];
		
		if (representativeDictionary != nil) {
			NSData *jsonRepresentation = [NSJSONSerialization dataWithJSONObject:representativeDictionary
																		 options:0
																		   error:NULL];
			
			if (jsonRepresentation != nil) {
				NSString *jsonString = [[NSString alloc] initWithData:jsonRepresentation
															 encoding:NSUTF8StringEncoding];
				
				hash = jsonString.azk_sha1Hash;
				_cachedHash = hash;
			}
		}
	}
	
	[self setDirty:NO];
	
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
	self = [self initWithAlpha:[[representativeDictionary objectForKey:kAlphaKey] floatValue]
					 blendMode:[[representativeDictionary objectForKey:kBlendModeKey] intValue]];
	
	return self;
}

- (void)obtainLock
{
	if (_renderLock == nil) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			_renderLock = [[NSLock alloc] init];
		});
	}
	
	[_renderLock lock];
}

- (void)releaseLock
{
	[_renderLock unlock];
}

@end
