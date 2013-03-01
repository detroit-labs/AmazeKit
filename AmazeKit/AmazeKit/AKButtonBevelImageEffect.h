//
//  AKButtonBevelImageEffect.h
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


/** The AKButtonBevelImageEffect class creates a white bevel on the top of a button image, and a
 *  black bevel on the botton of the button (or vice-versa).
 */


typedef enum {
	AKButtonBevelDirectionUp = 0,
	AKButtonBevelDirectionDown
} AKButtonBevelDirection;


@interface AKButtonBevelImageEffect : AKImageEffect

/**-------------------------------------------
 * @name Creating an Inner Shadow Image Effect
 * -------------------------------------------
 */

/** The designated initializer for an inner shadow image effect.
 *
 *  @param alpha The value for the alpha property.
 *  @param blendMode The value for the blendMode property.
 *  @param bevelDirection The direction of the bevel. AKButtonBevelDirectionUp, the default, has a
 *         shine on top and a shadow on bottom. AKButtonBevelDirectionDown is the reverse.
 *  @return An initialized image effect.
 */
- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
	 bevelDirection:(AKButtonBevelDirection)bevelDirection;

/**----------------------------
 * @name Customizing Appearance
 * ----------------------------
 */

/** The direction of the bevel. */
@property (readonly) AKButtonBevelDirection	bevelDirection;

@end
