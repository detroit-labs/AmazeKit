//
//  AKViewController.m
//  SmapleApp
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "AmazeKit.h"


@interface AKViewController () {
	AKImageRenderer          	*buttonRenderer;
	AKNoiseImageEffect       	*noiseEffect;
	AKGradientImageEffect    	*gradientEffect;
	AKColorImageEffect       	*colorEffect;
	AKCornerRadiusImageEffect	*cornerRadiusEffect;
	AKButtonBevelImageEffect 	*bevelEffect;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UISlider *hueSlider;
@property (strong, nonatomic) IBOutlet UISlider *saturationSlider;
@property (strong, nonatomic) IBOutlet UISlider *brightnessSlider;

- (IBAction)sliderChanged:(id)sender;

@end


@implementation AKViewController

@synthesize imageView;
@synthesize hueSlider;
@synthesize saturationSlider;
@synthesize brightnessSlider;

- (void)renderButton
{
	if (buttonRenderer == nil) {
		buttonRenderer = [[AKImageRenderer alloc] init];
		
		// Noise Effect
		noiseEffect = [[AKNoiseImageEffect alloc] init];
		[noiseEffect setAlpha:0.05f];
		[noiseEffect setNoiseType:AKNoiseTypeBlackAndWhite];
		
		// Gradient Effect
		gradientEffect = [[AKGradientImageEffect alloc] init];
		[gradientEffect setBlendMode:kCGBlendModeMultiply];
		
		UIColor *beginColor = [UIColor colorWithRed:144.0f / 255.0f
											  green:144.0f / 255.0f
											   blue:144.0f / 255.0f
											  alpha:1.0f];
		
		UIColor *endColor = [UIColor colorWithRed:103.0f / 255.0f
											green:103.0f / 255.0f
											 blue:103.0f / 255.0f
											alpha:1.0f];
		
		[gradientEffect setColors:[NSArray arrayWithObjects:beginColor, endColor, nil]];
		
		// Color Effect
		colorEffect = [[AKColorImageEffect alloc] init];
		[colorEffect setBlendMode:kCGBlendModeColor];
		
		// Corner Radius Effect
		cornerRadiusEffect = [[AKCornerRadiusImageEffect alloc] init];
		[cornerRadiusEffect setCornerRadii:AKCornerRadiiMake(20.0f, 20.0f, 20.0f, 20.0f)];
		
		// Bevel Effect
		bevelEffect = [[AKButtonBevelImageEffect alloc] init];
		
		[buttonRenderer setImageEffects:[NSArray arrayWithObjects:
										 noiseEffect,
										 gradientEffect,
										 colorEffect,
										 cornerRadiusEffect,
										 bevelEffect,
										 nil]];
	}
	
	[colorEffect setColor:[UIColor colorWithHue:[[self hueSlider] value]
									 saturation:[[self saturationSlider] value]
									 brightness:[[self brightnessSlider] value]
										  alpha:1.0f]];

	UIImage *image = [buttonRenderer imageWithSize:[imageView frame].size
										   options:nil];
	
	[[self imageView] setImage:image];	
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self renderButton];
}

- (void)viewDidUnload
{
	[self setImageView:nil];
	[self setHueSlider:nil];
	[self setSaturationSlider:nil];
	[self setBrightnessSlider:nil];
	
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation = UIInterfaceOrientationPortrait);
}

- (IBAction)sliderChanged:(id)sender
{
	[self renderButton];
}
@end
