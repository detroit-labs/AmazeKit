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
	
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 200.0f, 50.0f)];
	
	AKImageRenderer *renderer = [[AKImageRenderer alloc] init];
	
	AKNoiseImageEffect *noiseEffect = [[AKNoiseImageEffect alloc] init];
	[noiseEffect setNoiseType:AKNoiseTypeBlackAndWhite];
	
	[renderer setImageEffects:[NSArray arrayWithObjects:
							   noiseEffect,
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
