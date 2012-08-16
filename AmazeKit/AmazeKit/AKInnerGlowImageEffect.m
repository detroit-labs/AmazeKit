//
//  AKInnerGlowImageEffect.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/25/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKInnerGlowImageEffect.h"

#import "UIImage+AKPixelData.h"

#import "AKDrawingUtilities.h"


@implementation AKInnerGlowImageEffect

@synthesize color = _color;
@synthesize radius = _radius;

+ (BOOL)canRenderIndividually
{
	return NO;
}

- (id)initWithAlpha:(CGFloat)alpha blendMode:(CGBlendMode)blendMode
{
	self = [super initWithAlpha:alpha blendMode:blendMode];
	
	if (self) {
		_color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
	}
	
	return self;
}

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			  color:(UIColor *)color
			 radius:(CGFloat)radius
{
	self = [self initWithAlpha:alpha blendMode:blendMode];
	
	if (self) {
		_color = color;
		_radius = radius;
	}
	
	return self;
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	CGSize sourceImageSize = [sourceImage size];
	NSUInteger width = sourceImageSize.width * [sourceImage scale];
	NSUInteger height = sourceImageSize.height * [sourceImage scale];
	
	CGFloat radius = [self radius] * [sourceImage scale];
	
	// Create a buffer to fill in with alpha data
	CGFloat *buffer = calloc(width * height, sizeof(CGFloat));
	
	// Get the pixel data of the original image.
	NSData *pixelData = [sourceImage AK_rawRGBA8888Data];
	uint8_t *rawData = (uint8_t *)[pixelData bytes];
	
	// Make a buffer of pixel data structs
	AKPixelData *pixelDataBuffer = calloc(width * height, sizeof(AKPixelData));
	
	for (NSUInteger y = 0; y < height; y++) {
		for (NSUInteger x = 0; x < width; x++) {
			pixelDataBuffer[(y * width) + x] = AKGetPixelDataFromRGBA8888Data(rawData,
																			  width,
																			  height,
																			  x,
																			  y);
		}
	}
	
	// Walk the image, finding empty pixels and going off accordingly.
	for (NSUInteger y = 0; y < height; y++) {
		for (CGFloat x = 0; x < width; x++) {
			CGPoint point;
			point.y = y;
			point.x = x;
			
			CGFloat distance = DistanceToNearestEmptyPixel(pixelDataBuffer, width, height, x, y, radius, NULL);
			
			if (distance <= radius) {
				NSUInteger offset = (width * y) + x;

				AKPixelData pixelData = pixelDataBuffer[offset];
				CGFloat existingAlpha = (CGFloat)pixelData.alpha / (CGFloat)UINT8_MAX;
				CGFloat strength = (1.0 - (sqrtf(distance) / sqrtf(radius))) * existingAlpha;
				
				if (pixelData.alpha != 0 && buffer[offset] < strength) {
					buffer[offset] = strength;
				}
			}
		}
	}
	
	free(pixelDataBuffer);
	pixelDataBuffer = NULL;
	
	// Create an image context to draw into.
	CGColorRef colorRef = [[self color] CGColor];
	const CGFloat *colorComponents = CGColorGetComponents(colorRef);
	CGColorSpaceRef colorColorSpace = CGColorGetColorSpace(colorRef);
	size_t numberOfComponents = CGColorSpaceGetNumberOfComponents(colorColorSpace);
	
	int bitsPerComponent = 8;
	int bytesPerPixel = ((numberOfComponents + 1) * bitsPerComponent) / 8;
	int bytesPerRow = bytesPerPixel * width;
	
	// Create the data buffer for the image.
	uint8_t *imageData = calloc(width * height, bytesPerPixel);
	
	CGPoint point;
	for (NSUInteger y = 0; y < height; y++) {
		point.y = y;
		
		for (NSUInteger x = 0; x < width; x++) {
			point.x = x;
			
			int offset = (bytesPerRow * y) + (bytesPerPixel * x);
			
			CGFloat alpha = buffer[(width * y) + x];
			
			if (alpha != 0.0f) {
				for (size_t i = 0; i < numberOfComponents; i++) {
					CGFloat colorComponent = colorComponents[i];
					CGFloat premultipliedColor = colorComponent * alpha;
					
					imageData[offset + i] = (uint8_t)(premultipliedColor * (CGFloat)UINT8_MAX);
				}
				
				imageData[offset + numberOfComponents] = (uint8_t)(alpha * (CGFloat)UINT8_MAX);
			}
		}
	}
	
	CGContextRef imageContext = CGBitmapContextCreate((void *)imageData,
													  width,
													  height,
													  bitsPerComponent,
													  bytesPerRow,
													  colorColorSpace,
													  kCGImageAlphaPremultipliedLast);
	
	CGImageRef glowImageRef = CGBitmapContextCreateImage(imageContext);
	
	CGContextRelease(imageContext);
	free(imageData);
	
	// Render the glow layer on top of the source image.
	UIGraphicsBeginImageContextWithOptions([sourceImage size], NO, [sourceImage scale]);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(context, 0.0f, [sourceImage size].height);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, sourceImageSize.width, sourceImageSize.height), [sourceImage CGImage]);
	
	[self applyAppearanceProperties];
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, sourceImageSize.width, sourceImageSize.height), glowImageRef);
	CGImageRelease(glowImageRef);
	
	UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	context = NULL;
	
	free(buffer);
	
	return renderedImage;
}

@end
