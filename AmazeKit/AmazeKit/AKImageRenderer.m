//
//  AKImageRenderer.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/11/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageRenderer.h"

#import "NSString+AKCryptography.h"
#import "UIColor+AKColorStrings.h"

#import "AKFileManager.h"
#import "AKDrawingUtilities.h"
#import "AKImageEffect.h"


// Options Dictionary Keys
NSString * const AKImageRendererOptionKeyInitialBackgroundColor = @"AKImageRendererInitialBackgroundColor";

// Constants
static NSString * const kImageEffectsKey = @"imageEffects";
static NSString * const kRepresentativeDictionaryOptionsKey = @"options";


@interface AKImageRenderer()

- (BOOL)renderedImageExistsForSize:(CGSize)size
						 withScale:(CGFloat)scale
						   options:(NSDictionary *)options;

- (UIImage *)previouslyRenderedImageForSize:(CGSize)size
								  withScale:(CGFloat)scale
									options:(NSDictionary *)options;

- (void)saveImage:(UIImage *)image
		  options:(NSDictionary *)options;

@end


@implementation AKImageRenderer

@synthesize imageEffects = _imageEffects;

- (id)initWithRepresentativeDictionary:(NSDictionary *)representativeDictionary
{
	self = [self init];
	
	if (self) {
		NSArray *imageEffects = [representativeDictionary objectForKey:kImageEffectsKey];
		
		if (imageEffects != nil) {
			_imageEffects = [[NSArray alloc] init];
			
			NSUInteger count = [imageEffects count];
			
			for (NSUInteger i = 0; i < count; i++) {
				AKImageEffect *imageEffect = [[AKImageEffect alloc] initWithRepresentativeDictionary:[imageEffects objectAtIndex:i]];
				_imageEffects = [_imageEffects arrayByAddingObject:imageEffect];
			}
		}
	}
	
	return self;
}

- (UIImage *)imageWithSize:(CGSize)size
					 scale:(CGFloat)scale
				   options:(NSDictionary *)options
{
	__block UIImage *image = [self previouslyRenderedImageForSize:size
														withScale:scale
														  options:options];
	
	if (image == nil) {
		UIColor *startingBackgroundColor = [UIColor whiteColor];
		
		NSString *backgroundColorHex = [options objectForKey:AKImageRendererOptionKeyInitialBackgroundColor];
		if (backgroundColorHex != nil) {
			startingBackgroundColor = [UIColor AK_colorWithHexString:backgroundColorHex];
		}
		
		UIGraphicsBeginImageContextWithOptions(size, NO, scale);
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextSetFillColorWithColor(context, [startingBackgroundColor CGColor]);
		
		CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
		
		image = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();
		
		[[self imageEffects] enumerateObjectsWithOptions:0
											  usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
												  AKImageEffect *imageEffect = obj;
												  
												  if ([imageEffect isKindOfClass:[AKImageEffect class]]) {
													  image = [imageEffect renderedImageFromSourceImage:image];
												  }
											  }];
		
		// TODO: Create a framework-wide serial queue for I/O access
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0ul), ^{
			[self saveImage:image
					options:options];
		});
	}
	
	return image;
}

- (NSDictionary *)representativeDictionary
{
	NSMutableArray *representativeDictionaries = [[NSMutableArray alloc] initWithCapacity:[[self imageEffects] count]];
	
	for (AKImageEffect *imageEffect in [self imageEffects]) {
		[representativeDictionaries addObject:[imageEffect representativeDictionary]];
	}
	
	return @{ kImageEffectsKey : representativeDictionaries };
}

- (NSString *)representativeHash
{
	return [self representativeHashWithOptions:nil];
}

- (NSString *)representativeHashWithOptions:(NSDictionary *)options
{
	NSString *hash = nil;
	
	NSMutableDictionary *representativeDictionary = [[self representativeDictionary] mutableCopy];
	
	if (options != nil) {
		[representativeDictionary setObject:options
									 forKey:kRepresentativeDictionaryOptionsKey];
	}
	
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

- (BOOL)renderedImageExistsForSize:(CGSize)size
						 withScale:(CGFloat)scale
						   options:(NSDictionary *)options
{
	return [[AKFileManager defaultManager] cachedImageExistsForHash:[self representativeHashWithOptions:options]
															 atSize:size
														  withScale:scale];
}

- (UIImage *)previouslyRenderedImageForSize:(CGSize)size
								  withScale:(CGFloat)scale
									options:(NSDictionary *)options
{
	// TODO: options
	return [[AKFileManager defaultManager] cachedImageForHash:[self representativeHashWithOptions:options]
													   atSize:size
													withScale:scale];
}

- (void)saveImage:(UIImage *)image
		  options:(NSDictionary *)options
{
	[[AKFileManager defaultManager] cacheImage:image
									   forHash:[self representativeHashWithOptions:options]];
}

@end
