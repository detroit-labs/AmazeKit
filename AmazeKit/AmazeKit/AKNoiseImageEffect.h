//
//  AKNoiseImageEffect.h
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


#import "AKImageEffect.h"


/** The AKNoiseImageEffect class draws random noise. Every pixel is filled with a random value.
 *  AKNoiseImageEffect uses arc4random_uniform() to ensure a uniform distribution of randomness.
 */


typedef enum {
	AKNoiseTypeBlackAndWhite = 0,
	AKNoiseTypeColor
} AKNoiseType;


@interface AKNoiseImageEffect : AKImageEffect

/**-------------------------------------------
 * @name Creating a Noise Image Effect
 * -------------------------------------------
 */

/** The designated initializer for a noise image effect.
 *
 *  @param alpha The value for the alpha property.
 *  @param blendMode The value for the blendMode property.
 *  @param noiseType The value for the noiseType property.
 *  @return An initialized image effect.
 */
- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
		  noiseType:(AKNoiseType)noiseType;

/**----------------------------
 * @name Customizing Appearance
 * ----------------------------
 */

/** The type of noise to draw. AKNoiseTypeBlackAndWhite, the default, draws black-and-white noise,
 *  while AKNoiseTypeColor draws noise in random colors.
 */
@property (readonly) AKNoiseType	noiseType;

@end
