//
//  AKImageCoordinator.m
//  AmazeKit
//
//  Created by Jeff Kelley on 9/8/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageCoordinator.h"

#import "UIView+AKScaleInfo.h"

#import "AKImageRenderer.h"


static NSString * const kFrameKeyPath = @"frame";


@implementation AKImageCoordinator {
	NSMutableArray	*_imageViews;
}

@synthesize imageRenderer = _imageRenderer;

#pragma mark - Object Lifecycle

- (void)dealloc
{
	for (UIImageView *imageView in _imageViews) {
		[self removeImageView:imageView];
	}
}

#pragma mark - Image Coordinator Lifecycle

- (void)addImageView:(UIImageView *)imageView
{
	if (_imageViews == nil) {
		_imageViews = [[NSMutableArray alloc] init];
	}
	
	[_imageViews addObject:imageView];
	
	[imageView addObserver:self
				forKeyPath:kFrameKeyPath
				   options:(NSKeyValueObservingOptionInitial |
							NSKeyValueObservingOptionNew)
				   context:NULL];
}

- (void)removeImageView:(UIImageView *)imageView
{
	if ([_imageViews containsObject:imageView]) {
		[_imageViews removeObject:imageView];
		
		[imageView removeObserver:self
					   forKeyPath:kFrameKeyPath];
	}
}

#pragma mark - Key-Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	if ([object isKindOfClass:[UIImageView class]]) {
		UIImageView *button = (UIImageView *)object;
		
		NSValue *frameValue = [change objectForKey:NSKeyValueChangeNewKey];
		
		if ([frameValue isKindOfClass:[NSValue class]]) {
			CGRect frame = [frameValue CGRectValue];
			CGFloat scale = [button AK_scale];
			
			[button setImage:[[self imageRenderer] imageWithSize:frame.size
														   scale:scale
														 options:nil]];
		}
	}
}

#pragma mark -

@end
