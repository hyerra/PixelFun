/*:
 Now that we have our photo, it's time to make some fun filters to apply to the photo! In order to create and apply the filter, we are going to use the [Open GL Shading Language](glossary://opengl) along with the [Core Image](glossary://coreimage) framework.
 - - -
 Before we dive in, let's run through the process step by step in order to make sure you fully grasp what we are about to do.
 
 1. Create the filter using the [Open GL Shading Language](glossary://opengl).
 2. Convert the image to a `CIImage`.
 3. Configure the filter settings to customize the input image.
 4. Generate the image from the filter and display it.
 */

//#-hidden-code
import PlaygroundSupport
import UIKit
import CoreImage

let page = PlaygroundPage.current

let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

func loadFilterImage() -> UIImage {
    if let playgroundImage = PlaygroundKeyValueStore.current["filterImage"], case let .data(imageData) = playgroundImage, let image = UIImage(data: imageData) {
        return image
    } else {
        return #imageLiteral(resourceName: "harish1")
    }
}

let mtlDevice: MTLDevice = MTLCreateSystemDefaultDevice()!
let context: CIContext = CIContext(mtlDevice: mtlDevice, options: [kCIContextCacheIntermediates: false])

public func generateCGImage(from ciImage: CIImage, with extent: CGRect? = nil) -> CGImage? {
    // `kCIFormatRGBAh` is preferred but use `kCIFormatRGBA8` as a fallback for performance/memory issues
    let cs = CGColorSpace(name: CGColorSpace.extendedLinearSRGB)
    let contextImage = context.createCGImage(ciImage, from: extent ?? ciImage.extent, format: kCIFormatRGBAh, colorSpace: cs, deferred: false)
    return contextImage
}
//#-end-hidden-code
//: Create the kernel for the filter. This kernel essentially adjusts the amount of blue and red based on where a pixel is located in the image. If you know the [Open GL Shading Language](glossary://opengl) and are feeling creative, feel free to manipulate the kernel to add some custom effects. However, if you don't understand the [Open GL Shading Language](glossary://opengl), the kernel below should work without any modification so there is no need to edit it.
var kernelText =
//#-editable-code
"""
kernel vec4 viennaFilter(sampler image) {
    vec4 pixel = sample(image, samplerCoord(image));
    vec2 size = samplerSize(image);
    vec2 pixelLocation = destCoord();
    float width = size.x;
    pixel.r = (size.x - pixelLocation.x)/width;
    pixel.b = pixelLocation.x/width;
    return pixel;
}
"""
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, loadFilterImage())
//#-code-completion(identifier, show, kernelText)
//#-code-completion(identifier, show, image)
//#-end-editable-code
//: To load the image taken on the [previous page](@previous) just call `loadFilterImage()`. However, if you want to use a default image, just tap on the token below to select a default image.
let image = /*#-editable-code*/<#T##filter image##UIImage#>/*#-end-editable-code*/
//: Instantiate the filter by passing in the kernel text. Try typing in `kernelText` to get it working!
let viennaFilter = Vienna(kernelText: /*#-editable-code*/<#T##kernel text##String#>/*#-end-editable-code*/)
//: Next, we have to customize the settings for the filter. In order to get started though, we need a `CIImage`ry typing `image` below to convert it to a `CIImage`!
let convertedImage = CIImage(image: /*#-editable-code*/<#image#>/*#-end-editable-code*/)
viennaFilter.setValue(convertedImage, forKey: kCIInputImageKey)
//: Convert the output to an image we can display!
let outputImage = viennaFilter.outputImage!
let cgImage = generateCGImage(from: outputImage)!
let finalImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
//#-hidden-code
let message = PlaygroundMessageToLiveView.showCustomFilteredImage(image: finalImage).playgroundValue
proxy?.send(message)
//#-end-hidden-code
//#-hidden-code
page.assessmentStatus = assessmentPoint()
//#-end-hidden-code
