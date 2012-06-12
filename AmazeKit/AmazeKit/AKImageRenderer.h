//
//  AKImageRenderer.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/11/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


@interface AKImageRenderer : NSObject

// An array of AKImageEffect objects, applied in order.
@property (strong) NSArray	*imageEffects;

- (UIImage *)imageWithSize:(CGSize)size
				   options:(NSDictionary *)options;

@end
