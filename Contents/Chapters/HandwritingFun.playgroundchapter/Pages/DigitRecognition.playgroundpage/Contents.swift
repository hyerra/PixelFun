/*:
 Now that we've optimized our images, we are so close to winning that money 💵! You glance over at your co-worker who is only on image 100 out of 5000; victory is in sight 🤺!
 
 Now that our images look good and our [machine learning](glossary://machinelearning) model is built, it's time to harness the power of [Core ML](glossary://coreml) and get the task done in record breaking time ⏰.
 
 - - -
 Before we dive in, let's run through the process step by step in order to make sure you fully grasp what we are about to do.
 
 1. Load the optimized image containing the handwritten digit from the previous step.
 2. Obtain or create a [Core ML](glossary://coreml) model. In our case we will be using a model that I created for us which was trained off of the MNIST dataset, so we will be using that 🤓!
 3. Using the [Vision](glossary://vision) framework, load our model into code, pass our image into the model, and predict what the number will be using our [Convolutional Neural Network](glossary://cnn).
 4. Celebrate our earnings and feel proud of the tremendous work we've accomplished together 😃!
 */

//#-hidden-code
import PlaygroundSupport
import Vision
import UIKit

let page = PlaygroundPage.current

let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

// Register the filters with core image.
FilterConstructor.registerFilters()

func loadHandwritingImage() -> UIImage {
    if let playgroundImage = PlaygroundKeyValueStore.current["handwritingImage"], case let .data(imageData) = playgroundImage, let image = UIImage(data: imageData) {
        return image
    } else {
        return #imageLiteral(resourceName: "handwritingimage")
    }
}

func optimize(_ handwritingImage: UIImage, withBlurRadius radius: NSNumber = 190) -> UIImage {
    let handwritingExtractor = HandwritingExtractor(handwritingImage: handwritingImage, blurRadius: radius)
    let optimizedImage = handwritingExtractor.processImage()!
    return optimizedImage
}

func resize(_ optimizedImage: UIImage) -> UIImage {
    let requiredSize = CGSize(width: 28, height: 28)
    let resizedImage = optimizedImage.scaledToFill(size: requiredSize)
    return resizedImage
}

func loadOptimizedHandwritingImage() -> UIImage {
    if let optimizedPlaygroundImage = PlaygroundKeyValueStore.current["optimizedHandwritingImage"], case let .data(optimizedImageData) = optimizedPlaygroundImage, let optimizedImage = UIImage(data: optimizedImageData) {
        return optimizedImage
    } else {
        let handwritingImage = loadHandwritingImage()
        let optimizedImage = optimize(handwritingImage)
        let resizedImage = resize(optimizedImage)
        return resizedImage
    }
    return #imageLiteral(resourceName: "handwritingimage")
}

let mnistCompletionHandler: (VNRequest, Error?) -> Void = { request, error in
    guard let observations = request.results as? [VNClassificationObservation] else { return }
    
    var digitConfidences: [DigitConfidence] = []

    for observation in observations {
        guard let digit = Int(observation.identifier) else { continue }
        let digitConfidence = DigitConfidence(digit: digit, confidence: observation.confidence)
        digitConfidences.append(digitConfidence)
    }

    let message = PlaygroundMessageToLiveView.showHandwritingMLResults(confidences: digitConfidences).playgroundValue
    proxy?.send(message)
}

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, loadOptimizedHandwritingImage())
//#-code-completion(identifier, show, MNIST, ., model)
//#-code-completion(identifier, show, mnist)
//#-end-hidden-code
//: Let's perform our first step! We need to load our optimized handwriting image! Try calling the `loadOptimizedHandwritingImage()` function.
let optimizedHandwritingImage = /*#-editable-code*/<#load optimized handwriting image#>/*#-end-editable-code*/
//: Next, we have to load up our model into code. Try typing `MNIST().model` to load up our model 🧙‍♂️.
let mnist = try! VNCoreMLModel(for: /*#-editable-code*/<#T##MNIST machine learning model##MLModel#>/*#-end-editable-code*/)
//: After loading up our model, we need to create a request to [Vision](glossary://vision) to determine what number is in our image! Try passing in the `mnist` constant to create the request!
let request = VNCoreMLRequest(model: /*#-editable-code*/<#T##MNIST machine learning model##VNCoreMLModel#>/*#-end-editable-code*/, completionHandler: mnistCompletionHandler)
//: Finally, we create a [Vision](glossary://vision) handler and pass in our handwritten image to the handler.
let handler = VNImageRequestHandler(cgImage: optimizedHandwritingImage.cgImage!, orientation: CGImagePropertyOrientation(uiOrientation: optimizedHandwritingImage.imageOrientation))
//: Perform the request!
try! handler.perform([request])
//#-hidden-code
page.assessmentStatus = assessmentPoint()
//#-end-hidden-code
