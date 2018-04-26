/*:
 Hey there 😁! Today, we are going to harness the power of iOS to do truly jaw dropping things on images. Get ready for all the fun we are about to have!
 
 In this chapter, we are going to explore recognizing handwritten digits (from 0-9) that are written on a piece of paper. Yes, you heard that right, it's possible to recognize handwritten text using the power of CoreML!
 
 But before we get into the really fun stuff, we of course need to take a picture.
 - - -
 - Important:
 Make sure you write in marker!! If you write in pencil or pen, the [Machine Learning](glossary://machinelearning) model will always return a prediction of 1. This is due to the fact that the images you take will be resized to a *dramatically* smaller size which may result in a loss of quality. In order to combat this, a marker is required for bigger strokes. If you don't have a marker, don't stress 😄 - a default image will be provided! Additionally, make sure that no surrounding objects are present in the picture, just the paper and the number. Things like dark tables and background objects could trick the playground into thinking the background object is marker rather than a background object that should be excluded.
 - - -
 Before we dive in, let's run through the process step by step in order to make sure you fully grasp what we are about to do.
 
 1. Take a piece of paper and write down the digit of your choice (0-9) - without the digit, there's nothing to recognize!
 2. Using the iPad camera, we take a picture and obtain the wonderful pixels we will perform analysis on.
 3. We need to optimize our image to obtain the most accurate results. We will be using [Core Image](glossary://coreimage) to make custom image filters using the [Open GL Shading Language](glossary://opengl) to extract just the handwritten digit in black and white.
 4. Now that we have an optimized image, we are finally ready to get into the fun part - [Machine Learning](glossary://machinelearning)! We will be using a [Convolutional Neural Network](glossary://cnn) trained on a special dataset to very accurately determine the digit drawn.
 - - -
 Alright, enough talk! Let's get started 🎉!
 
 **Your Task**: Take out a piece of paper and choose any digit from 0-9 and write it down! Take a picture of your handwritten digit.
 
 - Callout(Can't access the camera or prefer the default image?):
 No worries, just *skip* this page and head over to the next page where the default image will be available.
 */

//#-hidden-code
import PlaygroundSupport

let page = PlaygroundPage.current
page.needsIndefiniteExecution = true

let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

func startCamera(desiredCameraPosition: CameraManager.CameraPosition, desiredFlashSetting: CameraManager.FlashSetting) {
    let message = PlaygroundMessageToLiveView.startHandwritingCamera(desiredCameraPosition: desiredCameraPosition, desiredFlashSetting: desiredFlashSetting).playgroundValue
    proxy?.send(message)
}

/// Handle messages from the live view.
class Listener: PlaygroundRemoteLiveViewProxyDelegate {
    func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        guard let message = PlaygroundMessageFromLiveView(playgroundValue: message) else { return }
        switch message {
        case .showHandwritingCameraSuccessMessage:
            page.assessmentStatus = .pass(message: "Wow! Good job taking that photo 😃, you must be a pro photographer! In order to get that camera running, you just had to use something called an [enumeration](glossary://enum), or enum for short, to specify the settings you desired. On the [next page](@next), let's kick the difficulty up a notch by optimizing our photo!")
        default:
            break
        }
    }
    
    func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) { /* Leave empty as we don't have to do any work if the connection is closed. */ }
}

let listener = Listener()
proxy?.delegate = listener
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, CameraManager, ., CameraPosition, ., front, back)
//#-code-completion(identifier, show, CameraManager, ., FlashSetting, ., on, off)
//#-end-hidden-code
//: Note that these settings are **desired**! Due to certain conditions such as a certain camera not being available or certain flash settings not being available, certain desired options may not be honored. Acceptable values for the camera position include `.front` or `.back` and acceptable values for the flash setting include `.on` or `.off`.
startCamera(desiredCameraPosition: /*#-editable-code*/<#T##camera position##CameraManager.CameraPosition#>/*#-end-editable-code*/, desiredFlashSetting: /*#-editable-code*/<#T##flash setting##CameraManager.FlashSetting#>/*#-end-editable-code*/)
//#-hidden-code
if let assessmentStatus = assessmentPoint() { page.assessmentStatus = assessmentStatus }
//#-end-hidden-code
