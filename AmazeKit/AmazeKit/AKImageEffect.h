//
//  AKImageEffect.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/11/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


@interface AKImageEffect : NSObject

// Appearance Properties
@property (assign) CGFloat    	alpha;
@property (assign) CGBlendMode	blendMode;

// In your implementation of -renderImageFromSourceImage:withSize:, you should call this method to
// apply appearance properties. It expects you to have set up a graphics context.
- (void)applyAppearanceProperties;

// Subclasses should override this method.
- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage;

@end
