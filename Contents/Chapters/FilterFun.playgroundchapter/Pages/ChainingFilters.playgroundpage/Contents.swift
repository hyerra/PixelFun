/*:
 Hopefully, you had fun building the custom filter in the [previous page](@previous)! If you felt creative and modified the kernel, that's awesome! Hopefully, my code was able to provide a foundation for you to create amazing and interesting effects 😀.
 - - -
 The next day, however, you go back to work feeling proud of being able to create awesome filters. You are going to be looking like a star in all your photos now! However, your boss heard about your talent from one of your co-workers. He stops you just as you leave work and asks you if you'd be willing to create some effects for some photos he has on his computer. Being a kind person, you agree and decide that maybe the filter we built on the [previous page](@next) looks really nice but you want to add a little bit more! You decide that you want to create a neat little blur around the face to add a nice effect ✨.
 - - -
 In this page, we are going to take what we learned up a notch by chaining multiple filters in a way that ensures optimum performance. Additionally, we are going to be using the power of [Core Image](glossary://coreimage) to detect where a face is located to include an interesting blur. It'll look really cool and I hope you'll enjoy it!
 
 Let's get to work 🎊!
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
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, loadFilterImage())
//#-code-completion(identifier, show, FacialFeatures, ., Accuracy, ., high, low)
//#-code-completion(identifier, show, blurCenterPoint)
//#-end-hidden-code
//: If you took an image and want to load it just call `loadFilterImage()` here. However, if you want to use a default image, just tap on the token below to select a default image.
let image = /*#-editable-code*/<#T##filter image##UIImage#>/*#-end-editable-code*/
let convertedImage = CIImage(image: image)!
//: Register our custom filters with [Core Image](glossary://coreimage).
FilterConstructor.registerFilters()
//: Instantiate our insanely cool custom filter from the [previous page](@previous) 👨‍🎨!
let viennaFilter = CIFilter(name: "Vienna")!
let zoomBlurFilter = CIFilter(name: "CIZoomBlur")!
//: Now, it's time for the cool part - detecting where the faces are in the image 😯! You can choose how accurate you would like [Core Image](glossary://coreimage) to be. Remember, the lower the accuracy, the faster it loads and the higher the accuracy the slower it loads! If no face is detected, we will just use the center of the image.
let facialFeatures = FacialFeatures(image: convertedImage)
// `.high` and `.low` are acceptable values for the `accuracy` parameter below.
let firstFaceRect = facialFeatures.detectLocationOfFaces(withAccuracy: /*#-editable-code*/<#T##accuracy##FacialFeatures.Accuracy#>/*#-end-editable-code*/)?.first ?? CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
let blurCenterPoint = CIVector(x: firstFaceRect.midX, y: firstFaceRect.midY)
//: After determining the center point, it's time to pass our desired settings into the filters. For the `inputCenter` key, simply pass the `blurCenterPoint` variable we created above. For the `inputAmount` simply pass in the amount of blur you wish to have, `10` seems like a good value but you can have fun with it and adjust the blur to make it pixel perfect 😄!
viennaFilter.setValue(convertedImage, forKey: kCIInputImageKey)
let viennaOutput = viennaFilter.outputImage!
zoomBlurFilter.setValue(viennaOutput, forKey: kCIInputImageKey)
zoomBlurFilter.setValue(/*#-editable-code*/<#T##blur center point##CIVector#>/*#-end-editable-code*/, forKey: "inputCenter")
zoomBlurFilter.setValue(NSNumber(value: /*#-editable-code*/<#T##blur amount##Int#>/*#-end-editable-code*/), forKey: "inputAmount")
let zoomBlurOutput = zoomBlurFilter.outputImage!.cropped(to: convertedImage.extent)
//: Now, it's time to get our image and see how it looks! For that we need to convert the `CIImage` into a `UIImage` to display it.
let cgImage = generateCGImage(from: zoomBlurOutput)!
let finalImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
//#-hidden-code
let message = PlaygroundMessageToLiveView.showChainFilteredImage(image: finalImage).playgroundValue
proxy?.send(message)
//#-end-hidden-code
//#-hidden-code
page.assessmentStatus = assessmentPoint()
//#-end-hidden-code
