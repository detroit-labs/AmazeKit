//
//  AKImageEffectTests.m
//  AmazeKit
//
//  Created by Jeff Kelley on 9/25/12.
//  Copyright (c) 2013 Detroit Labs. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
	XCTAssertNotNil(_imageEffect, @"An image effect should not be nil.");
	
	XCTAssertEqualWithAccuracy([_imageEffect alpha], _alpha, 0.01f, @"The image effect should have the same alpha we initialized it with");
	XCTAssertEqual([_imageEffect blendMode], _blendMode, @"The image effect should have the same blend mode we initialized it with.");
}

- (void)testDictionaryCreation
{
	NSDictionary *correctOutput = @{
	@"class" : NSStringFromClass([_imageEffect class]),
	@"alpha" : @(_alpha),
	@"blendMode" : @(_blendMode)
	};
	
	XCTAssertEqualObjects([_imageEffect representativeDictionary], correctOutput, @"The representative dictionary should be correct.");
}

- (void)testHash
{
	NSString *expectedHash = @"432bc9625fee0f5be733bc217504d57ad1e411bf";
	NSString *hash = [_imageEffect representativeHash];
	
	XCTAssertEqualObjects(hash, expectedHash, @"The hash should equal our expected value.");
}

- (void)testCreationFromDictionary
{
	NSDictionary *representation = [_imageEffect representativeDictionary];
	
	AKImageEffect *copy = [[AKImageEffect alloc] initWithRepresentativeDictionary:representation];
	
	XCTAssertEqualObjects(_imageEffect, copy, @"An image effect created from its representative dictionary should equal itself.");
}

@end
