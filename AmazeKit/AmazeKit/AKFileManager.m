//
//  AKFileManager.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/16/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKFileManager.h"

#import "AKDrawingUtilities.h"

@interface AKFileManager() {
	NSFileManager   	*_fileManager;
	NSOperationQueue	*_imageIOQueue;
}

- (NSFileManager *)fileManager;
- (NSOperationQueue *)imageIOQueue;

- (NSString *)pathForHash:(NSString *)hash
				   atSize:(CGSize)size
				withScale:(CGFloat)scale;

@end


@implementation AKFileManager

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
			amazeKitCachePath = [[self amazeKitCacheURL] path];
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
	
	NSString *path = [self pathForHash:descriptionHash
								atSize:size
							 withScale:scale];
	
	NSBlockOperation *imageExistsOperation = [NSBlockOperation blockOperationWithBlock:^{
		imageExists = [[self fileManager] fileExistsAtPath:path];
	}];
	
	[[self imageIOQueue] addOperation:imageExistsOperation];
	[imageExistsOperation waitUntilFinished];
	
	return imageExists;
}

- (void)cacheImage:(UIImage *)image forHash:(NSString *)descriptionHash
{
	NSData *imageData = UIImagePNGRepresentation(image);
	
	if (imageData != nil) {
		NSString *path = [self pathForHash:descriptionHash
									atSize:[image size]
								 withScale:[image scale]];
		
		__block NSError *error = nil;
		__block BOOL success = NO;
		
		NSBlockOperation *imageWritingOperation = [NSBlockOperation blockOperationWithBlock:^{
			success = [imageData writeToFile:path
									 options:NSDataWritingAtomic
									   error:&error];
			
			if (success == NO) {
				NSLog(@"Could not cache image with size %@ and scale %.0f to path: %@ error: %@",
					  NSStringFromCGSize([image size]),
					  [image scale],
					  path,
					  [error localizedDescription]);
			}
		}];
		
		// We want writing operations to have a higher priority to minimize the chance that multiple
		// threads would try to render the same image.
		[imageWritingOperation setQueuePriority:NSOperationQueuePriorityHigh];
		
		[[self imageIOQueue] addOperation:imageWritingOperation];
	}
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
		directoryExists = [[self fileManager] fileExistsAtPath:baseHashPath
												   isDirectory:&isDirectory];
	}];
	
	[[self imageIOQueue] addOperation:directoryExistsOperation];
	[directoryExistsOperation waitUntilFinished];
	
	if (directoryExists == YES && isDirectory == NO) {
		__block BOOL success = NO;
		
		NSBlockOperation *removeItemOperation = [NSBlockOperation blockOperationWithBlock:^{
			success = [[self fileManager] removeItemAtPath:baseHashPath error:NULL];
		}];
		
		[[self imageIOQueue] addOperation:removeItemOperation];
		[removeItemOperation waitUntilFinished];
		
		if (success == YES) {
			directoryExists = NO;
		}
	}
	
	if (directoryExists == NO) {
		NSBlockOperation *createDirectoryOperation = [NSBlockOperation blockOperationWithBlock:^{
			[[self fileManager] createDirectoryAtPath:baseHashPath
						  withIntermediateDirectories:YES
										   attributes:nil
												error:NULL];
		}];
		
		[[self imageIOQueue] addOperation:createDirectoryOperation];
		[createDirectoryOperation waitUntilFinished];
	}
	
	NSString *dimensionsRepresentation = [NSString stringWithFormat:@"{%dx%dx%d}",
										  (int)size.width,
										  (int)size.height,
										  (int)scale];
	
	NSString *imagePath = [[baseHashPath stringByAppendingPathComponent:dimensionsRepresentation]
						   stringByAppendingPathExtension:@"png"];
	
	return imagePath;
}

- (UIImage *)cachedImageForHash:(NSString *)descriptionHash
						 atSize:(CGSize)size
					  withScale:(CGFloat)scale
{
	UIImage *cachedImage = nil;
	
	if ([self cachedImageExistsForHash:descriptionHash
								atSize:size
							 withScale:scale] == YES) {
		cachedImage = [[UIImage alloc] initWithContentsOfFile:[self pathForHash:descriptionHash
																		 atSize:size
																	  withScale:scale]];
		
		if ((int)[cachedImage scale] != (int)scale) {
			cachedImage = [[UIImage alloc] initWithCGImage:[cachedImage CGImage]
													 scale:scale
											   orientation:[cachedImage imageOrientation]];
		}
	}
	
	return cachedImage;
}

#pragma mark -

@end
