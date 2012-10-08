//
//  AKButtonImageCoordinator.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/19/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import <UIKit/UIKit.h>


@class AKImageRenderer;

@interface AKButtonImageCoordinator : NSObject

// An image renderer for the “on” state
@property (strong, nonatomic) AKImageRenderer	*onImageRenderer;

// An image renderer for the “off” state
@property (strong, nonatomic) AKImageRenderer	*offImageRenderer;

- (void)addButton:(UIButton *)button;
- (void)removeButton:(UIButton *)button;

@end
