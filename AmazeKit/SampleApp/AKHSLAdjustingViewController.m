//
//  AKHSLAdjustingViewController.m
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


#import "AKHSLAdjustingViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "AmazeKit.h"


@interface AKHSLAdjustingViewController () {
	NSNumberFormatter *_sliderNumberFormatter;
}

// AmazeKit Components
@property (strong, nonatomic) AKMutableColorImageEffect *colorImageEffect;
@property (strong, nonatomic) AKImageCoordinator *imageCoordinator;

// UI Components
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UILabel *hashLabel;
@property (strong, nonatomic) IBOutlet UILabel *hueLabel;
@property (strong, nonatomic) IBOutlet UISlider *hueSlider;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *luminanceLabel;
@property (strong, nonatomic) IBOutlet UISlider *luminanceSlider;
@property (strong, nonatomic) IBOutlet UILabel *saturationLabel;
@property (strong, nonatomic) IBOutlet UISlider *saturationSlider;

- (void)adjustColorEffect;

// IBActions
- (IBAction)sliderValueChanged:(id)sender;

@end


@implementation AKHSLAdjustingViewController

#pragma mark - View Controller Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self) {
		[self setTitle:@"HSL Example"];
		
		_sliderNumberFormatter = [[NSNumberFormatter alloc] init];
		
		[_sliderNumberFormatter setMaximumFractionDigits:3];
		[_sliderNumberFormatter setMinimumFractionDigits:1];
	}
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self sliderValueChanged:nil];
	[[self imageCoordinator] addImageView:[self imageView]];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[[self imageCoordinator] removeImageView:[self imageView]];
}

- (void)viewDidUnload
{
	[self setButton:nil];
	[self setHashLabel:nil];
	[self setHueLabel:nil];
	[self setHueSlider:nil];
	[self setImageView:nil];
	[self setLuminanceLabel:nil];
	[self setLuminanceSlider:nil];
	[self setSaturationLabel:nil];
	[self setSaturationSlider:nil];
	
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation = UIInterfaceOrientationPortrait);
}

#pragma mark - HSL Adjusting View Controller Lifecycle

- (void)adjustColorEffect
{
    UIColor *newColor = [UIColor colorWithHue:[[self hueSlider] value]
                                   saturation:[[self saturationSlider] value]
                                   brightness:[[self luminanceSlider] value]
                                        alpha:1.0f];
    
    [[self colorImageEffect] setColor:newColor];
	
	[[self hashLabel] setText:[[[self imageCoordinator] imageRenderer] representativeHash]];
}

- (AKMutableColorImageEffect *)colorImageEffect
{
    if (_colorImageEffect == nil) {
        _colorImageEffect =
        [[AKMutableColorImageEffect alloc] initWithAlpha:1.0f
                                               blendMode:kCGBlendModeColor];
    }
    
    return _colorImageEffect;
}

- (AKImageCoordinator *)imageCoordinator
{
	if (_imageCoordinator == nil) {
        // Noise Effect
        AKNoiseImageEffect *noiseEffect =
        [[AKNoiseImageEffect alloc] initWithAlpha:0.05f
                                        blendMode:kCGBlendModeMultiply
                                        noiseType:AKNoiseTypeBlackAndWhite];
        
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
		
		// Rounded Corners
        AKCornerRadii cornerRadii = AKCornerRadiiMake(40.0f,
                                                      10.0f,
                                                      5.0f,
                                                      80.0f);
        
		AKImageEffect *roundedCornerEffect =
		[[AKCornerRadiusImageEffect alloc] initWithAlpha:1.0f
											   blendMode:kCGBlendModeNormal
											 cornerRadii:cornerRadii];
		
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
		 [self colorImageEffect],
		 roundedCornerEffect,
		 innerGlowEffect
		 ]];
		
		_imageCoordinator = [[AKImageCoordinator alloc] init];
		[_imageCoordinator setImageRenderer:imageRenderer];
	}
    
    return _imageCoordinator;
}

#pragma mark - IBActions

- (IBAction)sliderValueChanged:(id)sender
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self adjustColorEffect];
		
		[[self hueLabel] setText:
		 [_sliderNumberFormatter stringFromNumber:@([[self hueSlider] value])]];
		
		[[self luminanceLabel] setText:
		 [_sliderNumberFormatter stringFromNumber:@([[self luminanceSlider] value])]];
		
		[[self saturationLabel] setText:
		 [_sliderNumberFormatter stringFromNumber:@([[self saturationSlider] value])]];
    }];
}

#pragma mark -

@end
