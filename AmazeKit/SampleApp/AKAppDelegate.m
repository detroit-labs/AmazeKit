//
//  AKAppDelegate.m
//  SampleApp
//
//  Created by Jeffrey Kelley on 6/12/12.
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

#import "AKAppDelegate.h"

#import "AKMenuViewController.h"
#import "AKHSLAdjustingViewController.h"


@implementation AKAppDelegate

#pragma mark - UIApplicationDelegate Protocol Methods

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	UIWindow *window =
	[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	[window makeKeyAndVisible];
	
	AKMenuViewController *menuViewController =
	[[AKMenuViewController alloc] initWithStyle:UITableViewStylePlain];
	
	[menuViewController setViewControllers:@[
	 [[AKHSLAdjustingViewController alloc] initWithNibName:nil bundle:nil]
	 ]];
	
	UINavigationController *navigationController =
	[[UINavigationController alloc]
	 initWithRootViewController:menuViewController];
	
	[window setRootViewController:navigationController];
	[self setWindow:window];
	
	return YES;
}

#pragma mark -

@end
