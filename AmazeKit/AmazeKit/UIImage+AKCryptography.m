//
//  UIImage+AKCryptography.m
//  AmazeKit
//
//  Created by Jeff Kelley on 8/13/12.
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


#import "UIImage+AKCryptography.h"

#import <CommonCrypto/CommonDigest.h>


@implementation UIImage (AKCryptography)

- (NSString *)AK_sha1Hash
{
	NSData *data = UIImagePNGRepresentation(self);
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	
    CC_SHA1(data.bytes, data.length, digest);
	
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
	
    return output;
}

@end
