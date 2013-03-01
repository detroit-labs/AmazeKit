//
//  AKInnerShadowImageEffect.h
//  AmazeKit
//
//  Created by Jeff Kelley on 8/29/12.
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


/** The AKInnerShadowImageEffect class creates a shadow on the inside of the image.
 */


@interface AKInnerShadowImageEffect : AKImageEffect

/**-------------------------------------------
 * @name Creating an Inner Shadow Image Effect
 * -------------------------------------------
 */

/** The designated initializer for an inner shadow image effect.
 *
 *  @param alpha The value for the alpha property.
 *  @param blendMode The value for the blendMode property.
 *  @param color The color to draw the shadow.
 *  @param radius The radius for the shadow. This is not the offset, but how far from the offset to
 *                draw the shadow.
 *  @param offset The offset (from the origin) to start drawing the shadow.
 *  @return An initialized image effect.
 */
- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			  color:(UIColor *)color
			 radius:(CGFloat)radius
			 offset:(CGSize)offset;


/**----------------------------
 * @name Customizing Appearance
 * ----------------------------
 */

/** The color of the shadow. */
@property (readonly) UIColor	*color;

/** The radius of the shadow. */
@property (readonly) CGFloat	radius;

/** The offset of the shadow. */
@property (readonly) CGSize 	offset;

@end
