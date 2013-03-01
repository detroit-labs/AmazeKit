//
//  AKImageEffect.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/11/12.
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


/** The AKImageEffect class is the heart and soul of AmazeKit. Image effects represent a single
 *  layer of an image, like layers of an onion. The final image produced is the result of taking all
 *  of the image effects and layering them on top of one another.
 */

// KVO Constants
extern NSString * const AKImageEffectDirtyKeyPath;


@interface AKImageEffect : NSObject

/**------------------------------
 * @name Creating an Image Effect
 * ------------------------------
 */

/** The designated initializer for a base image effect.
 *
 *  Because image effects are immutable (for performance reasons), you’ll need to set the proper
 *  values for the properties at time of creation. Subclasses should specify additional parameters
 *  in their own initializers.
 *
 *  @param alpha The value for the alpha property.
 *  @param blendMode The value for the blendMode property.
 *  @return An initialized image effect.
 */
- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode;

/**----------------------------
 * @name Customizing Appearance
 * ----------------------------
 */

/** The opacity of the effect. 1 is fully opaque, 0 is fully transparent. */
@property (readonly) CGFloat alpha;

/** The blend mode to use when rendering the effect on the layer below it. See Apple’s documentation
 *  for all supported blend modes.
 */
@property (readonly) CGBlendMode blendMode;

/**---------------
 * @name Rendering
 * ---------------
 */

/** If the image effect can be rendered using image data from other layers, return `YES`. Otherwise,
 *  return NO.
 *
 *  @return `YES` if the effect can be rendered on its own, `NO` if it relies on image data from
 *          other layers.
 */
+ (BOOL)canRenderIndividually;

/** In the implementation of renderImageFromSourceImage:withSize: in an image effect subclass, call
 *  this method to apply appearance properties defined in AKImageEffect, currently alpha and
 *  blendMode.
 *
 *  This method expects you to have set up a graphics context and will therefore call
 *  UIGraphicsGetCurrentContext() or the equivalent in its implementation.
 */
- (void)applyAppearanceProperties;

/** If an image effect maintains internal state and cannot render multiple images concurrently, use
 *  this method to obtain a lock during rendering.
 */
- (void)obtainLock;

/** Releases a lock obtained with the obtainLock method. */
- (void)releaseLock;

/** This method should be implemented by image effects that depend on the layer beneath them to
 *  render (and so their class will return `NO` in its implementation of canRenderIndividually).
 *
 *  @param sourceImage The composited layer image effects to render on top of.
 *  @result The rendered image in its entirety.
 */
- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage;

/** This method should be implemented by image effects that do not depend on other layers to render.
 *
 *  @param size The size in points to render.
 *  @param scale The scale to use when rendering. Retina displays, for instance, will have a scale
 *               of 2.
 */
- (UIImage *)renderedImageForSize:(CGSize)size
						  atScale:(CGFloat)scale;

/**-------------
 * @name Caching
 * -------------
 */

/** Returns the mutability of the image effect.
 *
 *  @return `YES` if the class is immutable (the default), `NO` if it is mutable.
 */
+ (BOOL)isImmutable;

/** Stores the rendered image in a cache. Do not implement your own cache.
 *
 *  @param image The rendered image.
 */
- (void)cacheRenderedImage:(UIImage *)image;

/** Mutable image effects should set the value of `dirty` to `YES` when they change. Setting `dirty`
 *  to `YES` will result in the representativeHash: method recomputing the hash.
 */
@property (getter = isDirty) BOOL dirty;

/** For efficient caching, the output from the reprsesentativeDictionary method is converted into
 *  minified canonical JSON, then stored as a sha1 hash.
 *
 *  @return The hashed dictionary data as an NSString.
 */
- (NSString *)representativeHash;

/** Loads an image from the cache for the appropriate size and scale.
 *
 *  @param size The size of the cached image to load.
 *  @param scale The scale of the cached image to load.
 *
 *  @return If a cached image is found, the image. Otherwise, `nil`.
 */
- (UIImage *)previouslyRenderedImageForSize:(CGSize)size
									atScale:(CGFloat)scale;

/**--------------------
 * @name Representation
 * --------------------
 */

/** Parses a dictionary representing an image effect, creates a new image effect, and initializes
 *  it with values from the dictionary.
 *
 *  @param representativeDictionary The dictionary to parse into an image effect.
 *  @return An AKImageEffect or AKImageEffect subclass initilaized with values from the dictionary.
 */
+ (id)effectWithRepresentativeDictionary:(NSDictionary *)representativeDictionary;

/** Initializes an image effect with values from a dictionary.
 *
 *  @param representativeDictionary The dictionary to parse into an image effect.
 *  @return An AKImageEffect or AKImageEffect subclass initilaized with values from the dictionary.
 */
- (id)initWithRepresentativeDictionary:(NSDictionary *)representativeDictionary;

/** Every image effect can be represented by a dictionary. This can be converted to and from JSON,
 *  allowing image properties to be stored in a lightweight text format, read from a server, etc.
 *
 *  @return An NSDictionary completely representing the image effect.
 */
- (NSDictionary *)representativeDictionary;

@end
