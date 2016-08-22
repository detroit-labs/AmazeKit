//
//  AKDrawingUtilities.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/25/12.
//  Copyright (c) 2013 Detroit Labs. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "AKDrawingUtilities.h"

#import "UIImage+AZKPixelData.h"

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

CGFloat DistanceToNearestEmptyPixel(AZKPixelData *pixelDataBuffer,
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
	
	while (distance <= maxRadius && offset <= maxRadius) {
		for (NSInteger searchX = x - offset; searchX < (NSInteger)(x + offset); searchX++) {
			for (NSInteger searchY = y - offset; searchY < (NSInteger)(y + offset); searchY++) {
				AZKPixelData pixelData = AZKPixelDataZero;
				
				if (searchX >= 0 && searchY >= 0 && (NSUInteger)searchX < width && (NSUInteger)searchY < height) {
					pixelData = pixelDataBuffer[(y * width) + x];
				}
				
				if ((NSUInteger)searchX != x &&
					(NSUInteger)searchY != y &&
					(searchX < 0 ||
					 searchY < 0 ||
					 (NSUInteger)searchX >= width ||
					 (NSUInteger)searchY >= height ||
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
