//
//  AZKFileManager.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/16/12.
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


#import "AZKFileManager.h"

#import <ImageIO/ImageIO.h>

#import "AZKDrawingUtilities.h"

// Constants
static const char *kImageType = "public.png";
static const char *kPNGSoftwareValue = "AmazeKit";

@interface AZKFileManager()

@property (nonatomic, readonly, nonnull) NSFileManager *fileManager;
@property (nonatomic, readonly, nonnull) NSOperationQueue *imageIOQueue;
@property (nonatomic, readonly, nonnull) NSCache *renderedImageCache;

- (nonnull NSString *)cacheKeyForHash:(nonnull NSString *)hash
                               atSize:(CGSize)size
                            withScale:(CGFloat)scale;

- (nonnull NSString *)dimensionsRepresentationWithSize:(CGSize)size
                                                 scale:(CGFloat)scale;

- (nonnull NSString *)pathForHash:(NSString *)hash
                           atSize:(CGSize)size
                        withScale:(CGFloat)scale;

@end

@implementation AZKFileManager

@synthesize fileManager = _fileManager;
@synthesize imageIOQueue = _imageIOQueue;
@synthesize renderedImageCache = _renderedImageCache;

#pragma mark - Object Lifecycle

+ (id)defaultManager
{
	static id sharedInstance = nil;
	
	if (sharedInstance == nil) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			sharedInstance = [[self alloc] init];
		});
	}
	
	return sharedInstance;
}

+ (NSString *)amazeKitCachePath
{
	static NSString *amazeKitCachePath = nil;
	
	if (amazeKitCachePath == nil) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			amazeKitCachePath = [self.amazeKitCacheURL path];
		});
	}
	
	return amazeKitCachePath;
}

+ (NSURL *)amazeKitCacheURL
{
	static NSURL *amazeKitCacheURL = nil;
	
	if (amazeKitCacheURL == nil) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			NSError *error = nil;
			NSURL *cachesURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
																	  inDomain:NSUserDomainMask
															 appropriateForURL:nil
																		create:YES
																		 error:&error];
			
			if (cachesURL != nil) {
				amazeKitCacheURL = [cachesURL URLByAppendingPathComponent:@"__AmazeKitCache__"
															  isDirectory:YES];
				
				BOOL isDirectory = NO;
				
				if ([[NSFileManager defaultManager] fileExistsAtPath:[amazeKitCacheURL absoluteString]
														 isDirectory:&isDirectory] == NO) {
					
					NSError *directoryCreationError = nil;
					BOOL success = [[NSFileManager defaultManager] createDirectoryAtURL:amazeKitCacheURL
															withIntermediateDirectories:YES
																			 attributes:nil
																				  error:&directoryCreationError];
					
					if (success == NO) {
						NSLog(@"Could not create directory at URL %@, error: %@", amazeKitCacheURL, directoryCreationError);
					}
				}
			}
			else {
				NSLog(@"Error finding caches URL: %@", error);
			}
		});
	}
	
	return amazeKitCacheURL;
}

#pragma mark -

- (BOOL)cachedImageExistsForHash:(NSString *)descriptionHash
						  atSize:(CGSize)size
					   withScale:(CGFloat)scale
{
	__block BOOL imageExists = NO;
	
	NSString *cacheKey = [self cacheKeyForHash:descriptionHash
										atSize:size
									 withScale:scale];
	
	imageExists = ([self.renderedImageCache objectForKey:cacheKey] != nil);
	
	if (imageExists == NO) {
		NSString *path = [self pathForHash:descriptionHash
									atSize:size
								 withScale:scale];
		
        NSBlockOperation *imageExistsOperation =
        [NSBlockOperation blockOperationWithBlock:^{
            imageExists = [self.fileManager fileExistsAtPath:path];
        }];
		
		[self.imageIOQueue addOperation:imageExistsOperation];
		[imageExistsOperation waitUntilFinished];
	}
	
	return imageExists;
}

- (UIImage *)cachedImageForHash:(NSString *)descriptionHash
						 atSize:(CGSize)size
					  withScale:(CGFloat)scale
{
    __block UIImage *cachedImage = nil;
	
	if ([self cachedImageExistsForHash:descriptionHash
								atSize:size
							 withScale:scale] == YES) {
		NSString *cacheKey = [self cacheKeyForHash:descriptionHash
											atSize:size
										 withScale:scale];
		
        cachedImage = [self.renderedImageCache objectForKey:cacheKey];
		
		if (cachedImage == nil) {
			NSBlockOperation *imageLoadOperation = [NSBlockOperation blockOperationWithBlock:^{
				NSString *path = [self pathForHash:descriptionHash
											atSize:size
										 withScale:scale];
				
				NSURL *url = [NSURL fileURLWithPath:path];
				
				CFStringRef       myKeys[2];
				CFTypeRef         myValues[2];
				
				myKeys[0] = kCGImageSourceShouldCache;
				myValues[0] = (CFTypeRef)kCFBooleanTrue;
				myKeys[1] = kCGImageSourceShouldAllowFloat;
				myValues[1] = (CFTypeRef)kCFBooleanTrue;
				
				CFDictionaryRef options = CFDictionaryCreate(kCFAllocatorDefault,
															 (const void **) myKeys,
															 (const void **) myValues,
															 2,
															 &kCFTypeDictionaryKeyCallBacks,
															 &kCFTypeDictionaryValueCallBacks);
				
				CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)url,
																		  options);
				CFRelease(options);
				
				if (imageSource != NULL) {
					// Create an image from the first item in the image source.
					CGImageRef baseImage = CGImageSourceCreateImageAtIndex(imageSource,
																		   0,
																		   NULL);
					
					if (baseImage != NULL) {
						cachedImage = [[UIImage alloc] initWithCGImage:baseImage
																 scale:scale
														   orientation:UIImageOrientationUp];
						
						CGImageRelease(baseImage);
					}
					
					CFRelease(imageSource);
				}
			}];
			
			[self.imageIOQueue addOperation:imageLoadOperation];
			[imageLoadOperation waitUntilFinished];
			
			if (cachedImage != nil) {
                [self.renderedImageCache setObject:cachedImage
                                            forKey:cacheKey];
			}
		}
	}
	
	return cachedImage;
}

- (void)cacheImage:(UIImage *)image forHash:(NSString *)descriptionHash
{
	CGSize imageSize = [image size];
	CGFloat imageScale = [image scale];
	
	NSString *path = [self pathForHash:descriptionHash
								atSize:imageSize
							 withScale:imageScale];
	
	NSURL *url = [NSURL fileURLWithPath:path];
	
	static CFStringRef type = NULL;
	
	if (type == NULL) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			type = CFStringCreateWithCString(kCFAllocatorDefault,
											 kImageType,
											 kCFStringEncodingASCII);
		});
	}
	
	static CFDictionaryRef imageOptions = NULL;
	
	if (imageOptions == NULL) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			CFStringRef values[1];
			CFStringRef keys[1];
			
			CFStringRef softwareValue = CFStringCreateWithCString(kCFAllocatorDefault,
																  kPNGSoftwareValue,
																  kCFStringEncodingASCII);
			
			keys[0] = kCGImagePropertyPNGSoftware;
			values[0] = softwareValue;
			
			imageOptions = CFDictionaryCreate(kCFAllocatorDefault,
											  (const void **)keys,
											  (const void **)values,
											  1,
											  &kCFTypeDictionaryKeyCallBacks,
											  &kCFTypeDictionaryValueCallBacks);

			CFRelease(softwareValue);
		});
	}
	
	NSBlockOperation *imageWritingOperation = [NSBlockOperation blockOperationWithBlock:^{
		CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)url,
																			type,
																			1,
																			NULL);
		
		CGImageDestinationAddImage(destination, image.CGImage, imageOptions);
	
		__block bool success = false;
	
		success = CGImageDestinationFinalize(destination);
		
		CFRelease(destination);
		
		if (success == false) {
			NSLog(@"Could not cache image with size %@ and scale %.0f to path: %@",
				  NSStringFromCGSize(imageSize),
				  imageScale,
				  path);
		}
	}];
	
	// We want writing operations to have a higher priority to minimize the chance that multiple
	// threads would try to render the same image.
	[imageWritingOperation setQueuePriority:NSOperationQueuePriorityHigh];
	
	[self.imageIOQueue addOperation:imageWritingOperation];
	
    [self.renderedImageCache setObject:image
                                forKey:[self cacheKeyForHash:descriptionHash
                                                      atSize:imageSize
                                                   withScale:imageScale]];
}

- (NSString *)cacheKeyForHash:(NSString *)hash
					   atSize:(CGSize)size
					withScale:(CGFloat)scale
{
	return [NSString stringWithFormat:@"%@%@", hash, [self dimensionsRepresentationWithSize:size scale:scale]];
}

- (NSString *)dimensionsRepresentationWithSize:(CGSize)size scale:(CGFloat)scale
{
    NSString *dimensionsRepresentation = [NSString stringWithFormat:@"{%dx%dx%d}",
										  (int)size.width,
										  (int)size.height,
										  (int)scale];
    return dimensionsRepresentation;
}

- (NSFileManager *)fileManager
{
	if (_fileManager == nil) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			_fileManager = [[NSFileManager alloc] init];
		});
	}
	
	return _fileManager;
}

- (NSOperationQueue *)imageIOQueue
{
	if (_imageIOQueue == nil) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			_imageIOQueue = [[NSOperationQueue alloc] init];
			[_imageIOQueue setName:@"AmazeKit Image I/O Queue"];
		});
	}
	
	return _imageIOQueue;
}

- (NSString *)pathForHash:(NSString *)hash
				   atSize:(CGSize)size
				withScale:(CGFloat)scale
{
	NSString *cachePath = [[self class] amazeKitCachePath];
	NSString *baseHashPath = [[cachePath stringByAppendingPathComponent:@"__RenderedImageCache__"] stringByAppendingPathComponent:hash];
	
	__block BOOL isDirectory;
	__block BOOL directoryExists = NO;
	
	NSBlockOperation *directoryExistsOperation = [NSBlockOperation blockOperationWithBlock:^{
		directoryExists = [self.fileManager fileExistsAtPath:baseHashPath
                                                 isDirectory:&isDirectory];
	}];
	
	[self.imageIOQueue addOperation:directoryExistsOperation];
	[directoryExistsOperation waitUntilFinished];
	
	if (directoryExists == YES && isDirectory == NO) {
		__block BOOL success = NO;
		
		NSBlockOperation *removeItemOperation = [NSBlockOperation blockOperationWithBlock:^{
			success = [self.fileManager removeItemAtPath:baseHashPath error:NULL];
		}];
		
		[self.imageIOQueue addOperation:removeItemOperation];
		[removeItemOperation waitUntilFinished];
		
		if (success == YES) {
			directoryExists = NO;
		}
	}
	
	if (directoryExists == NO) {
		NSBlockOperation *createDirectoryOperation = [NSBlockOperation blockOperationWithBlock:^{
            [self.fileManager createDirectoryAtPath:baseHashPath
                        withIntermediateDirectories:YES
                                         attributes:nil
                                              error:NULL];
        }];
		
		[self.imageIOQueue addOperation:createDirectoryOperation];
		[createDirectoryOperation waitUntilFinished];
	}
	
	NSString *dimensionsRepresentation = [self dimensionsRepresentationWithSize:size scale:scale];
	
	NSString *imagePath = [[baseHashPath stringByAppendingPathComponent:dimensionsRepresentation]
						   stringByAppendingPathExtension:@"png"];
	
	return imagePath;
}

- (NSCache *)renderedImageCache
{
	if (_renderedImageCache == nil) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			_renderedImageCache = [[NSCache alloc] init];
			[_renderedImageCache setName:@"AmazeKit Rendered Image Cache"];
		});
	}
	
	return _renderedImageCache;
}

#pragma mark -

@end
