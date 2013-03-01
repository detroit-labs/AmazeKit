# AmazeKit

AmazeKit is an image rendering library for iOS. Its goal is to retain the performance of using `.png`-formatted images in UIKit classes, while avoiding the chore of creating these images in Photoshop, as well as the extra download size of bundling the images in the app. Images are rendered according to a collection of “image effects,” ranging from a simple gradient or corner radius to blurs, masks, and inner shadows. AmazeKit also offers convenient UIKit support, automatically using the correct images as your controls change size. Retina displays are supported automatically, and AmazeKit aggressively caches rendered images to maintain optimal performance levels.

## Getting Started
The recommended way to get AmazeKit is to use [CocoaPods](http://www.cocoapods.org).

**TODO**: Add instructions for bundling AmazeKit, using a static library, Xcode subproject, and as a Git submodule.

## The `bin` Directory
In the `bin` directory are two scripts: `gen_docs.sh` and `publish_docs.sh`. These scripts are meant for me to run as a convenience to publish the appledoc docs. Use caution when running them.

## Examples
Here are some great apps using AmazeKit:
* [BetARound](http://www.sidebet.me/betaround/)

AmazeKit was developed in Detroit by [Jeff Kelley](http://github.com/SlaunchaMan) at [Detroit Labs](http://www.detroitlabs.com).
