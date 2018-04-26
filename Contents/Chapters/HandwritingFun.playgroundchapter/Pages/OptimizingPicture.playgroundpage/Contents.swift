/*:
 Great job taking that photo on the [previous page](@previous)! You are a true [AVFoundation](glossary://avfoundation) expert, so give yourself a pat on the back 👏!
 
 Your boss, himself, even asks you for your code that you've written to help him with one of his tasks. You gladly hand it over and feel proud of all the hard work you've done. However, you begin starting to feel curious about what he's doing as you've seen him taking pictures all day. You just sigh; however, and get ready to go home as the workday is almost over. The next morning, your boss organizes a meeting for all employees and says, "I've taken 100,000 pictures that each contain a digit from 0-9 in them." Immediately, you start thinking this guy is crazy (not entirely wrong haha); however, as a respectful employee, you keep listening. He goes onto say that he is going to give each employee 5000 images and that for each image they have to classify the number in the image as a digit from 0-9. However, he throws a twist and says, "Whoever completes this task first wins $2000."
 
 Everybody races out of the room and hurries to their desktop to find an email containing their images. You see everyone opening up and classifying images one by one. You automatically think that these employees are as crazy as the boss! Thankfully, you are smarter because you are an [AVFoundation](glossary://avfoundation) expert and are extremely knowledgable in [machine learning](glossary://machinelearning) with [Core ML](glossary://coreml).
 
 You calmly start working on building a machine learning model and training it. However, an immediate issue comes up - these images have shadows, aren't the right size for the model, etc. What do you do?! You start panicking thinking that you are going to lose for sure now! Not to worry, there's just a couple steps we have to take to make sure our model gets clear, filtered images that are optimized and will perform well with the model you just created.
 
 What are you waiting for - we have a challenge to win! Let's get started and win some money 💵!
 - - -
 - Important:
 Because the images will be eventually resized to a very small (28x28) pixel size, quality is lost in this process, *dramatically*. In order to combat this, it is very important that you wrote in marker on the previous page! If you didn't write in marker, please go back and retake the picture for the best results. If you wrote in marker or are using the default image, let's get started! Also, when you run the playground, ensure that no background objects like dark tables, pens, etc. are included in the picture.
 - - -
 In order to truly optimize our photo, I have included a custom [Core Image](glossary://coreimage) filter which involves the use of the [Open GL Shading Language](glossary://opengl). Here is the code I wrote to create the custom filter:
 ````
 kernel vec4 adaptiveThresholdFilter(sampler originalImage, sampler blurredImage)
 {
    vec2 textureCoordinate = samplerCoord(originalImage);
    vec2 textureCoordinate2 = samplerCoord(blurredImage);
 
    highp float localLuminance = sample(originalImage, textureCoordinate).r;
    highp float blurredInput = sample(blurredImage, textureCoordinate2).r;
    highp float thresholdResult = step(blurredInput - 0.05, localLuminance);
    return vec4(vec3(thresholdResult), 1.0);
 }
 ````
 - - -
 Before we dive in, let's run through the optimization process step by step in order to make sure you fully grasp what we are about to do.
 
 1. Load the image containing the handwritten digit, either the one you took or the default one will be loaded depending on if the one you took is available.
 2. Next, for visualization purposes, we will display the image that was taken in a `UIImageView`.
 3. After displaying the image, we need to optimize the image by getting rid of all the *gunk*. (Very technical right haha?) In all seriousness though, in order to obtain the best results, we need to get rid of things like shadows and noise so that the image includes just the digit.
 4. Unfortunately, our [Core ML](glossary://coreml) model is a bit picky and wants the image in a certain (28x28) size! Unfortunately, our image doesn't match the required size so we need to resize it.
 - - -
 **What does this playground page demonstrate?**
 1. The use of the [Open GL Shading Language](glossary://opengl) and `CIKernel` to author custom filters.
 2. Working with the [Core Image](glossary://coreimage) framework to apply our filters to the images with very high performance.
 3. How to resize images in an effective manor to fit the constraints of our [machine learning](glossary://machinelearning) model.
 */

//#-hidden-code
import PlaygroundSupport
import UIKit

let page = PlaygroundPage.current
page.needsIndefiniteExecution = true

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

func show(_ handwritingImage: UIImage) {
    let message = PlaygroundMessageToLiveView.showHandwrittenImage(handwritingImage: #imageLiteral(resourceName: "handwritingimage"), animationDuration: 3).playgroundValue
    proxy?.send(message)
    sleep(3)
}

func optimize(_ handwritingImage: UIImage, withBlurRadius radius: NSNumber = 190) -> UIImage {
    let handwritingExtractor = HandwritingExtractor(handwritingImage: handwritingImage, blurRadius: radius)
    let optimizedImage = handwritingExtractor.processImage()!
    let message = PlaygroundMessageToLiveView.showHandwrittenOptimizedImage(optimizedImage: optimizedImage, animationDuration: 3).playgroundValue
    proxy?.send(message)
    sleep(3)
    return optimizedImage
}

func resize(_ optimizedImage: UIImage) -> UIImage {
    let requiredSize = CGSize(width: 28, height: 28)
    let resizedImage = optimizedImage.scaledToFill(size: requiredSize)
    let message = PlaygroundMessageToLiveView.showHandwrittenResizedImage(resizedImage: resizedImage, animationDuration: 3).playgroundValue
    proxy?.send(message)
    return resizedImage
}
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, loadHandwritingImage())
//#-code-completion(identifier, show, handwritingImage)
//#-code-completion(identifier, show, optimizedImage)
//#-end-hidden-code
//: If you would like to use the image you took on the previous page, call the `loadHandwritingImage()` function here. Otherwise, you are welcome to choose the default image from the image picker.
let handwritingImage = /*#-editable-code*/<#T##handwriting image##UIImage#>/*#-end-editable-code*/
//: Executes the first step of the process: showing the image you took! Try typing in `handwritingImage` to access the constant above!
show(/*#-editable-code*/<#handwriting image#>/*#-end-editable-code*/)
//: Executes the second step of the process: getting rid of the gunk! Based on extensive testing, 190 seems to be the best blur radius value to pass into the `optimize` function. However, you can fine tune the amount of blur radius applied so that ideally the only part that's white in the image is the number and the rest is all black. As a general rule of thumb, if the blur radius value is lower the filter allows more to pass through so darker shadows may get in and if the blur radius value is higher, the filter allows less to pass through and some of the handwriting may disappear.
let optimizedImage = optimize(/*#-editable-code*/<#handwriting image#>/*#-end-editable-code*/, withBlurRadius: /*#-editable-code*/190/*#-end-editable-code*/)
//: Try typing in `optimizedImage` to access the optimized version of your image.
let resizedImage = resize(/*#-editable-code*/<#optimized image#>/*#-end-editable-code*/)
//#-hidden-code
let assessmentStatus = assessmentPoint()
switch assessmentStatus {
case .pass:
    guard let resizedImageData = UIImagePNGRepresentation(resizedImage) else { break }
    PlaygroundKeyValueStore.current["optimizedHandwritingImage"] = .data(resizedImageData)
case .fail:
    break
}
page.assessmentStatus = assessmentStatus
//#-end-hidden-code
