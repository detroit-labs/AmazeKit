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
	CGFloat red;
	CGFloat blue;
	CGFloat green;
	CGFloat alpha;
} AKPixelData;


AKPixelData AKGetPixelDataFromRGBA8888Data(uint8_t *rawData, NSUInteger width, NSUInteger height,
										   NSUInteger x, NSUInteger y);


@interface UIImage (AKPixelData)

- (NSData *)AK_rawRGBA8888Data;

@end
