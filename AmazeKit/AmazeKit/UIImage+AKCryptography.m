//
//  UIImage+AKCryptography.m
//  AmazeKit
//
//  Created by Jeff Kelley on 8/13/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
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
