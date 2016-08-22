//
//  UIImage+AZKMasking.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (AZKMasking)

// Creates an image with inverted alpha values suitable for use as a mask.
@property (nonatomic, readonly) UIImage *azk_reverseMaskImage;

// Creates a mask image like AK_reverseMaskImage, but where every pixel is either
// entirely opaque or empty.
@property (nonatomic, readonly) UIImage *azk_reverseMaskImageNoFeather;

@end

NS_ASSUME_NONNULL_END
