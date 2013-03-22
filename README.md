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


## The `bin` Directory
In the `bin` directory are two scripts: `gen_docs.sh` and `publish_docs.sh`. These scripts are meant for me to run as a convenience to publish the appledoc docs. Use caution when running them.

## Examples
Here are some great apps using AmazeKit:
* [BetARound](http://www.sidebet.me/betaround/)

AmazeKit was developed in Detroit by [Jeff Kelley](http://github.com/SlaunchaMan) at [Detroit Labs](http://www.detroitlabs.com).
