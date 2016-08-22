//
//  AKButtonImageCoordinator.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/19/12.
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


#import "AKButtonImageCoordinator.h"

#import "UIView+AZKScaleInfo.h"

#import "AKImageRenderer.h"


static NSString * const kFrameKeyPath = @"frame";


@interface AKButtonImageCoordinator ()

@property (strong) NSMutableArray 	*buttons;

- (void)imageRendererDidUpdate:(NSNotification *)aNotification;
- (void)renderIntoButton:(UIButton *)button;

@end

@implementation AKButtonImageCoordinator

@synthesize buttons = _buttons;
@synthesize offImageRenderer = _offImageRenderer;
@synthesize onImageRenderer = _onImageRenderer;

#pragma mark - Object Lifecycle

- (void)dealloc
{
	for (UIButton *button in [self buttons]) {
		[self removeButton:button];
	}
}

#pragma mark - Button Image Coordinator Lifecycle

- (void)addButton:(UIButton *)button
{
	if ([self buttons] == nil) {
		[self setButtons:[[NSMutableArray alloc] init]];
	}
	
	[[self buttons] addObject:button];
	
	[button addObserver:self
			 forKeyPath:kFrameKeyPath
				options:(NSKeyValueObservingOptionInitial |
						 NSKeyValueObservingOptionNew)
				context:NULL];
}

- (void)imageRendererDidUpdate:(NSNotification *)aNotification
{
	[[self buttons] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([obj isKindOfClass:[UIButton class]]) {
			[self renderIntoButton:obj];
		}
	}];
}

- (void)removeButton:(UIButton *)button
{
	if ([[self buttons] containsObject:button]) {
		[[self buttons] removeObject:button];
		
		[button removeObserver:self
					forKeyPath:kFrameKeyPath];
	}
}

- (void)renderIntoButton:(UIButton *)button
{
	CGSize size = [button frame].size;
	CGFloat scale = button.azk_scale;
	
	[button setBackgroundImage:[[self offImageRenderer] imageWithSize:size
																scale:scale
															  options:nil]
					  forState:UIControlStateNormal];
	
	[button setBackgroundImage:[[self onImageRenderer] imageWithSize:size
															   scale:scale
															 options:nil]
					  forState:UIControlStateHighlighted];
}

- (void)setOffImageRenderer:(AKImageRenderer *)offImageRenderer
{
	if (_offImageRenderer != nil) {
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:AKImageRendererEffectDidChangeNotification
													  object:_offImageRenderer];
	}
	
	_offImageRenderer = offImageRenderer;
	
	if (_offImageRenderer != nil) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(imageRendererDidUpdate:)
													 name:AKImageRendererEffectDidChangeNotification
												   object:_offImageRenderer];
	}
}

- (void)setOnImageRenderer:(AKImageRenderer *)onImageRenderer
{
	if (_onImageRenderer != nil) {
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:AKImageRendererEffectDidChangeNotification
													  object:_onImageRenderer];
	}
	
	_onImageRenderer = onImageRenderer;
	
	if (_onImageRenderer != nil) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(imageRendererDidUpdate:)
													 name:AKImageRendererEffectDidChangeNotification
												   object:_onImageRenderer];
	}
}

#pragma mark - Key-Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	if ([object isKindOfClass:[UIButton class]]) {
		UIButton *button = (UIButton *)object;
		[self renderIntoButton:button];
	}
}

#pragma mark -

@end
