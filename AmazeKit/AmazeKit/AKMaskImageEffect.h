//
//  AKMaskImageEffect.h
//  AmazeKit
//
//  Created by Jeff Kelley on 8/6/12.
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


#import "AKImageEffect.h"


/** The AKMaskImageEffect masks the layers beneath it behind a mask image.
 */


// Constants
extern NSString * const kMaskImageHashKey;


@interface AKMaskImageEffect : AKImageEffect

/**----------------------------------
 * @name Creating a Mask Image Effect
 * ----------------------------------
 */

/** The designated initializer for a mask image effect.
 *
 *  @param alpha The value for the alpha property.
 *  @param blendMode The value for the blendMode property.
 *  @param maskImage The value for the maskImage property.
 *  @return An initialized image effect.
 */
- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
		  maskImage:(UIImage *)maskImage;


/**----------------------------
 * @name Customizing Appearance
 * ----------------------------
 */

/** The image to use as a mask. The alpha channel of the image is used—opaque values show the
 *  underneath layers opaque, transparent values do not.
 */
@property (readonly) UIImage	*maskImage;

@end
