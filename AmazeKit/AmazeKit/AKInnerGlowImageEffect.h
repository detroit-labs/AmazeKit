//
//  AKInnerGlowImageEffect.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/25/12.
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


#import "AKInnerShadowImageEffect.h"


/** The AKInnerGlowImageEffect class creates a shadow on the inside of the image. It’s like an
 *  inner shadow with no offset.
 *
 *  This class should probably be re-implemented to be a true inner glow, not an inner shadow. Pull
 *  requests welcome.
 */


@interface AKInnerGlowImageEffect : AKInnerShadowImageEffect

/**-----------------------------------------
 * @name Creating an Inner Glow Image Effect
 * -----------------------------------------
 */

/** The designated initializer for an inner glow image effect.
 *
 *  Because image effects are immutable (for performance reasons), you’ll need to set the proper
 *  values for the properties at time of creation. Subclasses should specify additional parameters
 *  in their own initializers.
 *
 *  @param alpha The value for the alpha property.
 *  @param blendMode The value for the blendMode property.
 *  @param color The color to draw the shadow.
 *  @param radius The radius for the shadow.
 *  @return An initialized image effect.
 */
- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			  color:(UIColor *)color
			 radius:(CGFloat)radius;

@end
