//
//  AKFileManager.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/16/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKFileManager.h"


@interface AKFileManager()

- (NSString *)pathForHash:(NSString *)hash
				   atSize:(CGSize)size;

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
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[self pathForHash:descriptionHash atSize:size]];
}

- (void)cacheImage:(UIImage *)image forHash:(NSString *)descriptionHash
{
	NSData *imageData = UIImagePNGRepresentation(image);
	
	if (imageData != nil) {
		CGSize imageSize = [image size];
		NSString *path = [self pathForHash:descriptionHash atSize:imageSize];
		
		NSError *error = nil;
		BOOL success = [imageData writeToFile:path
									  options:NSDataWritingAtomic
										error:&error];
		
		if (success == NO) {
			NSLog(@"Could not cache image to path: %@ error: %@", path, [error localizedDescription]);
		}
	}
}

- (NSString *)pathForHash:(NSString *)hash atSize:(CGSize)size
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
		
	NSString *imagePath = [[baseHashPath stringByAppendingPathComponent:NSStringFromCGSize(size)] stringByAppendingPathExtension:@"png"];
	
	return imagePath;
}

- (UIImage *)cachedImageForHash:(NSString *)descriptionHash atSize:(CGSize)size
{
	UIImage *cachedImage = nil;
	
	if ([self cachedImageExistsForHash:descriptionHash atSize:size] == YES) {
		cachedImage = [[UIImage alloc] initWithContentsOfFile:[self pathForHash:descriptionHash atSize:size]];
	}
	
	return cachedImage;
}

#pragma mark -

@end
