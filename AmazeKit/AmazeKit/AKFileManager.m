//
//  AKFileManager.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/16/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "AKFileManager.h"


@implementation AKFileManager

#pragma mark - Object Lifecycle

+ (id)defaultManager
{
	static id sharedInstance = nil;
	
	if (sharedInstance == nil) {
		sharedInstance = [[self alloc] init];
	}
	
	return sharedInstance;
}

#pragma mark -

@end
