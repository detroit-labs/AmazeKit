//
//  AKColorImageEffect.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
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


/** The AKColorImageEffect paints the entire image the given color. Best used with the “color”
 *  blend mode to colorize an image.
 */


// KVO Constants
extern NSString * const AKColorImageEffectColorKeyPath;


@interface AKColorImageEffect : AKImageEffect

/**-----------------------------------
 * @name Creating a Color Image Effect
 * -----------------------------------
 */

/** The designated initializer for a color image effect.
 *
 *  @param alpha The value for the alpha property.
 *  @param blendMode The value for the blendMode property.
 *  @param cornerRadii The value for the cornerRadii property.
 *  @return An initialized image effect.
 */
- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			  color:(UIColor *)color;


/**----------------------------
 * @name Customizing Appearance
 * ----------------------------
 */

/** The color to paint in the image. */
@property (readonly) UIColor	*color;

@end
