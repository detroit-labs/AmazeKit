//
//  AKImageRenderer.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/11/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageRenderer.h"

#import "AKImageEffect.h"


@interface AKImageRenderer()

- (BOOL)renderedImageExistsForSize:(CGSize)size
						   options:(NSDictionary *)options;

- (UIImage *)previouslyRenderedImageForSize:(CGSize)size
									options:(NSDictionary *)options;

- (void)saveImage:(UIImage *)image
		  forSize:(CGSize)size
		  options:(NSDictionary *)options;

@end


@implementation AKImageRenderer

@synthesize imageEffects = _imageEffects;

- (UIImage *)imageWithSize:(CGSize)size
				   options:(NSDictionary *)options
{
	// TODO: Determine starting background color, source image, etc.
	UIGraphicsBeginImageContextWithOptions(size, YES, 0.0f);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
	
	CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
	
	__block UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
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
				forSize:size
				options:options];
	});
	
	return image;
}

- (BOOL)renderedImageExistsForSize:(CGSize)size
						   options:(NSDictionary *)options
{
	// TODO: Implement image caching.
	return NO;
}

- (UIImage *)previouslyRenderedImageForSize:(CGSize)size
									options:(NSDictionary *)options
{
	// TODO: Implement image caching.
	return nil;
}

- (void)saveImage:(UIImage *)image
		  forSize:(CGSize)size
		  options:(NSDictionary *)options
{
	// TODO: Implement image caching.
}

@end
