//
//  AKFileManager.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/16/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKFileManager.h"


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

@end
