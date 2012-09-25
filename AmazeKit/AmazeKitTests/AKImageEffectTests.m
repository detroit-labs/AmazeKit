//
//  AKImageEffectTests.m
//  AmazeKit
//
//  Created by Jeff Kelley on 9/25/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKImageEffectTests.h"


@implementation AKImageEffectTests {
	CGFloat	_alpha;
	CGBlendMode	_blendMode;
	AKImageEffect	*_imageEffect;
}

- (void)setUp
{
	[super setUp];
	
	_alpha = 1.0f;
	_blendMode = kCGBlendModeNormal;
	
	_imageEffect = [[AKImageEffect alloc] initWithAlpha:_alpha
											  blendMode:_blendMode];
}

- (void)testCreation
{
	STAssertNotNil(_imageEffect, @"An image effect should not be nil.");
	
	STAssertEqualsWithAccuracy([_imageEffect alpha], _alpha, 0.01f, @"The image effect should have the same alpha we initialized it with");
	STAssertEquals([_imageEffect blendMode], _blendMode, @"The image effect should have the same blend mode we initialized it with.");
}

- (void)testDictionaryCreation
{
	NSDictionary *correctOutput = @{
	@"class" : NSStringFromClass([_imageEffect class]),
	@"alpha" : @(_alpha),
	@"blendMode" : @(_blendMode)
	};
	
	STAssertEqualObjects([_imageEffect representativeDictionary], correctOutput, @"The representative dictionary should be correct.");
}

- (void)testHash
{
	NSString *expectedHash = @"d458a15c726bfbbd021af1b1ffd6183621a8cef6";
	NSString *hash = [_imageEffect representativeHash];
	
	STAssertEqualObjects(hash, expectedHash, @"The hash should equal our expected value.");
}

- (void)testCreationFromDictionary
{
	NSDictionary *representation = [_imageEffect representativeDictionary];
	
	AKImageEffect *copy = [[AKImageEffect alloc] initWithRepresentativeDictionary:representation];
	
	STAssertEqualObjects(_imageEffect, copy, @"An image effect created from its representative dictionary should equal itself.");
}

@end
