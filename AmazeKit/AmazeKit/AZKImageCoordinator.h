//
//  AZKImageCoordinator.h
//  AmazeKit
//
//  Created by Jeff Kelley on 9/8/12.
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

NS_ASSUME_NONNULL_BEGIN

/** The AZKImageCoordinator class is a convenient way to ensure that a specific
 *  image renderer will produce an appropriately-sized image for displaying in an
 *  image view.
 *
 *  Typically, you will have a reference to an AKImageCoordinator in a
 *  UIViewController class. Then, in the -viewWillAppear: method of your view
 *  controller, you’ll call -addImageView: on the image coordinator, which will take
 *  care of setting the appropriate image value. Similarly, in your implementation
 *  of -viewWillDisappear:, you’ll call -removeImageView: with the image view to
 *  absolve the image coordinator of responsibility for rendering images for
 *  off-screen views.
 */

@class AZKImageRenderer;

@interface AZKImageCoordinator : NSObject

/** ---------------------------------------
 *  @name Configuring the Image Coordinator
 *  ---------------------------------------
 */

/** The image renderer to use when creating images for an image view.
 */
@property (strong, nonatomic, nullable) AZKImageRenderer *imageRenderer;


/** -------------------------------------
 *  @name Adding and Removing Image Views
 *  -------------------------------------
 */

/** Adds an image view to the image coordinator. When the image view’s frame 
 *  changes, the image coordinator will automatically re-render the image.
 *
 *  @param imageView The image view for which the image coordinator will render
 *                   images.
 */
- (void)addImageView:(UIImageView *)imageView;

/** Removes an image view from the image coordinator. This will not clear the
 *  current image in the image view, but will prevent the image coordinator from re-
 *  rendering images if the image view’s frame changes.
 *
 *  @param imageView The image view for which the image coordinator will no longer 
 *                   render images.
 */
- (void)removeImageView:(UIImageView *)imageView;

@end

NS_ASSUME_NONNULL_END
