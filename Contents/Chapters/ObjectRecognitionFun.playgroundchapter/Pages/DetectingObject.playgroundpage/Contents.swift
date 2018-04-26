/*:
 Now that we've taken our images, it's time to get to the fun stuff! It's time to recognize the images 🌁 using the power of [Core ML](glossary://coreml)!
 - - -
 Once the code has been run, the live view will show you what the [machine learning](glossary://machinelearning) model thought the object was along with other potential items it could've been sorted by likelihood and confidence that it could've been that object.
 - - -
 Before we dive in, let's run through the process step by step in order to make sure you fully grasp what we are about to do.
 
 1. Load the image containing the object from the previous step (or use a sample image if you prefer).
 2. Load the [Core ML](glossary://coreml) model. In this case, I've obtained one from [Apple's website](https://developer.apple.com/machine-learning/)!
 3. Load up our model, convert our image to a [CVPixelBuffer](glossary://pixelbuffer), and predict what the object is through [Core ML](glossary://coreml).
 4. Feel proud of all the cool tech we just implemented in this chapter 😃!
 */

//#-hidden-code
import PlaygroundSupport
import Vision
import UIKit

let page = PlaygroundPage.current

let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

func loadObjectImage() -> UIImage {
    if let playgroundImage = PlaygroundKeyValueStore.current["objectImage"], case let .data(imageData) = playgroundImage, let image = UIImage(data: imageData) {
        return image
    } else {
        return #imageLiteral(resourceName: "jellyfish")
    }
}

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, loadObjectImage())
//#-code-completion(literal, show, 227)
//#-code-completion(identifier, show, SqueezeNet)
//#-end-hidden-code
//: First, we need to load up the picture you took on the previous page. If you would like to use a sample image, choose it from the image picker; otherwise, to use your image you took on the previous page try calling the `loadObjectImage()` function.
let objectImage = /*#-editable-code*/<#T##object image##UIImage#>/*#-end-editable-code*/
//: After the image has been loaded up, it needs to be scaled to a size of 227x227 for the model! Try typing `227` in for the width and height below!
let resizedImage = objectImage.scaledToFill(size: CGSize(width: /*#-editable-code*/<#T##width##CGFloat#>/*#-end-editable-code*/, height: /*#-editable-code*/<#T##height##CGFloat#>/*#-end-editable-code*/))
//: Now that we have the image, we need to load up the [Core ML](glossary://coreml) model. Try calling `SqueezeNet()` to instantiate our model!
let model = /*#-editable-code*/<#SqueezeNet model#>/*#-end-editable-code*/
//: Generate the predictions based off of the model created above. In order to do this, we must pass our image in as a `CVPixelBuffer`.
let predictions = try! model.prediction(image: resizedImage.pixelBuffer!).classLabelProbs
print(predictions)
//: With our predictions, all we have to do now is map them to our `ObjectConfidence` structure to use within the playground. Congrats, we now have our results 🎉!
let objectConfidences = predictions.map { ObjectConfidence(object: $0.0, confidence: Float($0.1)) }
//#-hidden-code
let message = PlaygroundMessageToLiveView.showObjectMLResults(confidences: objectConfidences, objectImage: objectImage).playgroundValue
proxy?.send(message)
//#-end-hidden-code
//#-hidden-code
page.assessmentStatus = assessmentPoint()
//#-end-hidden-code
