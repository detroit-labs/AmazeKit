//
//  AKMaskImageEffect.h
//  AmazeKit
//
//  Created by Jeff Kelley on 8/6/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageEffect.h"


// Constants
extern NSString * const kMaskImageHashKey;


@interface AKMaskImageEffect : AKImageEffect

@property (readonly) UIImage	*maskImage;

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
		  maskImage:(UIImage *)maskImage;

@end
