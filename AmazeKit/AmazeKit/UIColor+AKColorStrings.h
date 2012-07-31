//
//  UIColor+AKColorStrings.h
//  AmazeKit
//
//  Created by Jeff Kelley on 7/31/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIColor (AKColorStrings)

+ (UIColor *)AK_colorWithHexString:(NSString *)hexString;
- (NSString *)AK_hexString;

@end
