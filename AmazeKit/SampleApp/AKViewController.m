//
//  AKViewController.m
//  SmapleApp
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//

#import "AKViewController.h"

#import "AmazeKit.h"

@interface AKViewController ()

@end

@implementation AKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 250.0f, 75.0f)];
	
	AKImageRenderer *renderer = [[AKImageRenderer alloc] init];
	
	// Noise Effect
	AKNoiseImageEffect *noiseEffect = [[AKNoiseImageEffect alloc] init];
	[noiseEffect setAlpha:0.05f];
	[noiseEffect setNoiseType:AKNoiseTypeBlackAndWhite];
	
	// Gradient Effect
	AKGradientImageEffect *gradientEffect = [[AKGradientImageEffect alloc] init];
	[gradientEffect setBlendMode:kCGBlendModeMultiply];
	
	UIColor *beginColor = [UIColor colorWithRed:144.0f / 255.0f
										  green:144.0f / 255.0f
										   blue:144.0f / 255.0f
										  alpha:1.0f];
	
	UIColor *endColor = [UIColor colorWithRed:103.0f / 255.0f
										green:103.0f / 255.0f
										 blue:103.0f / 255.0f
										alpha:1.0f];
	
	// Color Effect
	AKColorImageEffect *colorEffect = [[AKColorImageEffect alloc] init];
	[colorEffect setBlendMode:kCGBlendModeColor];
	[colorEffect setColor:[UIColor colorWithRed:  0.0f / 255.0f
										  green:152.0f / 255.0f
										   blue:255.0f / 255.0f
										  alpha:1.0f]];
	
	// Corner Radius Effect
	AKCornerRadiusImageEffect *cornerRadiusEffect = [[AKCornerRadiusImageEffect alloc] init];
	[cornerRadiusEffect setCornerRadii:AKCornerRadiiMake(50.0f, 10.0f, 10.0f, 5.0f)];
	
	[gradientEffect setColors:[NSArray arrayWithObjects:beginColor, endColor, nil]];
	
	[renderer setImageEffects:[NSArray arrayWithObjects:
							   noiseEffect,
							   gradientEffect,
							   colorEffect,
							   cornerRadiusEffect,
							   nil]];
	
	UIImage *image = [renderer imageWithSize:[imageView frame].size
									 options:nil];
	
	[imageView setImage:image];	
	
	[[self view] addSubview:imageView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
