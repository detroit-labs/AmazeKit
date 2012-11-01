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


@interface AKImageCoordinator()

@property (strong) NSMutableArray 	*imageViews;

- (void)imageRendererDidUpdate:(NSNotification *)aNotification;
- (void)renderIntoImageView:(UIImageView *)imageView;

@end


@implementation AKImageCoordinator

@synthesize imageRenderer = _imageRenderer;
@synthesize imageViews = _imageViews;

#pragma mark - Object Lifecycle

- (void)dealloc
{
	[self setImageRenderer:nil];
	
	for (UIImageView *imageView in [self imageViews]) {
		[self removeImageView:imageView];
	}
}

#pragma mark - Image Coordinator Lifecycle

- (void)addImageView:(UIImageView *)imageView
{
	if ([self imageViews] == nil) {
		[self setImageViews:[[NSMutableArray alloc] init]];
	}
	
	[[self imageViews] addObject:imageView];
	
	[imageView addObserver:self
				forKeyPath:kFrameKeyPath
				   options:(NSKeyValueObservingOptionInitial |
							NSKeyValueObservingOptionNew)
				   context:NULL];
}

- (void)imageRendererDidUpdate:(NSNotification *)aNotification
{
	[[self imageViews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([obj isKindOfClass:[UIImageView class]]) {
			[self renderIntoImageView:obj];
		}
	}];
}

- (void)removeImageView:(UIImageView *)imageView
{
	if ([[self imageViews] containsObject:imageView]) {
		[[self imageViews] removeObject:imageView];
		
		[imageView removeObserver:self
					   forKeyPath:kFrameKeyPath];
	}
}

- (void)renderIntoImageView:(UIImageView *)imageView
{
	[imageView setImage:[[self imageRenderer] imageWithSize:[imageView frame].size
													  scale:[imageView AK_scale]
													options:nil]];
}

- (void)setImageRenderer:(AKImageRenderer *)imageRenderer
{
	if (_imageRenderer != nil) {
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:AKImageRendererEffectDidChangeNotification
													  object:_imageRenderer];
	}
	
	_imageRenderer = imageRenderer;
	
	if (_imageRenderer != nil) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(imageRendererDidUpdate:)
													 name:AKImageRendererEffectDidChangeNotification
												   object:_imageRenderer];
	}
}


#pragma mark - Key-Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	if ([object isKindOfClass:[UIImageView class]]) {
		UIImageView *imageView = (UIImageView *)object;
		[self renderIntoImageView:imageView];
	}
}

#pragma mark -

@end
