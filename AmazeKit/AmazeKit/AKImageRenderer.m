//
//  AKImageRenderer.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/11/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageRenderer.h"

#import "NSString+AKCryptography.h"

#import "AKFileManager.h"
#import "AKImageEffect.h"


static NSString * const kImageEffectsKey = @"imageEffects";


@interface AKImageRenderer()

- (BOOL)renderedImageExistsForSize:(CGSize)size
						   options:(NSDictionary *)options;

- (UIImage *)previouslyRenderedImageForSize:(CGSize)size
									options:(NSDictionary *)options;

- (void)saveImage:(UIImage *)image
		  options:(NSDictionary *)options;

@end


@implementation AKImageRenderer

@synthesize imageEffects = _imageEffects;

- (UIImage *)imageWithSize:(CGSize)size
				   options:(NSDictionary *)options
{
	__block UIImage *image = [self previouslyRenderedImageForSize:size options:options];
	
	if (image == nil) {
		// TODO: Determine starting background color, source image, etc.
		UIGraphicsBeginImageContextWithOptions(size, YES, 0.0f);
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
		
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

- (BOOL)renderedImageExistsForSize:(CGSize)size
						   options:(NSDictionary *)options
{
	return [[AKFileManager defaultManager] cachedImageExistsForHash:[self representativeHash]
															 atSize:size];
}

- (UIImage *)previouslyRenderedImageForSize:(CGSize)size
									options:(NSDictionary *)options
{
	// TODO: options
	return [[AKFileManager defaultManager] cachedImageForHash:[self representativeHash]
													   atSize:size];
}

- (void)saveImage:(UIImage *)image
		  options:(NSDictionary *)options
{
	// TODO: options
	[[AKFileManager defaultManager] cacheImage:image forHash:[self representativeHash]];
}

@end
