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


typedef enum {
	AKButtonBevelDirectionUp = 0,
	AKButtonBevelDirectionDown
} AKButtonBevelDirection;


@interface AKButtonBevelImageEffect : AKImageEffect

// “Up,” the default, has a shine on top and a shadow on bottom. “Down” is the reverse.
@property (readonly) AKButtonBevelDirection	bevelDirection;

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
	 bevelDirection:(AKButtonBevelDirection)bevelDirection;

@end
