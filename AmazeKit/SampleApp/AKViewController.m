//
//  AKViewController.m
//  SmapleApp
//
//  Created by Jeffrey Kelley on 6/12/12.
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


#import "AKViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "UIView+AKScaleInfo.h"

#import "AmazeKit.h"

#import "AKDrawingUtilities.h"


@interface AKViewController () {
	AKButtonImageCoordinator	*buttonImageCoordinator;
	AKMutableColorImageEffect	*colorImageEffect;
	AKImageCoordinator       	*imageCoordinator;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UISlider *hueSlider;
@property (strong, nonatomic) IBOutlet UISlider *saturationSlider;
@property (strong, nonatomic) IBOutlet UISlider *brightnessSlider;

- (IBAction)sliderChanged:(id)sender;

@end


@implementation AKViewController

@synthesize imageView;
@synthesize button;
@synthesize hueSlider;
@synthesize saturationSlider;
@synthesize brightnessSlider;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Noise Effect
	AKNoiseImageEffect *noiseEffect = [[AKNoiseImageEffect alloc] initWithAlpha:0.05f
																	  blendMode:kCGBlendModeNormal
																	  noiseType:AKNoiseTypeBlackAndWhite];
	
	// Bevel Effect
	AKButtonBevelImageEffect *bevelEffect = [[AKButtonBevelImageEffect alloc] init];
	
	if (buttonImageCoordinator == nil) {
		buttonImageCoordinator = [[AKButtonImageCoordinator alloc] init];
		
		AKImageRenderer *onButtonRenderer = [[AKImageRenderer alloc] init];
				
		// Gradient Effect
		UIColor *onBeginColor = [UIColor colorWithRed:103.0f / 255.0f
												green:103.0f / 255.0f
												 blue:103.0f / 255.0f
												alpha:1.0f];
		
		UIColor *onEndColor = [UIColor colorWithRed:103.0f / 255.0f
											  green:103.0f / 255.0f
											   blue:103.0f / 255.0f
											  alpha:1.0f];
		
		AKGradientImageEffect *onGradientEffect = [[AKGradientImageEffect alloc] initWithAlpha:1.0f
																					 blendMode:kCGBlendModeMultiply
																						colors:@[onBeginColor, onEndColor]
																					 direction:AKGradientDirectionVertical
																					 locations:nil];
		
		// Color Effect
		AKColorImageEffect *onColorEffect = [[AKColorImageEffect alloc] initWithAlpha:1.0f
																			blendMode:kCGBlendModeColor
																				color:[UIColor blueColor]];
		
		// Corner Radius Effect
		AKCornerRadiusImageEffect *buttonCornerRadiusEffect = [[AKCornerRadiusImageEffect alloc] initWithAlpha:1.0f
																									 blendMode:kCGBlendModeNormal
																								   cornerRadii:AKCornerRadiiMake(20.0f, 20.0f, 20.0f, 20.0f)];
		
		// Glow Effect
		AKInnerGlowImageEffect *innerGlowEffect = [[AKInnerGlowImageEffect alloc] initWithAlpha:0.5f
																					  blendMode:kCGBlendModeOverlay
																						  color:[UIColor colorWithRed:0.0f
																												green:0.0f
																												 blue:0.0f
																												alpha:1.0f]
																						 radius:5.0f];
		
		[onButtonRenderer setImageEffects:@[noiseEffect,
										   onGradientEffect,
										   onColorEffect,
										   buttonCornerRadiusEffect,
										   bevelEffect,
										   innerGlowEffect]];
		
		AKImageRenderer *offButtonRenderer = [[AKImageRenderer alloc] init];
		
		// Gradient Effect
		UIColor *offBeginColor = [UIColor colorWithRed:144.0f / 255.0f
												 green:144.0f / 255.0f
												  blue:144.0f / 255.0f
												 alpha:1.0f];
		
		UIColor *offEndColor = [UIColor colorWithRed:103.0f / 255.0f
											   green:103.0f / 255.0f
												blue:103.0f / 255.0f
											   alpha:1.0f];
		
		AKGradientImageEffect *offGradientEffect = [[AKGradientImageEffect alloc] initWithAlpha:1.0f
																					  blendMode:kCGBlendModeMultiply
																						 colors:@[offBeginColor, offEndColor]
																					  direction:AKGradientDirectionVertical
																					  locations:nil];
		
		// Color Effect
		AKColorImageEffect *offColorEffect = [[AKColorImageEffect alloc] initWithAlpha:1.0f
																			 blendMode:kCGBlendModeColor
																				 color:[UIColor redColor]];
		
		[offButtonRenderer setImageEffects:@[noiseEffect,
											offGradientEffect,
											offColorEffect,
											buttonCornerRadiusEffect,
											bevelEffect]];
		
		[buttonImageCoordinator setOnImageRenderer:onButtonRenderer];
		[buttonImageCoordinator setOffImageRenderer:offButtonRenderer];
	}
	
	if (imageCoordinator == nil) {
		// Gradient Effect
		UIColor *beginColor = [UIColor colorWithRed:144.0f / 255.0f
											  green:144.0f / 255.0f
											   blue:144.0f / 255.0f
											  alpha:1.0f];
		
		UIColor *endColor = [UIColor colorWithRed:103.0f / 255.0f
											green:103.0f / 255.0f
											 blue:103.0f / 255.0f
											alpha:1.0f];
		
		AKGradientImageEffect *gradientEffect =
		[[AKGradientImageEffect alloc] initWithAlpha:1.0f
										   blendMode:kCGBlendModeMultiply
											  colors:@[beginColor, endColor]
										   direction:AKGradientDirectionVertical
										   locations:nil];
		
		// Color Effect
		colorImageEffect = [[AKMutableColorImageEffect alloc] initWithAlpha:1.0f
																  blendMode:kCGBlendModeColor];
		
		// Rounded Corners
		AKImageEffect *roundedCornerEffect =
		[[AKCornerRadiusImageEffect alloc] initWithAlpha:1.0f
											   blendMode:kCGBlendModeNormal
											 cornerRadii:AKCornerRadiiMake(40.0f,
																		   10.0f,
																		   5.0f,
																		   80.0f)];
		
		// Inner Glow
		AKInnerGlowImageEffect *innerGlowEffect =
		[[AKInnerGlowImageEffect alloc] initWithAlpha:0.25f
											blendMode:kCGBlendModeMultiply
												color:[UIColor blackColor]
											   radius:10.0f];
		
		AKImageRenderer *imageRenderer = [[AKImageRenderer alloc] init];
		
		[imageRenderer setImageEffects:@[
		 noiseEffect,
		 gradientEffect,
		 colorImageEffect,
		 roundedCornerEffect,
		 innerGlowEffect,
		 bevelEffect
		 ]];
		
		imageCoordinator = [[AKImageCoordinator alloc] init];
		[imageCoordinator setImageRenderer:imageRenderer];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[buttonImageCoordinator addButton:[self button]];
	[imageCoordinator addImageView:[self imageView]];
	
	[self sliderChanged:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[buttonImageCoordinator removeButton:[self button]];
	[imageCoordinator removeImageView:[self imageView]];
}

- (void)viewDidUnload
{
	[self setBrightnessSlider:nil];
	[self setButton:nil];
	[self setImageView:nil];
	[self setHueSlider:nil];
	[self setSaturationSlider:nil];
	
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation = UIInterfaceOrientationPortrait);
}

- (IBAction)sliderChanged:(id)sender
{
	[colorImageEffect setColor:[UIColor colorWithHue:[[self hueSlider] value]
										  saturation:[[self saturationSlider] value]
										  brightness:[[self brightnessSlider] value]
											   alpha:1.0f]];
}

@end
