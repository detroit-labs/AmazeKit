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


// Options Dictionary Keys
extern NSString * const AKImageRendererOptionKeyInitialBackgroundColor;

// Notifications
extern NSString * const AKImageRendererEffectDidChangeNotification;


@interface AKImageRenderer : NSObject

// An array of AKImageEffect objects, applied in order.
@property (strong, nonatomic) NSArray	*imageEffects;

// A dictionary of options that will be applied to all images rendered with the renderer.
@property (strong) NSDictionary	*options;

- (UIImage *)imageWithSize:(CGSize)size
					 scale:(CGFloat)scale
				   options:(NSDictionary *)options;

- (NSDictionary *)representativeDictionary;
- (NSString *)representativeHash;
- (NSString *)representativeHashWithOptions:(NSDictionary *)options;
- (id)initWithRepresentativeDictionary:(NSDictionary *)representativeDictionary;

// A dictionary representing previously-rendered images, useful for generating pre-rendered images
// at app startup. The keys are the size turned into a string, and the values are a set containing
// the options dictionaries passed for that size or an NSNull object to represent nil options.
- (NSDictionary *)renderedImages;

@end
