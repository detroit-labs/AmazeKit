//
//  AKFileManager+AKNoiseImageEffectSeeding.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/16/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKFileManager+AKNoiseImageEffectSeeding.h"


@interface AKFileManager (AKNoiseImageEffectSeedingPrivate)

- (NSURL *)AK_noiseSeedURLWithColor:(BOOL)hasColor;

@end


@implementation AKFileManager (AKNoiseImageEffectSeedingPrivate)

- (NSURL *)AK_noiseSeedURLWithColor:(BOOL)hasColor
{
	NSString *colorSuffix = nil;
	
	if (hasColor == YES) {
		colorSuffix = @"_color";
	}
	else {
		colorSuffix = @"_grayscale";
	}
	
	NSURL *cacheURL = [[self class] amazeKitCacheURL];
	
	NSString *noiseFilename = [NSString stringWithFormat:@"noise_seed%@.png", colorSuffix];
	
	NSURL *noiseSeedCacheURL = [cacheURL URLByAppendingPathComponent:noiseFilename];
	
	return noiseSeedCacheURL;
}

@end


@implementation AKFileManager (AKNoiseImageEffectSeeding)

- (UIImage *)AK_noiseImageEffectSeedWithColor:(BOOL)hasColor
{
	UIImage *savedImage = nil;
	
	NSData *savedImageData = [[NSData alloc] initWithContentsOfURL:[self AK_noiseSeedURLWithColor:hasColor]];
	
	if (savedImageData != nil) {
		savedImage = [[UIImage alloc] initWithData:savedImageData];
	}
	
	return savedImage;
}

- (void)AK_setNoiseImageEffectSeed:(UIImage *)seed
						 withColor:(BOOL)hasColor
{
	NSData *imageData = UIImagePNGRepresentation(seed);
	
	if (imageData != nil) {
		[imageData writeToURL:[self AK_noiseSeedURLWithColor:hasColor]
				   atomically:YES];
	}
}

@end
