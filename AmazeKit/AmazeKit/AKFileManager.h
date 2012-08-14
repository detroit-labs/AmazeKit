//
//  AKFileManager.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/16/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface AKFileManager : NSObject

// Object Lifecycle
+ (id)defaultManager;
+ (NSString *)amazeKitCachePath;
+ (NSURL *)amazeKitCacheURL;

- (BOOL)cachedImageExistsForHash:(NSString *)descriptionHash
						  atSize:(CGSize)size
					   withScale:(CGFloat)scale;

- (void)cacheImage:(UIImage *)image
		   forHash:(NSString *)descriptionHash;

- (UIImage *)cachedImageForHash:(NSString *)descriptionHash
						 atSize:(CGSize)size
					  withScale:(CGFloat)scale;

@end
