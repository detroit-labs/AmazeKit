//
//  AKMenuViewController.m
//  AmazeKit
//
//  Created by Jeff Kelley on 3/22/13.
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


#import "AKMenuViewController.h"


@implementation AKMenuViewController

#pragma mark - Table View Controller Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	
	if (self) {
		[self setTitle:@"Examples"];
	}
	
	return self;
}

#pragma mark - UITableViewDataSource Protocol Methods

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"viewControllerCell";
	
    UITableViewCell *cell =
	[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									  reuseIdentifier:cellIdentifier];
	}
    
    UIViewController *viewController = [self viewControllers][[indexPath row]];
	
	[[cell textLabel] setText:[viewController title]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self viewControllers] count];
}

#pragma mark - UITableViewDelegate Protocol Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIViewController *viewController = [self viewControllers][[indexPath row]];
	
	[[self navigationController] pushViewController:viewController
										   animated:YES];
}

#pragma mark -

@end
