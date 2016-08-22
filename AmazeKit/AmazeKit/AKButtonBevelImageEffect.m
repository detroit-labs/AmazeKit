//
//  AKButtonBevelImageEffect.m
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


#import "AKButtonBevelImageEffect.h"

#import "UIImage+AZKPixelData.h"


@interface AKButtonBevelImageEffect() {
	CGFloat	*_upperBevelData;
	CGFloat *_lowerBevelData;
	NSUInteger _width;
}

- (CGFloat)lowerBevelValueAtPoint:(CGPoint)point;
- (void)setLowerBevelValue:(CGFloat)value
				   atPoint:(CGPoint)point;
- (void)setUpperBevelValue:(CGFloat)value
				   atPoint:(CGPoint)point;
- (CGFloat)upperBevelValueAtPoint:(CGPoint)point;

@end

@implementation AKButtonBevelImageEffect

@synthesize bevelDirection = _bevelDirection;

+ (BOOL)canRenderIndividually
{
	return NO;
}

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
	 bevelDirection:(AKButtonBevelDirection)bevelDirection
{
	self = [self initWithAlpha:alpha blendMode:blendMode];
	
	if (self) {
		_bevelDirection = bevelDirection;
	}
	
	return self;
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	[self obtainLock];
	
	CGSize sourceImageSize = [sourceImage size];
	
	_width = sourceImageSize.width * [sourceImage scale];
	NSUInteger height = sourceImageSize.height * [sourceImage scale];
	
	if (_width == 0 || height == 0) {
		return nil;
	}
	
	// Create an array of CGFloats, which will correspond to the alpha to use for that pixel.
	unsigned long count = _width * height;
	unsigned long size = sizeof(CGFloat);
	_upperBevelData = calloc(count, size);
	_lowerBevelData = calloc(count, size);
	
	// Get the pixel data of the original image.
	NSData *pixelData = [sourceImage azk_rawRGBA8888Data];
	uint8_t *rawData = (uint8_t *)[pixelData bytes];

	CGPoint point = CGPointZero;

	for (NSUInteger y = 0; y < height; y++) {
		CGFloat upperAlpha = (((CGFloat)height - (CGFloat)y) / (CGFloat)height) / 2.0f;
		CGFloat lowerAlpha = ((CGFloat)y / (CGFloat)height) / 3.0f;
		point.y = y;
		
		for (NSUInteger x = 0; x < _width; x++) {
			point.x = x;
			
            AZKPixelData pixelData = AZKPixelDataFromRGBA8888Data(rawData,
                                                                  _width,
                                                                  height,
                                                                  x,
                                                                  y);
			
			if (pixelData.alpha == 0) {
				if (y + 1 < height) {
                    AZKPixelData underneathPixelData =
                    AZKPixelDataFromRGBA8888Data(rawData,
                                                 _width,
                                                 height,
                                                 x,
                                                 y + 1);
					
					if (underneathPixelData.alpha > 0) {
						[self setUpperBevelValue:upperAlpha atPoint:CGPointMake(x, y + 1)];
					}
				}
			}
			else if (y == 0) {
				[self setUpperBevelValue:upperAlpha atPoint:point];
			}
			else if (y + 1 == height) {
				[self setLowerBevelValue:lowerAlpha atPoint:point];
                
			}
			else {
                AZKPixelData underneathPixelData =
                AZKPixelDataFromRGBA8888Data(rawData,
                                             _width,
                                             height,
                                             x,
                                             y + 1);
				
				if (underneathPixelData.alpha == 0) {
					[self setLowerBevelValue:lowerAlpha atPoint:point];
				}
			}
			
			CGFloat currentUpperLevel = [self upperBevelValueAtPoint:point];
			for (NSUInteger i = 1; y + i < height && currentUpperLevel > 0.05f; i++) {
                AZKPixelData underneathPixelData =
                AZKPixelDataFromRGBA8888Data(rawData,
                                             _width,
                                             height,
                                             x,
                                             y + i);
				
				if (underneathPixelData.alpha > 0) {
					currentUpperLevel = (currentUpperLevel / (4.0f / [sourceImage scale]));
					[self setUpperBevelValue:currentUpperLevel
									 atPoint:CGPointMake(x, y + i)];
				}
			}
			
			CGFloat currentBlackLevel = [self lowerBevelValueAtPoint:point];
			for (NSUInteger i = 1; i <= y && currentBlackLevel > 0.05f; i++) {
                AZKPixelData underneathPixelData =
                AZKPixelDataFromRGBA8888Data(rawData,
                                             _width,
                                             height,
                                             x,
                                             y - i);
				
				if (underneathPixelData.alpha > 0) {
					currentBlackLevel = (currentBlackLevel / (4.0f / [sourceImage scale]));
					[self setLowerBevelValue:currentBlackLevel
									 atPoint:CGPointMake(x, y - i)];
				}
			}
		}
	}
		
	// Create an image context to draw into.
	CGColorSpaceRef maskColorSpace = CGColorSpaceCreateDeviceRGB();
	size_t numberOfComponents = CGColorSpaceGetNumberOfComponents(maskColorSpace);
	
	size_t bitsPerComponent = 8;
	size_t bytesPerPixel = ((numberOfComponents + 1) * bitsPerComponent) / 8;
	size_t bytesPerRow = bytesPerPixel * _width;

	// Create the data buffer for the image.
	size_t numberOfPixels = _width * height;
	
	uint8_t *imageData = NULL;
	
	if (numberOfPixels > 0 && bytesPerPixel > 0) {
		imageData = calloc(numberOfPixels, bytesPerPixel);
		
		for (NSUInteger x = 0; x < _width; x++) {
			point.x = x;
			
			for (NSUInteger y = 0; y < height; y++) {
				point.y = y;
				
                AZKPixelData pixelData = AZKPixelDataFromRGBA8888Data(rawData,
                                                                      _width,
                                                                      height,
                                                                      x,
                                                                      y);
				
				CGFloat whiteAlpha = 0.0f;
				CGFloat blackAlpha = 0.0f;
				
				if ([self bevelDirection] == AKButtonBevelDirectionUp) {
					whiteAlpha = [self upperBevelValueAtPoint:point] * (CGFloat)((CGFloat)pixelData.alpha / (CGFloat)UINT8_MAX);
					blackAlpha = [self lowerBevelValueAtPoint:point];
				}
				else {
					whiteAlpha = [self lowerBevelValueAtPoint:point] * (CGFloat)((CGFloat)pixelData.alpha / (CGFloat)UINT8_MAX);
					blackAlpha = [self upperBevelValueAtPoint:point];
				}
				
				size_t offset = (bytesPerRow * y) + (bytesPerPixel * x);
				
				if (whiteAlpha > 0.05f) {
					size_t i;
					
					for (i = 0; i < numberOfComponents; i++) {
						imageData[offset + i] = (uint8_t)((CGFloat)UINT8_MAX * whiteAlpha);
					}
					
					imageData[offset + i] = (uint8_t)((CGFloat)UINT8_MAX * whiteAlpha);
				}
				
				if (blackAlpha > 0.0f) {
					size_t i;
					
					for (i = 0; i < numberOfComponents; i++) {
						imageData[offset + i] = 0;
					}
					
					imageData[offset + i] = (uint8_t)((CGFloat)UINT8_MAX * blackAlpha);
				}
			}
		}
	}
	
	CGContextRef maskContext = CGBitmapContextCreate((void *)imageData,
													 _width,
													 height,
													 bitsPerComponent,
													 bytesPerRow,
													 maskColorSpace,
													 kCGImageAlphaPremultipliedLast);
	
	CGImageRef bevelImageRef = CGBitmapContextCreateImage(maskContext);
		
	CGContextRelease(maskContext);
	CGColorSpaceRelease(maskColorSpace);
	free(imageData);
	
	// Render the bevel layer on top of the source image.
	UIGraphicsBeginImageContextWithOptions([sourceImage size], NO, [sourceImage scale]);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(context, 0.0f, [sourceImage size].height);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, sourceImageSize.width, sourceImageSize.height), [sourceImage CGImage]);
	
	[self applyAppearanceProperties];
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, sourceImageSize.width, sourceImageSize.height), bevelImageRef);
	CGImageRelease(bevelImageRef);
	
	UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	context = NULL;
	
	free(_upperBevelData), _upperBevelData = NULL;
	free(_lowerBevelData), _lowerBevelData = NULL;
	
	[self releaseLock];
	
	return renderedImage;
}

- (CGFloat)lowerBevelValueAtPoint:(CGPoint)point
{
	return _lowerBevelData[((NSUInteger)point.y * _width) + (NSUInteger)point.x];
}

- (void)setLowerBevelValue:(CGFloat)value
				   atPoint:(CGPoint)point
{
	_lowerBevelData[((NSUInteger)point.y * _width) + (NSUInteger)point.x] = value;
}

- (void)setUpperBevelValue:(CGFloat)value
				   atPoint:(CGPoint)point
{
	_upperBevelData[((NSUInteger)point.y * _width) + (NSUInteger)point.x] = value;
}

- (CGFloat)upperBevelValueAtPoint:(CGPoint)point
{
	return _upperBevelData[((NSUInteger)point.y * _width) + (NSUInteger)point.x];
}

@end
