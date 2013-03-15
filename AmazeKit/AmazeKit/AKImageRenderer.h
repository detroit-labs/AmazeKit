//
//  AKImageRenderer.h
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


/** The AKImageRenderer class is the workhorse of AmazeKit where image rendering actually happens.
 *  Each image renderer maintains an array of image effects that are rendered in sequence, thereby
 *  producing a final image.
 */

// Options Dictionary Keys
extern NSString * const AKImageRendererOptionKeyInitialBackgroundColor;

// Notifications
extern NSString * const AKImageRendererEffectDidChangeNotification;


@interface AKImageRenderer : NSObject

/**---------------------------
 * @name Customizing Rendering
 * ---------------------------
 */

/** An array of AKImageEffect objects, applied in order.
 */
@property (strong, nonatomic) NSArray	*imageEffects;

/** A dictionary of options that will be applied to all images rendered with the renderer.
 */
@property (strong) NSDictionary	*options;


/**--------------------------
 * @name Performing Rendering
 * --------------------------
 */

/** The main rendering method for an image renderer.
 *
 *  @param size The size (in screen points) to render the final image.
 *  @param scale The scale to render the image with. Specify 1 for non-Retina and 2 for Retina
 *               screens.
 *  @param options A dictionary containing configuration settings for the renderer. Values
 *                 specified in this dictionary overwrite values in the options property.
 *  @return A fully-rendered UIImage for the given image effects and given size.
 */
- (UIImage *)imageWithSize:(CGSize)size
					 scale:(CGFloat)scale
				   options:(NSDictionary *)options;


/**-------------
 * @name Caching
 * -------------
 */

/** Generates a dictionary representing previously-rendered images, useful for generating
 *  pre-rendered images at app startup. The keys are the sizes turned into a string, and the values
 *  are sets containing the options dictionaries passed for that size, or an NSNull object to
 *  represent nil options.
 *
 *  @return A dictionary of previously-rendered image information.
 */
- (NSDictionary *)renderedImages;

/** For efficient caching, the output from the reprsesentativeDictionary method is converted into
 *  minified canonical JSON, then stored as a sha1 hash.
 *
 *  @return The hashed dictionary data as an NSString.
 */
- (NSString *)representativeHash;

/** Returns a hashed dictionary representation using the given options merged with the options
 *  property.
 *
 *  @param options Settings applied to the image renderer for which the hash is being computed.
 *  @return The hashed dictionary data as an NSString.
 */
- (NSString *)representativeHashWithOptions:(NSDictionary *)options;


/**--------------------
 * @name Representation
 * --------------------
 */

/** Initializes an image renderer with values from a dictionary.
 *
 *  @param representativeDictionary The dictionary to parse into an image renderer.
 *  @return An image renderer initilaized with values from the dictionary.
 */
- (id)initWithRepresentativeDictionary:(NSDictionary *)representativeDictionary;

/** Every image effect can be represented by a dictionary. This can be converted to and from JSON,
 *  allowing image properties to be stored in a lightweight text format, read from a server, etc.
 *  Likewise, an image renderer can be represented in a dictionary, which would include the
 *  representations of its image effects.
 *
 *  @return An NSDictionary completely representing the image renderer.
 */
- (NSDictionary *)representativeDictionary;

@end
