//
//  AKDrawingUtilities.h
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
