//
//  AKNoiseImageEffect.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/11/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKNoiseImageEffect.h"

#import "AKFileManager+AKNoiseImageEffectSeeding.h"
#import "UIImage+AKPixelData.h"


static const CGSize kNoiseSeedSize = { 100.0f, 100.0f };


@interface AKNoiseImageEffect() {
	CGImageRef	_noiseSeedImageRef;
}

- (void)didReceiveMemoryWarning;
- (CGImageRef)savedNoiseSeedImageRef;

@end


@implementation AKNoiseImageEffect

@synthesize noiseType = _noiseType;

- (id)init
{
	self = [super init];
	
	if (self) {
		_noiseType = AKNoiseTypeBlackAndWhite;
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(didReceiveMemoryWarning)
													 name:UIApplicationDidReceiveMemoryWarningNotification
												   object:nil];
	}
	
	return self;
}

- (void)dealloc
{
	if (_noiseSeedImageRef != NULL) {
		CGImageRelease(_noiseSeedImageRef);
	}
}

- (void)didReceiveMemoryWarning
{
	if (_noiseSeedImageRef != NULL) {
		CGImageRelease(_noiseSeedImageRef);
		_noiseSeedImageRef = NULL;
	}
}

- (UIImage *)renderedImageFromSourceImage:(UIImage *)sourceImage
{
	// Create the noise layer.
	NSUInteger width = [sourceImage size].width * [sourceImage scale];
	NSUInteger height = [sourceImage size].height * [sourceImage scale];
	
	CGImageRef noiseTileImageRef = [self savedNoiseSeedImageRef];
		
	// Render the noise tile on top of the source image.
	UIGraphicsBeginImageContextWithOptions([sourceImage size], NO, 0.0f);
//	width = [sourceImage size].width;
//	height = [sourceImage size].height;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), [sourceImage CGImage]);
	
	[self applyAppearanceProperties];
	CGContextDrawTiledImage(context, CGRectMake(0.0f,
												0.0f,
												kNoiseSeedSize.width / [sourceImage scale],
												kNoiseSeedSize.height / [sourceImage scale]),
							noiseTileImageRef);
	
	UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	context = NULL;
	
	return renderedImage;
}

- (CGImageRef)savedNoiseSeedImageRef
{
	if (_noiseSeedImageRef == NULL) {	
		BOOL hasColor = ([self noiseType] == AKNoiseTypeColor);
		UIImage *seedImage = [[AKFileManager defaultManager] AK_noiseImageEffectSeedWithColor:hasColor];
		
		if (seedImage == nil) {
			// Generate the image.
			NSUInteger width = (NSUInteger)kNoiseSeedSize.width;
			NSUInteger height = (NSUInteger)kNoiseSeedSize.height;
			
			// Create a buffer to draw noise into
			// Create an image context to draw into.
			CGColorSpaceRef noiseColorSpace = CGColorSpaceCreateDeviceRGB();
			size_t numberOfComponents = 3;
			
			int bitsPerComponent = 8;
			int bytesPerPixel = ((numberOfComponents + 1) * bitsPerComponent) / 8;
			int bytesPerRow = bytesPerPixel * width;
			
			// Create the data buffer for the image.
			uint8_t *imageData = calloc(width * height, bytesPerPixel);
			
			for (NSUInteger x = 0; x < width; x++) {
				for (NSUInteger y = 0; y < height; y++) {
					int offset = (bytesPerRow * y) + (bytesPerPixel * x);
					
					if ([self noiseType] == AKNoiseTypeBlackAndWhite) {
						uint8_t white = arc4random_uniform(UINT8_MAX);
						uint8_t alpha = arc4random_uniform(UINT8_MAX);
						
						imageData[offset]     = white;
						imageData[offset + 1] = white;
						imageData[offset + 2] = white;
						imageData[offset + 3] = alpha;
					}
					else if ([self noiseType] == AKNoiseTypeColor) {
						uint8_t red   = arc4random_uniform(UINT8_MAX);
						uint8_t green = arc4random_uniform(UINT8_MAX);
						uint8_t blue  = arc4random_uniform(UINT8_MAX);
						uint8_t alpha = arc4random_uniform(UINT8_MAX);
						
						imageData[offset]     = red;
						imageData[offset + 1] = blue;
						imageData[offset + 2] = green;
						imageData[offset + 3] = alpha;
					}
				}
			}
			
			CGContextRef noiseContext = CGBitmapContextCreate((void *)imageData,
															  width,
															  height,
															  bitsPerComponent,
															  bytesPerRow,
															  noiseColorSpace,
															  kCGImageAlphaPremultipliedLast);
			
			_noiseSeedImageRef = CGBitmapContextCreateImage(noiseContext);
			seedImage = [[UIImage alloc] initWithCGImage:_noiseSeedImageRef];
			
			CGContextRelease(noiseContext);
			CGColorSpaceRelease(noiseColorSpace);
			free(imageData);
			
			[[AKFileManager defaultManager] AK_setNoiseImageEffectSeed:seedImage withColor:hasColor];
		}
		else {
			_noiseSeedImageRef = CGImageRetain([seedImage CGImage]);
		}
	}
	
	return _noiseSeedImageRef;
}

@end
