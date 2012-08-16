//
//  AKDrawingUtilities.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/25/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "UIImage+AKPixelData.h"


CGFloat AngleBetweenTwoPoints(CGPoint innerPoint, CGPoint outerPoint);

CGFloat DistanceBetweenTwoPoints(CGPoint point1, CGPoint point2);

// Finds the distance in an image to the nearst empty pixel (where alpha == 0). Returns the angle in
// the <angle> parameter.
CGFloat DistanceToNearestEmptyPixel(AKPixelData *pixelDataBuffer,
									NSUInteger width,
									NSUInteger height,
									NSUInteger x,
									NSUInteger y,
									CGFloat maxRadius,
									CGFloat *angle);

// Multiplies a CGSize by a scale factor;
CGSize AKCGSizeMakeWithScale(CGSize size, CGFloat scale);
