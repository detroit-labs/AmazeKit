//
//  AKDrawingUtilities.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/25/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//

#import "UIImage+AKPixelData.h"

CGFloat AngleBetweenTwoPoints(CGPoint innerPoint, CGPoint outerPoint)
{
	return atan2f((CGFloat)(outerPoint.x - innerPoint.x), (CGFloat)(innerPoint.y - outerPoint.y));
}

CGFloat DistanceBetweenTwoPoints(CGPoint point1, CGPoint point2)
{
	CGFloat dx = point2.x - point1.x;
	CGFloat dy = point2.y - point1.y;
	
	return sqrtf((dx * dx) + (dy * dy));
}

CGFloat DistanceToNearestEmptyPixel(uint8_t *rawRGBA8888Data,
									NSUInteger width,
									NSUInteger height,
									NSUInteger x,
									NSUInteger y,
									CGFloat maxRadius,
									CGFloat *angle)
{
	CGFloat distance = maxRadius;
	CGFloat _angle = 0.0f;
	NSUInteger offset = 1;
	
	while (distance == maxRadius && offset <= maxRadius) {
		for (NSInteger searchY = y - offset; searchY < (NSInteger)(y + offset); searchY++) {
			for (NSInteger searchX = x - offset; searchX < (NSInteger)(x + offset); searchX++) {
				AKPixelData pixelData = AKPixelDataZero;
				
				if (searchX >= 0 && searchY >= 0 && searchX < width && searchY < height) {
					pixelData = AKGetPixelDataFromRGBA8888Data(rawRGBA8888Data, width, height, searchX, searchY);
				}
				
				if (searchX != x &&
					searchY != y &&
					(searchX < 0 ||
					 searchY < 0 ||
					 searchX >= width ||
					 searchY >= height ||
					 pixelData.alpha == 0)) {
					CGFloat searchDistance = DistanceBetweenTwoPoints(CGPointMake(x, y),
																	  CGPointMake(searchX, searchY));
					
					if (searchDistance < distance) {
						distance = searchDistance;
						
						CGPoint innerPoint = CGPointMake(x, y);
						CGPoint outerPoint = CGPointMake(searchX, searchY);
						
						_angle = AngleBetweenTwoPoints(innerPoint, outerPoint);
					}
				}
			}
		}
		
		offset += 1;
	}

	if (angle != NULL) {
		*angle = _angle;
	}

	return distance;
}

CGSize AKCGSizeMakeWithScale(CGSize size, CGFloat scale)
{
	return CGSizeMake(size.width * scale,
					  size.height * scale);
}
