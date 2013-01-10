//
//  AKMutableColorImageEffect.m
//  AmazeKit
//
//  Created by Jeff Kelley on 8/11/12.
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


#import "AKMutableColorImageEffect.h"


@interface AKMutableColorImageEffect ()

- (void)registerObservers;
- (void)unregisterObservers;

@end


@implementation AKMutableColorImageEffect

@synthesize color = _color;

#pragma mark - Object Lifecycle

- (void)dealloc
{
	[self unregisterObservers];
}

#pragma mark - Image Effect Lifecycle

+ (BOOL)isImmutable
{
	return NO;
}

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
{
	self = [super initWithAlpha:alpha
					  blendMode:blendMode];
	
	if (self) {
		_color = [UIColor blackColor];
		
		[self registerObservers];
	}
	
	return self;
}

#pragma mark - Color Image Effect Lifecycle

- (id)initWithAlpha:(CGFloat)alpha
		  blendMode:(CGBlendMode)blendMode
			  color:(UIColor *)color
{
	self = [super initWithAlpha:alpha
					  blendMode:blendMode];
	
	if (self) {
		_color = color;
		
		[self registerObservers];
	}
	
	return self;
}

#pragma mark - Mutable Color Image Effect Lifecycle

- (void)registerObservers
{
	[self addObserver:self
		   forKeyPath:AKColorImageEffectColorKeyPath
			  options:(NSKeyValueObservingOptionInitial |
					   NSKeyValueObservingOptionNew)
			  context:NULL];
}

- (void)unregisterObservers
{
	[self removeObserver:self
			  forKeyPath:AKColorImageEffectColorKeyPath];
}

#pragma mark - Key-Value Observation

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	if (object == self) {
		if ([keyPath isEqualToString:AKColorImageEffectColorKeyPath]) {
			[self setDirty:YES];
		}
	}
}

#pragma mark -

@end
