//
//  UIImage+AKPixelData.h
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


#import <UIKit/UIKit.h>


// Helper C functions
typedef struct {
	uint8_t red;
	uint8_t blue;
	uint8_t green;
	uint8_t alpha;
} AKPixelData;

extern const AKPixelData AKPixelDataZero;


AKPixelData AKGetPixelDataFromRGBA8888Data(uint8_t *rawData, NSUInteger width, NSUInteger height,
										   NSUInteger x, NSUInteger y);


@interface UIImage (AKPixelData)

- (NSData *)AK_rawRGBA8888Data;

@end
