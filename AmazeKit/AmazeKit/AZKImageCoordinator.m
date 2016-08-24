//
//  AKImageCoordinator.m
//  AmazeKit
//
//  Created by Jeff Kelley on 9/8/12.
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

#import "AZKImageCoordinator.h"

#import "UIView+AZKScaleInfo.h"

#import "AZKImageRenderer.h"

static NSString * const kFrameKeyPath = @"frame";

@interface AZKImageCoordinator()

@property (strong) NSMutableArray<UIImageView *> *imageViews;

- (void)imageRendererDidUpdate:(NSNotification *)aNotification;
- (void)renderIntoImageView:(UIImageView *)imageView;

@end

@implementation AZKImageCoordinator

@synthesize imageRenderer = _imageRenderer;
@synthesize imageViews = _imageViews;

#pragma mark - Object Lifecycle

- (void)dealloc
{
    self.imageRenderer = nil;
	
	for (UIImageView *imageView in self.imageViews) {
		[self removeImageView:imageView];
	}
}

#pragma mark - Image Coordinator Lifecycle

- (void)addImageView:(UIImageView *)imageView
{
	if (self.imageViews == nil) {
		[self setImageViews:[[NSMutableArray alloc] init]];
	}
	
	[self.imageViews addObject:imageView];
	
	[imageView addObserver:self
				forKeyPath:kFrameKeyPath
				   options:(NSKeyValueObservingOptionInitial |
							NSKeyValueObservingOptionNew)
				   context:NULL];
}

- (void)imageRendererDidUpdate:(NSNotification *)aNotification
{
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj,
                                                  NSUInteger idx,
                                                  BOOL * _Nonnull stop) {
        [self renderIntoImageView:obj];
	}];
}

- (void)removeImageView:(UIImageView *)imageView
{
	if ([self.imageViews containsObject:imageView]) {
		[self.imageViews removeObject:imageView];
		
		[imageView removeObserver:self
					   forKeyPath:kFrameKeyPath];
	}
}

- (void)renderIntoImageView:(UIImageView *)imageView
{
    imageView.image = [self.imageRenderer imageWithSize:imageView.frame.size
                                                  scale:imageView.azk_scale
                                                options:nil];
}

- (void)setImageRenderer:(AZKImageRenderer *)imageRenderer
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
