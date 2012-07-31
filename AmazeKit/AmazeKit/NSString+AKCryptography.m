//
//  NSString+AKCryptography.m
//  AmazeKit
//
//  Created by Jeff Kelley on 7/31/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "NSString+AKCryptography.h"

#import <CommonCrypto/CommonDigest.h>


@implementation NSString (AKCryptography)

// http://stackoverflow.com/a/7571583/105431
- (NSString *)AK_sha1Hash
{
	NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
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
