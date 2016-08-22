//
//  UIImage+AZKPixelData.m
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

#import "UIImage+AZKPixelData.h"

const AZKPixelData AZKPixelDataZero = {0, 0, 0, 0};

@implementation UIImage (AZKPixelData)

- (NSData *)azk_rawRGBA8888Data
{
	// First get the image into your data buffer
    CGImageRef imageRef = [self CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    uint8_t *rawData = (uint8_t*)calloc(height * width * 4, sizeof(uint8_t));
	
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
	
    CGContextRef context = CGBitmapContextCreate(rawData,
												 width,
												 height,
												 bitsPerComponent,
												 bytesPerRow,
												 colorSpace,
												 (kCGImageAlphaPremultipliedLast |
												  kCGBitmapByteOrder32Big));
    CGColorSpaceRelease(colorSpace);
	
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
	
    CGContextRelease(context);
	
	NSData *data = [[NSData alloc] initWithBytes:(const void *)rawData
										  length:height * width * 4 * sizeof(uint8_t)];
	
	free(rawData);
	
	return data;
}

@end

AZKPixelData AZKPixelDataFromRGBA8888Data(uint8_t *rawData,
                                          NSUInteger width,
                                          NSUInteger height,
                                          NSUInteger x,
                                          NSUInteger y)
{
	size_t bytesPerPixel = 4; // ARGB8888
	size_t bytesPerRow = bytesPerPixel * width;
	
	size_t byteIndex = (bytesPerRow * y) + (x * bytesPerPixel);
	
	AZKPixelData pixelData;
	
	pixelData.red   = rawData[byteIndex];
	pixelData.green = rawData[byteIndex + 1];
	pixelData.blue  = rawData[byteIndex + 2];
	pixelData.alpha = rawData[byteIndex + 3];
	
	return pixelData;
}

