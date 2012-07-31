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
	AKButtonImageCoordinator	*buttonImageCoordinator;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UISlider *hueSlider;
@property (strong, nonatomic) IBOutlet UISlider *saturationSlider;
@property (strong, nonatomic) IBOutlet UISlider *brightnessSlider;

- (void)renderImage;
- (IBAction)sliderChanged:(id)sender;

@end


@implementation AKViewController

@synthesize imageView;
@synthesize button;
@synthesize hueSlider;
@synthesize saturationSlider;
@synthesize brightnessSlider;

- (void)renderImage
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
		
		[gradientEffect setColors:@[beginColor, endColor]];
		
		// Color Effect
		colorEffect = [[AKColorImageEffect alloc] init];
		[colorEffect setBlendMode:kCGBlendModeColor];
		
		// Bevel Effect
		bevelEffect = [[AKButtonBevelImageEffect alloc] init];
		
		[buttonRenderer setImageEffects:@[noiseEffect,
										 gradientEffect,
										 colorEffect,
										 bevelEffect]];
	}
	
	[colorEffect setColor:[UIColor colorWithHue:[[self hueSlider] value]
									 saturation:[[self saturationSlider] value]
									 brightness:[[self brightnessSlider] value]
										  alpha:1.0f]];
	
	NSDate *beginTime = [NSDate date];
	
	UIImage *image = [buttonRenderer imageWithSize:[imageView frame].size
										   options:nil];
	
	NSDate *endTime = [NSDate date];
	
	NSLog(@"Rendered in %f seconds.", [endTime timeIntervalSinceDate:beginTime]);
	
	[[self imageView] setImage:image];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self renderImage];
	
	if (buttonImageCoordinator == nil) {
		buttonImageCoordinator = [[AKButtonImageCoordinator alloc] init];
		
		AKImageRenderer *onButtonRenderer = [[AKImageRenderer alloc] init];
		
		// Noise Effect
		AKNoiseImageEffect *onNoiseEffect = [[AKNoiseImageEffect alloc] init];
		[onNoiseEffect setAlpha:0.05f];
		[onNoiseEffect setNoiseType:AKNoiseTypeBlackAndWhite];
		
		// Gradient Effect
		AKGradientImageEffect *onGradientEffect = [[AKGradientImageEffect alloc] init];
		[onGradientEffect setBlendMode:kCGBlendModeMultiply];
		
		UIColor *onBeginColor = [UIColor colorWithRed:103.0f / 255.0f
												green:103.0f / 255.0f
												 blue:103.0f / 255.0f
												alpha:1.0f];
		
		UIColor *onEndColor = [UIColor colorWithRed:103.0f / 255.0f
											  green:103.0f / 255.0f
											   blue:103.0f / 255.0f
											  alpha:1.0f];
		
		[onGradientEffect setColors:@[onBeginColor, onEndColor]];
		
		// Color Effect
		AKColorImageEffect *onColorEffect = [[AKColorImageEffect alloc] init];
		[onColorEffect setBlendMode:kCGBlendModeColor];
		[onColorEffect setColor:[UIColor blueColor]];
		
		// Corner Radius Effect
		AKCornerRadiusImageEffect *buttonCornerRadiusEffect = [[AKCornerRadiusImageEffect alloc] init];
		[buttonCornerRadiusEffect setCornerRadii:AKCornerRadiiMake(20.0f, 20.0f, 20.0f, 20.0f)];
		
		// Bevel Effect
		AKButtonBevelImageEffect *onBevelEffect = [[AKButtonBevelImageEffect alloc] init];
		
		// Glow Effect
		AKInnerGlowImageEffect *innerGlowEffect = [[AKInnerGlowImageEffect alloc] init];
		[innerGlowEffect setRadius:5.0f];
		[innerGlowEffect setAlpha:0.5f];
		[innerGlowEffect setBlendMode:kCGBlendModeOverlay];
		
		[onButtonRenderer setImageEffects:@[onNoiseEffect,
										   onGradientEffect,
										   onColorEffect,
										   buttonCornerRadiusEffect,
										   onBevelEffect,
										   innerGlowEffect]];
		
		AKImageRenderer *offButtonRenderer = [[AKImageRenderer alloc] init];
		
		// Noise Effect
		AKNoiseImageEffect *offNoiseEffect = [[AKNoiseImageEffect alloc] init];
		[offNoiseEffect setAlpha:0.05f];
		[offNoiseEffect setNoiseType:AKNoiseTypeBlackAndWhite];
		
		// Gradient Effect
		AKGradientImageEffect *offGradientEffect = [[AKGradientImageEffect alloc] init];
		[offGradientEffect setBlendMode:kCGBlendModeMultiply];
		
		UIColor *offBeginColor = [UIColor colorWithRed:144.0f / 255.0f
												 green:144.0f / 255.0f
												  blue:144.0f / 255.0f
												 alpha:1.0f];
		
		UIColor *offEndColor = [UIColor colorWithRed:103.0f / 255.0f
											   green:103.0f / 255.0f
												blue:103.0f / 255.0f
											   alpha:1.0f];
		
		[offGradientEffect setColors:@[offBeginColor, offEndColor]];
		
		// Color Effect
		AKColorImageEffect *offColorEffect = [[AKColorImageEffect alloc] init];
		[offColorEffect setBlendMode:kCGBlendModeColor];
		[offColorEffect setColor:[UIColor redColor]];
		
		// Bevel Effect
		AKButtonBevelImageEffect *offBevelEffect = [[AKButtonBevelImageEffect alloc] init];
		
		[offButtonRenderer setImageEffects:@[offNoiseEffect,
											offGradientEffect,
											offColorEffect,
											buttonCornerRadiusEffect,
											offBevelEffect]];
		
		[buttonImageCoordinator setOnImageRenderer:onButtonRenderer];
		[buttonImageCoordinator setOffImageRenderer:offButtonRenderer];
	}
	
	[buttonImageCoordinator addButton:[self button]];
}

- (void)viewDidUnload
{
	[self setImageView:nil];
	[self setHueSlider:nil];
	[self setSaturationSlider:nil];
	[self setBrightnessSlider:nil];
	
	[self setButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation = UIInterfaceOrientationPortrait);
}

- (IBAction)sliderChanged:(id)sender
{
	[self renderImage];
}
@end
