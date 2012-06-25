//
//  UIImage+AKPixelData.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
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
