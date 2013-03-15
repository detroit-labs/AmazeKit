//
//  AKFileManager.h
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


#import <Foundation/Foundation.h>


/** The AKFileManager class manages image persistence for AmazeKit rendering. Images are cached to
 *  disk to avoid a rendering penalty on each use. AKFileManager uses the ImageIO framework for
 *  blazing-fast disk access and custom PNG saving.
 *
 *  Generally speaking, you should not use these methods yourself. AmazeKit will cache images as
 *  needed.
 */

@interface AKFileManager : NSObject

/** -----------------------------
 *  @name Creating a File Manager
 *  -----------------------------
 */

/** Accesses the default AKFileManager instance.
 *
 *  @return the default file manager.
 */
+ (id)defaultManager;


/** -------------------
 *  @name Image Caching
 *  -------------------
 */

/** Returns the path to the on-disk cache for images.
 *
 *  @return The path in string format.
 */
+ (NSString *)amazeKitCachePath;

/** Returns the path to the on-disk cache for images.
 *
 *  @return The path in file URL format.
 */
+ (NSURL *)amazeKitCacheURL;

/** Returns whether or not an image has already been cached for a given hash. The hash could be
 *  for an AKImageEffect or AKImageRenderer.
 *
 *  @param descriptionHash The hashed dictionary representation of the image effect or image
 *                         renderer.
 *  @param size The size to look for on disk.
 *  @param scale The scale to look for on disk.
 *  @return YES if the file exists, NO if it does not.
 */
- (BOOL)cachedImageExistsForHash:(NSString *)descriptionHash
						  atSize:(CGSize)size
					   withScale:(CGFloat)scale;

/** Returns a previously-cached image from the on-disk cache.
 *
 *  @param descriptionHash The hashed dictionary representation of the image effect or image
 *                         renderer.
 *  @param size The size to look for on disk.
 *  @param scale The scale to look for on disk.
 *  @return The cached image.
 */
- (UIImage *)cachedImageForHash:(NSString *)descriptionHash
						 atSize:(CGSize)size
					  withScale:(CGFloat)scale;

/** Saves an image to the on-disk cache. The size and scale are inferred from the image data.
 *
 *  @param image The image to cache.
 *  @param descriptionHash The hash to use when saving the image.
 */
- (void)cacheImage:(UIImage *)image
           forHash:(NSString *)descriptionHash;

@end
