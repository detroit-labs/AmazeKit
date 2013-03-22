# AmazeKit

AmazeKit is an image rendering library for iOS. Its goal is to retain the performance of using `.png`-formatted images in UIKit classes, while avoiding the chore of creating these images in Photoshop, as well as the extra download size of bundling the images in the app. Images are rendered according to a collection of “image effects,” ranging from a simple gradient or corner radius to blurs, masks, and inner shadows. AmazeKit also offers convenient UIKit support, automatically using the correct images as your controls change size. Retina displays are supported automatically, and AmazeKit aggressively caches rendered images to maintain optimal performance levels.

## Getting Started
The recommended way to get AmazeKit is to use [CocoaPods](http://www.cocoapods.org).

**TODO**: Add instructions for bundling AmazeKit, using a static library, Xcode subproject, and as a Git submodule.

## Examples
The best way to see how AmazeKit works is to see it in action. Let’s look at a couple of common use cases and see what they produce:

### Rendering an Individual Image
The following code sets up an `AKImageCoordinator`. This class is responsible for rendering an image into a `UIImageView`, automatically rendering it at the appropriate size:

    // Noise Effect
    AKNoiseImageEffect *noiseEffect =
    [[AKNoiseImageEffect alloc] initWithAlpha:0.05f
                                    blendMode:kCGBlendModeMultiply
                                    noiseType:AKNoiseTypeBlackAndWhite];
    
    // Gradient Effect
    UIColor *beginColor = [UIColor colorWithRed:144.0f / 255.0f
                                          green:144.0f / 255.0f
                                           blue:144.0f / 255.0f
                                          alpha:1.0f];
    
    UIColor *endColor = [UIColor colorWithRed:103.0f / 255.0f
                                        green:103.0f / 255.0f
                                         blue:103.0f / 255.0f
                                        alpha:1.0f];
    
    AKGradientImageEffect *gradientEffect =
    [[AKGradientImageEffect alloc] initWithAlpha:1.0f
                                       blendMode:kCGBlendModeMultiply
                                          colors:@[beginColor, endColor]
                                       direction:AKGradientDirectionVertical
                                       locations:nil];
    
    // Color Effect
    AKColorImageEffect *colorEffect =
    [[AKColorImageEffect alloc] initWithAlpha:1.0f
                                    blendMode:kCGBlendModeColor
                                        color:[UIColor blueColor]];
    
    
    // Create the image renderer
    AKImageRenderer *imageRenderer = [[AKImageRenderer alloc] init];
    
    [imageRenderer setImageEffects:@[
     noiseEffect,
     gradientEffect,
     colorEffect
     ]];
    
    AKImageCoordinator *imageCoordinator = [[AKImageCoordinator alloc] init];
    [imageCoordinator setImageRenderer:imageRenderer];
    
    [imageCoordinator addImageView:myImageView];

This produces the following image output (for an image view with a size of 250 x 100 on a Retina display):

![Example Image 1](readme_images/example_1.png)

### Rendering Button Images
The `AKButtonImageCoordinator` class is like the `AKImageCoordinator` class, but it takes two image renderers instead of one. The “off” image renderer is used for the button’s normal control state, and the “on” image renderer is used for the button’s highlighted control state. The `AKButtonImageCoordinator` takes care of rendering background images for your button and automatically renders them to the correct size. Here’s an example:

    // The butons will have a noise effect, rounded corners, and a gradient in
    // common.
    AKNoiseImageEffect *noiseEffect =
    [[AKNoiseImageEffect alloc] initWithAlpha:0.05f
                                    blendMode:kCGBlendModeMultiply
                                    noiseType:AKNoiseTypeBlackAndWhite];
    
    UIColor *topColor = [UIColor colorWithRed:144.0f / 255.0f
                                        green:144.0f / 255.0f
                                         blue:144.0f / 255.0f
                                        alpha:1.0f];
    
    UIColor *bottomColor = [UIColor colorWithRed:103.0f / 255.0f
                                           green:103.0f / 255.0f
                                            blue:103.0f / 255.0f
                                           alpha:1.0f];
 
    AKGradientImageEffect *gradientImageEffect =
    [[AKGradientImageEffect alloc] initWithAlpha:1.0f
                                       blendMode:kCGBlendModeMultiply
                                          colors:@[topColor, bottomColor]
                                       direction:AKGradientDirectionVertical
                                       locations:nil];
    
    AKCornerRadii cornerRadii = AKCornerRadiiMake(4.0f, 4.0f, 4.0f, 4.0f);

    AKCornerRadiusImageEffect *cornerRadiusEffect =
    [[AKCornerRadiusImageEffect alloc] initWithAlpha:1.0f
                                           blendMode:kCGBlendModeNormal
                                         cornerRadii:cornerRadii];
    
    // The “off” state is blue, the “on” state is red.
    AKColorImageEffect *onColorEffect =
    [[AKColorImageEffect alloc] initWithAlpha:1.0f
                                    blendMode:kCGBlendModeColor
                                        color:[UIColor redColor]];
	
    AKColorImageEffect *offColorEffect =
    [[AKColorImageEffect alloc] initWithAlpha:1.0f
                                    blendMode:kCGBlendModeColor
                                        color:[UIColor blueColor]];
	
    // We create two image renderers, one for each state
    AKImageRenderer *offImageRenderer = [[AKImageRenderer alloc] init];
    AKImageRenderer *onImageRenderer = [[AKImageRenderer alloc] init];
    
    // And we assign the image effects for each.
    [offImageRenderer setImageEffects:@[
     noiseEffect,
     gradientImageEffect,
     offColorEffect,
     cornerRadiusEffect
     ]];
    
    [onImageRenderer setImageEffects:@[
     noiseEffect,
     gradientImageEffect,
     onColorEffect,
     cornerRadiusEffect
     ]];
    
    // Next we create the button image coordinator and assign the image
    // renderers to it
    AKButtonImageCoordinator *buttonImageCooordinator =
    [[AKButtonImageCoordinator alloc] init];
    
    [buttonImageCooordinator setOffImageRenderer:offImageRenderer];
    [buttonImageCooordinator setOnImageRenderer:onImageRenderer];
    
    // Finally, we add a button.
    [buttonImageCooordinator addButton:myButton];

This produces the following image output (for a button that’s 150 x 44 on a Retina display):

Off: ![Example Image 2 (Off)](readme_images/example2_off.png)
On: ![Example Image 2 (On)](readme_images/example2_on.png)

## The `bin` Directory
In the `bin` directory are two scripts: `gen_docs.sh` and `publish_docs.sh`. These scripts are meant for me to run as a convenience to publish the appledoc docs. Use caution when running them.

## Examples
Here are some great apps using AmazeKit:
* [BetARound](http://www.sidebet.me/betaround/)

AmazeKit was developed in Detroit by [Jeff Kelley](http://github.com/SlaunchaMan) at [Detroit Labs](http://www.detroitlabs.com).
