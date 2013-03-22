//
//  AKButtonExampleViewController.m
//  AmazeKit
//
//  Created by Jeff Kelley on 3/22/13.
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


#import "AKButtonExampleViewController.h"

#import "AmazeKit.h"


@interface AKButtonExampleViewController ()

// AmazeKit Components
@property (strong, nonatomic) AKButtonImageCoordinator *buttonImageCoordinator;

// UI Components
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@end


@implementation AKButtonExampleViewController

#pragma mark - View Controller Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil
			   bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) {
        [self setTitle:@"Button Example"];
    }
	
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	for (UIButton *button in [self buttons]) {
		[[self buttonImageCoordinator] addButton:button];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	for (UIButton *button in [self buttons]) {
		[[self buttonImageCoordinator] removeButton:button];
	}
}

- (void)viewDidUnload
{
	[self setButtons:nil];
	
	[super viewDidUnload];
}

#pragma mark - Button Example View Controller Lifecycle

- (AKButtonImageCoordinator *)buttonImageCoordinator
{
	if (_buttonImageCoordinator == nil) {
		// Some image effects are common between the two button states. We can
		// re-use them, so let’s define them here.
		AKCornerRadii cornerRadii = AKCornerRadiiMake(4.0f, 4.0f, 4.0f, 4.0f);
		AKCornerRadiusImageEffect *cornerRadiusEffect =
		[[AKCornerRadiusImageEffect alloc] initWithAlpha:1.0f
											   blendMode:kCGBlendModeNormal
											 cornerRadii:cornerRadii];
		
		
		// First, we create the default state image renderer
		UIColor *topColor = [UIColor colorWithRed:0.0f
											green:0.5f
											 blue:1.0f
											alpha:1.0f];
		
		UIColor *bottomColor = [UIColor colorWithRed:0.0f
											   green:0.4f
												blue:0.9f
											   alpha:1.0f];
		
		AKGradientImageEffect *gradientEffect =
		[[AKGradientImageEffect alloc] initWithAlpha:1.0f
										   blendMode:kCGBlendModeNormal
											  colors:@[topColor, bottomColor]
										   direction:AKGradientDirectionVertical
										   locations:nil];
		
		AKImageRenderer *normalImageRenderer = [[AKImageRenderer alloc] init];
		[normalImageRenderer setImageEffects:@[
		 gradientEffect,
		 cornerRadiusEffect
		 ]];
		
		
		// Next, we create the highlighted state image renderer’s image effects
		AKGradientImageEffect *oppositeGradientImageEffect =
		[[AKGradientImageEffect alloc] initWithAlpha:1.0f
										   blendMode:kCGBlendModeNormal
											  colors:@[bottomColor, topColor]
										   direction:AKGradientDirectionVertical
										   locations:nil];
		
		AKImageRenderer *highlightedImageRenderer =
		[[AKImageRenderer alloc] init];
		
		AKInnerShadowImageEffect *innerShadowEffect =
		[[AKInnerShadowImageEffect alloc] initWithAlpha:0.75f
											  blendMode:kCGBlendModeMultiply
												  color:[UIColor blackColor]
												 radius:5.0f
												 offset:CGSizeZero];

		AKInnerShadowImageEffect *innerShadowHighlightEffect =
		[[AKInnerShadowImageEffect alloc] initWithAlpha:1.0f
											  blendMode:kCGBlendModeLighten
												  color:[UIColor whiteColor]
												 radius:5.0f
												 offset:CGSizeMake(-1.0f, -1.0f)];
		
		[highlightedImageRenderer setImageEffects:@[
		 oppositeGradientImageEffect,
		 cornerRadiusEffect,
		 innerShadowHighlightEffect,
		 innerShadowEffect
		 ]];
		
		
		// Now that we’ve created both image renderers, we can create our
		// button image coordinator
		_buttonImageCoordinator = [[AKButtonImageCoordinator alloc] init];
		[_buttonImageCoordinator setOffImageRenderer:normalImageRenderer];
		[_buttonImageCoordinator setOnImageRenderer:highlightedImageRenderer];
	}
	
	return _buttonImageCoordinator;
}

#pragma mark -

@end
