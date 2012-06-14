//
//  AKButtonBevelImageEffect.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKButtonBevelImageEffect.h"

#import "UIImage+AKPixelData.h"


@interface AKButtonBevelImageEffect() {
	CGFloat	*_whiteBevelData;
	CGFloat *_blackBevelData;
	NSUInteger _width;
}

- (void)setBlackBevelValue:(CGFloat)value
				   atPoint:(CGPoint)point;
- (void)setWhiteBevelValue:(CGFloat)value
				   atPoint:(CGPoint)point;
- (CGFloat)blackBevelValueAtPoint:(CGPoint)point;
- (CGFloat)whiteBevelValueAtPoint:(CGPoint)point;

@end

@implementation AKButtonBevelImageEffect

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	CGSize sourceImageSize = [sourceImage size];
	_width = sourceImageSize.width * [sourceImage scale];
	NSUInteger height = sourceImageSize.height * [sourceImage scale];
	
	// Create an array of CGFloats, which will correspond to the alpha to use for that pixel.
	unsigned long count = _width * height;
	unsigned long size = sizeof(CGFloat);
	_whiteBevelData = calloc(count, size);
	_blackBevelData = calloc(count, size);
	
	// Get the pixel data of the original image.
	NSData *pixelData = [sourceImage AK_rawRGBA8888Data];
	uint8_t *rawData = (uint8_t *)[pixelData bytes];

	CGPoint point = CGPointZero;

	for (NSUInteger y = 0; y < height; y++) {
		CGFloat whiteAlpha = (((CGFloat)height - (CGFloat)y) / (CGFloat)height) / 2.0f;
		CGFloat blackAlpha = ((CGFloat)y / (CGFloat)height) / 3.0f;
		point.y = y;
		
		for (NSUInteger x = 0; x < _width; x++) {
			point.x = x;
			
			AKPixelData pixelData = AKGetPixelDataFromRGBA8888Data(rawData,
																   _width,
																   height,
																   x,
																   y);
			
			if (pixelData.alpha == 0) {
				if (y + 1 < height) {
					AKPixelData underneathPixelData = AKGetPixelDataFromRGBA8888Data(rawData,
																					 _width,
																					 height,
																					 x,
																					 y + 1);
					
					if (underneathPixelData.alpha > 0) {
						[self setWhiteBevelValue:whiteAlpha atPoint:CGPointMake(x, y + 1)];
					}
				}
			}
			else if (y == 0) {
				[self setWhiteBevelValue:whiteAlpha atPoint:point];
			}
			else if (y + 1 == height) {
				[self setBlackBevelValue:blackAlpha atPoint:point];
			}
			else {
				AKPixelData underneathPixelData = AKGetPixelDataFromRGBA8888Data(rawData,
																				 _width,
																				 height,
																				 x,
																				 y + 1);
				
				if (underneathPixelData.alpha == 0) {
					[self setBlackBevelValue:blackAlpha atPoint:point];
				}
			}
			
			CGFloat currentWhiteLevel = [self whiteBevelValueAtPoint:point];
			for (NSUInteger i = 1; currentWhiteLevel > 0.05f; i++) {
				AKPixelData underneathPixelData = AKGetPixelDataFromRGBA8888Data(rawData,
																				 _width,
																				 height,
																				 x,
																				 y + i);
				
				if (underneathPixelData.alpha > 0) {
					currentWhiteLevel = (currentWhiteLevel / (4.0f / [sourceImage scale]));
					[self setWhiteBevelValue:currentWhiteLevel
									 atPoint:CGPointMake(x, y + i)];
				}
			}
			
			CGFloat currentBlackLevel = [self blackBevelValueAtPoint:point];
			for (NSUInteger i = 1; currentBlackLevel > 0.05f; i++) {
				AKPixelData underneathPixelData = AKGetPixelDataFromRGBA8888Data(rawData,
																				 _width,
																				 height,
																				 x,
																				 y - i);
				
				if (underneathPixelData.alpha > 0) {
					currentBlackLevel = (currentBlackLevel / (4.0f / [sourceImage scale]));
					[self setBlackBevelValue:currentBlackLevel
									 atPoint:CGPointMake(x, y - i)];
				}
			}
		}
	}
		
	// Create an image context to draw into.
	CGColorSpaceRef maskColorSpace = CGColorSpaceCreateDeviceRGB();
	size_t numberOfComponents = CGColorSpaceGetNumberOfComponents(maskColorSpace);
	
	int bitsPerComponent = 8;
	int bytesPerPixel = ((numberOfComponents + 1) * bitsPerComponent) / 8;
	int bytesPerRow = bytesPerPixel * _width;

	// Create the data buffer for the image.
	uint8_t *imageData = calloc(_width * height, bytesPerPixel);
	
	for (NSUInteger x = 0; x < _width; x++) {
		point.x = x;
		
		for (NSUInteger y = 0; y < height; y++) {
			point.y = y;
			
			AKPixelData pixelData = AKGetPixelDataFromRGBA8888Data(rawData,
																   _width,
																   height,
																   x,
																   y);
			
			CGFloat whiteAlpha = [self whiteBevelValueAtPoint:point] * (CGFloat)((CGFloat)pixelData.alpha / (CGFloat)UINT8_MAX);
			CGFloat blackAlpha = [self blackBevelValueAtPoint:point];
			
			int offset = (bytesPerRow * y) + (bytesPerPixel * x);

			if (whiteAlpha > 0.05f) {
				int i;
				
				for (i = 0; i < numberOfComponents; i++) {
					imageData[offset + i] = (uint8_t)((CGFloat)UINT8_MAX * whiteAlpha);
				}
				
				imageData[offset + i] = (uint8_t)((CGFloat)UINT8_MAX * whiteAlpha);
			}
			
			if (blackAlpha > 0.0f) {
				int i;
				
				for (i = 0; i < numberOfComponents; i++) {
					imageData[offset + i] = 0;
				}
				
				imageData[offset + i] = (uint8_t)((CGFloat)UINT8_MAX * blackAlpha);
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
	UIGraphicsBeginImageContextWithOptions([sourceImage size], NO, 0.0f);
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
	
	free(_whiteBevelData), _whiteBevelData = NULL;
	free(_blackBevelData), _blackBevelData = NULL;
	
	return renderedImage;
}

- (void)setBlackBevelValue:(CGFloat)value
				   atPoint:(CGPoint)point
{
	_blackBevelData[((NSUInteger)point.y * _width) + (NSUInteger)point.x] = value;
}

- (void)setWhiteBevelValue:(CGFloat)value
				   atPoint:(CGPoint)point
{
	_whiteBevelData[((NSUInteger)point.y * _width) + (NSUInteger)point.x] = value;
}

- (CGFloat)blackBevelValueAtPoint:(CGPoint)point
{
	return _blackBevelData[((NSUInteger)point.y * _width) + (NSUInteger)point.x];
}

- (CGFloat)whiteBevelValueAtPoint:(CGPoint)point
{
	return _whiteBevelData[((NSUInteger)point.y * _width) + (NSUInteger)point.x];
}

@end
