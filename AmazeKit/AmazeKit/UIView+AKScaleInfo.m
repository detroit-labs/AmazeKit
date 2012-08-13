//
//  UIView+AKScaleInfo.m
//  AmazeKit
//
//  Created by Jeff Kelley on 8/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "UIView+AKScaleInfo.h"


@implementation UIView (AKScaleInfo)

- (CGFloat)AK_scale
{
	return [[[self window] screen] scale];
}

@end
