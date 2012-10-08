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

// Notifications
NSString * const AKImageRendererEffectDidChangeNotification = @"AKImageRendererEffectDidChange";

// Constants
static NSString * const kImageEffectsKey = @"imageEffects";
static NSString * const kRepresentativeDictionaryOptionsKey = @"options";


@interface AKImageRenderer() {
	NSMutableDictionary	*_renderedImages;
}

- (BOOL)renderedImageExistsForSize:(CGSize)size
						 withScale:(CGFloat)scale
						   options:(NSDictionary *)options;

- (UIImage *)previouslyRenderedImageForSize:(CGSize)size
								  withScale:(CGFloat)scale
									options:(NSDictionary *)options;

- (void)saveImage:(UIImage *)image
		  options:(NSDictionary *)options;

- (void)registerImageEffectObservers;
- (void)unregisterImageEffectObservers;

@end


@implementation AKImageRenderer

@synthesize imageEffects = _imageEffects;

#pragma mark - Object Lifecycle

- (void)dealloc
{
	[self unregisterImageEffectObservers];
}

#pragma mark - Image Renderer Lifecycle

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
		
		[self saveImage:image
				options:options];
	}
	
	// Save the image options.
	if (_renderedImages == nil) {
		_renderedImages = [[NSMutableDictionary alloc] init];
	}
	
	@synchronized(_renderedImages) {
		NSSet *savedImages = [_renderedImages objectForKey:NSStringFromCGSize(size)];
		if (savedImages == nil) {
			savedImages = [NSSet set];
		}
		
		savedImages = [savedImages setByAddingObject:(options == nil ? [NSNull null] : options)];
		
		[_renderedImages setObject:savedImages forKey:NSStringFromCGSize(size)];
	}
	
	return image;
}

- (void)registerImageEffectObservers
{
	[[self imageEffects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([obj isKindOfClass:[AKImageEffect class]] &&
			[[(AKImageEffect *)obj class] isImmutable] == NO) {
			[obj addObserver:self
				  forKeyPath:AKImageEffectDirtyKeyPath
					 options:NSKeyValueObservingOptionNew
					 context:NULL];
		}
	}];
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

- (NSDictionary *)renderedImages
{
	return [NSDictionary dictionaryWithDictionary:_renderedImages];
}

- (UIImage *)previouslyRenderedImageForSize:(CGSize)size
								  withScale:(CGFloat)scale
									options:(NSDictionary *)options
{
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

- (void)setImageEffects:(NSArray *)imageEffects
{
	[self unregisterImageEffectObservers];
	
	_imageEffects = imageEffects;
	
	[self registerImageEffectObservers];
}

- (void)unregisterImageEffectObservers
{
	[[self imageEffects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([obj isKindOfClass:[AKImageEffect class]] &&
			[[(AKImageEffect *)obj class] isImmutable] == NO) {
			[obj removeObserver:self
					 forKeyPath:AKImageEffectDirtyKeyPath];
		}
	}];
}

#pragma mark - Key-Value Observation

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	if ([object isKindOfClass:[AKImageEffect class]]) {
		if ([[self imageEffects] containsObject:object]) {
			if ([keyPath isEqualToString:AKImageEffectDirtyKeyPath]) {
				[[NSNotificationCenter defaultCenter] postNotificationName:AKImageRendererEffectDidChangeNotification
																	object:self];
			}
		}
	}
}

#pragma mark -

@end
