//
//  UIView+AKScaleInfo.m
//  AmazeKit
//
//  Created by Jeff Kelley on 8/12/12.
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


#import "UIView+AKScaleInfo.h"


@implementation UIView (AKScaleInfo)

- (CGFloat)AK_scale
{
	CGFloat scale = [[UIScreen mainScreen] scale];
	
	if ([self window] != nil) {
		scale = [[[self window] screen] scale];
	}
	
	return scale;
}

@end
