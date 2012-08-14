//
//  AKFileManager.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/16/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKFileManager.h"

#import "AKDrawingUtilities.h"

@interface AKFileManager()

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
		sharedInstance = [[self alloc] init];
	}
	
	return sharedInstance;
}

+ (NSString *)amazeKitCachePath
{
	return [[self amazeKitCacheURL] path];
}

+ (NSURL *)amazeKitCacheURL
{
	NSURL *amazeKitCacheURL = nil;
	
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
	
	return amazeKitCacheURL;
}

#pragma mark -

- (BOOL)cachedImageExistsForHash:(NSString *)descriptionHash
						  atSize:(CGSize)size
					   withScale:(CGFloat)scale
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[self pathForHash:descriptionHash
																	   atSize:size
																	withScale:scale]];
}

- (void)cacheImage:(UIImage *)image forHash:(NSString *)descriptionHash
{
	NSData *imageData = UIImagePNGRepresentation(image);
	
	if (imageData != nil) {
		NSString *path = [self pathForHash:descriptionHash
									atSize:[image size]
								 withScale:[image scale]];
		
		NSError *error = nil;
		BOOL success = [imageData writeToFile:path
									  options:NSDataWritingAtomic
										error:&error];
		
		if (success == NO) {
			NSLog(@"Could not cache image with size %@ and scale %.0f to path: %@ error: %@",
				  NSStringFromCGSize([image size]),
				  [image scale],
				  path,
				  [error localizedDescription]);
		}
	}
}

- (NSString *)pathForHash:(NSString *)hash
				   atSize:(CGSize)size
				withScale:(CGFloat)scale
{
	NSString *cachePath = [[self class] amazeKitCachePath];
	NSString *baseHashPath = [[cachePath stringByAppendingPathComponent:@"__RenderedImageCache__"] stringByAppendingPathComponent:hash];
	
	BOOL isDirectory;
	BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:baseHashPath isDirectory:&isDirectory];
	
	if (directoryExists == YES && isDirectory == NO) {
		BOOL success = [[NSFileManager defaultManager] removeItemAtPath:baseHashPath error:NULL];
		
		if (success == YES) {
			directoryExists = NO;
		}
	}
	
	if (directoryExists == NO) {
		[[NSFileManager defaultManager] createDirectoryAtPath:baseHashPath
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
	}
		
	NSString *dimensionsRepresentation = [NSString stringWithFormat:@"{%dx%dx%d}",
										  (int)size.width,
										  (int)size.height,
										  (int)scale];
	
	NSString *imagePath = [[baseHashPath stringByAppendingPathComponent:dimensionsRepresentation] stringByAppendingPathExtension:@"png"];
	
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
