//
//  AKButtonImageCoordinator.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/19/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKButtonImageCoordinator.h"

#import "AKImageRenderer.h"


static NSString * const kFrameKeyPath = @"frame";


@interface AKButtonImageCoordinator()

@property (strong) NSMutableArray	*buttons;

@end


@implementation AKButtonImageCoordinator

@synthesize buttons = _buttons;
@synthesize offImageRenderer = _offImageRenderer;
@synthesize onImageRenderer = _onImageRenderer;

#pragma mark -

- (void)addButton:(UIButton *)button
{
	[[self buttons] addObject:button];
	
	[button addObserver:self
			 forKeyPath:kFrameKeyPath
				options:(NSKeyValueObservingOptionInitial |
						 NSKeyValueObservingOptionNew)
				context:NULL];
}

- (void)removeButton:(UIButton *)button
{
	[[self buttons] removeObject:button];
	
	[button removeObserver:self
				forKeyPath:kFrameKeyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	if ([object isKindOfClass:[UIButton class]]) {
		UIButton *button = (UIButton *)object;
		
		NSValue *frameValue = [change objectForKey:NSKeyValueChangeNewKey];
		
		if ([frameValue isKindOfClass:[NSValue class]]) {
			CGRect frame = [frameValue CGRectValue];
			
			[button setImage:[[self offImageRenderer] imageWithSize:frame.size
															options:nil]
					forState:UIControlStateNormal];

			[button setImage:[[self onImageRenderer] imageWithSize:frame.size
															options:nil]
					forState:UIControlStateHighlighted];		
		}
	}
}

#pragma mark -

@end