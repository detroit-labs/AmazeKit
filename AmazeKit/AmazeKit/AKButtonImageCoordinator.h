//
//  AKButtonImageCoordinator.h
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/19/12.
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


#import <UIKit/UIKit.h>


/** The AKImageCoordinator class is a convenient way to ensure that specific image renderers will
 *  produce appropriately-sized images for displaying in a button.
 *
 *  Typically, you will have a reference to an AKButtonImageCoordinator in a UIViewController class.
 *  Then, in the -viewWillAppear: method of your view controller, you’ll call -addButton: on the
 *  button coordinator, which will take care of setting the appropriate image values. Similarly, in
 *  your implementation of -viewWillDisappear:, you’ll call -removeButton: with the button to
 *  absolve the button image coordinator of responsibility for rendering images for off-screen
 *  views.
 *
 *  The button image coordinator maintains a reference to two image renderers: onImageRenderer and
 *  offImageRenderer. The onImageRenderer corresponds to the button’s highlighted control state, and
 *  the offImageRenderer corrsponds to the button’s normal control state.
 */

@class AKImageRenderer;

@interface AKButtonImageCoordinator : NSObject

/** ----------------------------------------------
 *  @name Configuring the Button Image Coordinator
 *  ----------------------------------------------
 */

/** An image renderer for the “on” state, corresponding to the button’s highlighted control state.
 */
@property (strong, nonatomic) AKImageRenderer	*onImageRenderer;

/** An image renderer for the “off” state, corresponding to the button’s normal control state.
 */
@property (strong, nonatomic) AKImageRenderer	*offImageRenderer;


/** ---------------------------------
 *  @name Adding and Removing Buttons
 *  ---------------------------------
 */

/** Adds a button to the button image coordinator. When the button’s frame changes, the button image
 *  coordinator will automatically re-render the images.
 *
 *  @param button The button for which the image coordinator will render images.
 */
- (void)addButton:(UIButton *)button;

/** Removes a button from the button image coordinator. This will not clear the current images in
 *  the button, but will prevent the button image coordinator from re-rendering images if the
 *  button’s frame changes.
 *
 *  @param button The button for which the button image coordinator will no longer render images.
 */
- (void)removeButton:(UIButton *)button;

@end
