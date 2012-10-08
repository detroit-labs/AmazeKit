//
//  AKImageRenderer.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/11/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


// Options Dictionary Keys
extern NSString * const AKImageRendererOptionKeyInitialBackgroundColor;

// Notifications
extern NSString * const AKImageRendererEffectDidChangeNotification;


@interface AKImageRenderer : NSObject

// An array of AKImageEffect objects, applied in order.
@property (strong, nonatomic) NSArray	*imageEffects;

// A dictionary of options that will be applied to all images rendered with the renderer.
@property (strong) NSDictionary	*options;

- (UIImage *)imageWithSize:(CGSize)size
					 scale:(CGFloat)scale
				   options:(NSDictionary *)options;

- (NSDictionary *)representativeDictionary;
- (NSString *)representativeHash;
- (NSString *)representativeHashWithOptions:(NSDictionary *)options;
- (id)initWithRepresentativeDictionary:(NSDictionary *)representativeDictionary;

// A dictionary representing previously-rendered images, useful for generating pre-rendered images
// at app startup. The keys are the size turned into a string, and the values are a set containing
// the options dictionaries passed for that size or an NSNull object to represent nil options.
- (NSDictionary *)renderedImages;

@end
