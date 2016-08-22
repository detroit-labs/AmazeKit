//
//  NSData+AZKCryptography.m
//  AmazeKit
//
//  Created by Jeff Kelley on 8/22/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
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

#import "NSData+AZKCryptography.h"

#import <CommonCrypto/CommonCrypto.h>

#define AZK_CC_LONG_MAX UINT32_MAX

@implementation NSData (AZKCryptography)

- (NSString *)azk_sha1Hash
{
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1_CTX ctx;
    CC_SHA1_Init(&ctx);
    
    memset(digest, 0, sizeof(digest));
    
    for (CC_LONG offset = 0; (NSUInteger)offset < self.length; offset += AZK_CC_LONG_MAX) {
        NSUInteger remainingBytes = self.length - offset;
        
        CC_SHA1_Update(&ctx,
                       self.bytes + offset,
                       (CC_LONG)MIN(remainingBytes, AZK_CC_LONG_MAX));
    }
    
    CC_SHA1_Final(digest, &ctx);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:
                               (CC_SHA1_DIGEST_LENGTH * 2)];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end
