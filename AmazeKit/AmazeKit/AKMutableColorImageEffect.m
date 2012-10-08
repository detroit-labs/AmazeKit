//
//  AKMutableColorImageEffect.m
//  AmazeKit
//
//  Created by Jeff Kelley on 8/11/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
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
