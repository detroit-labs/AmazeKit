//
//  AKBevelImageEffect.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKBevelImageEffect.h"

#import "UIImage+AKPixelData.h"


@implementation AKBevelImageEffect

@synthesize color = _color;
@synthesize radius = _radius;

- (id)init
{
	self = [super init];
	
	if (self) {
		_radius = 1.0f;
	}
	
	return self;
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	// Get the pixel data of the source image.
	NSData *pixelData = [sourceImage AK_rawRGBA8888Data];
	
	uint8_t *rawData = [pixelData bytes];
	
	NSUInteger width = [sourceImage size].width;
	NSUInteger height = [sourceImage size].height;
	
	uint8_t *foo;
	
	// Create a data buffer to write data into.
	
	// For every pixel, if it’s transparent and the pixel below it is not, add to the overlay
	// buffer below according to the radius.
	for (NSUInteger x = 0; x < width; x++) {
		for (NSUInteger y = 0; y < height - 1; y++) {
			// Is the current pixel “lit”?
			AKPixelData pixelData = AKGetPixelDataFromRGBA8888Data(rawData, width, height, x, y);
			
			if (pixelData.alpha == 0.0f) {
				AKPixelData pixelDataUnderneath = AKGetPixelDataFromRGBA8888Data(rawData, width, height, x, y + 1);
				
				if (pixelDataUnderneath.alpha >= 0.01f) {
					
				}
				
				NSUInteger yToInspect = y - 1;
				
				while (yToInspect >= 0) {
//					distanceToUnlit++;
				}
			}
		}
	}
}

@end
