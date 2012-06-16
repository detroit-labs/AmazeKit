//
//  AKFileManager+AKNoiseImageEffectSeeding.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/16/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKFileManager.h"
#import "AKNoiseImageEffect.h"


@interface AKFileManager (AKNoiseImageEffectSeeding)

// The seed is a 100x100 pixel image to keep the noise consistent.
- (UIImage *)AK_noiseImageEffectSeedWithColor:(BOOL)hasColor;
- (void)AK_setNoiseImageEffectSeed:(UIImage *)seed
						 withColor:(BOOL)hasColor;

@end
