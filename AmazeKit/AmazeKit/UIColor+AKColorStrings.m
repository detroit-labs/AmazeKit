//
//  UIColor+AKColorStrings.m
//  AmazeKit
//
//  Created by Jeff Kelley on 7/31/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "UIColor+AKColorStrings.h"


@implementation UIColor (AKColorStrings)

+ (UIColor *)AK_colorWithHexString:(NSString *)hexString
{
	NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
	if([cleanString length] == 3) {
		cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
					   [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
					   [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
					   [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
	}
	if([cleanString length] == 6) {
		cleanString = [cleanString stringByAppendingString:@"ff"];
	}
	
	unsigned int baseValue;
	[[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
	
	float red = ((baseValue >> 24) & 0xFF)/255.0f;
	float green = ((baseValue >> 16) & 0xFF)/255.0f;
	float blue = ((baseValue >> 8) & 0xFF)/255.0f;
	float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
	
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSString *)AK_hexString
{
	CGColorRef cgColor = [self CGColor];
	size_t numberOfComponents = CGColorGetNumberOfComponents(cgColor);
	const CGFloat *components = CGColorGetComponents(cgColor);
	
	NSString *hexString = nil;
	
	if (numberOfComponents == 2)
	{
		uint8_t white = (uint8_t)(components[0] * 255.0f);
		hexString = [NSString stringWithFormat:@"%02x%02x%02x", white, white, white];
	}
	else if (numberOfComponents == 4)
	{
		uint8_t red = (uint8_t)(components[0] * 255.0f);
		uint8_t green = (uint8_t)(components[1] * 255.0f);
		uint8_t blue = (uint8_t)(components[2] * 255.0f);
		uint8_t alpha = (uint8_t)(components[3] * 255.0f);
		
		
		hexString = [NSString stringWithFormat:@"%02x%02x%02x%02x", red, green, blue, alpha];
	}
	
	return hexString;
}

@end
