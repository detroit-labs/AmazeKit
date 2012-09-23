//
//  AKImageCoordinator.h
//  AmazeKit
//
//  Created by Jeff Kelley on 9/8/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import <UIKit/UIKit.h>


@class AKImageRenderer;

@interface AKImageCoordinator : NSObject

@property (strong) AKImageRenderer	*imageRenderer;

- (void)addImageView:(UIImageView *)imageView;
- (void)removeImageView:(UIImageView *)imageView;

@end
