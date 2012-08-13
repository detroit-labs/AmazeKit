//
//  AKImageRenderer.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/11/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


// Options Dictionary Keys
extern NSString * const AKImageRendererOptionKeyInitialBackgroundColor;


@interface AKImageRenderer : NSObject

// An array of AKImageEffect objects, applied in order.
@property (strong) NSArray	*imageEffects;

- (UIImage *)imageWithSize:(CGSize)size
					 scale:(CGFloat)scale
				   options:(NSDictionary *)options;

- (NSDictionary *)representativeDictionary;
- (NSString *)representativeHash;
- (NSString *)representativeHashWithOptions:(NSDictionary *)options;
- (id)initWithRepresentativeDictionary:(NSDictionary *)representativeDictionary;

@end
