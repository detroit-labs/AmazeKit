//
//  UIImage+AKMasking.h
//  AmazeKit
//
//  Created by Jeff Kelley on 8/29/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIImage (AKMasking)

// Creates an image with inverted alpha values suitable for use as a mask.
- (UIImage *)AK_reverseMaskImage;

@end
