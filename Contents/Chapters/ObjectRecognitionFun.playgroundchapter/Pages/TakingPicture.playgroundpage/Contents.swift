/*:
 Welcome back 😁! Hopefully, you learned a lot and enjoyed the awesomeness of recognizing handwritten digits from the last chapter!
 
 In this chapter, we are going to do something similar with [Core ML](glossary://coreml), but in my opinion way cooler!
 
 In this chapter we are going to (drumroll, wait for it!): Recognize objects in images! By the end of this chapter we'll be detecting what the object in an image such as an orange, watch, etc. Doesn't this sound super cool?!
 - - -
 Before we dive in, let's run through the process step by step in order to make sure you fully grasp what we are about to do.
 
 1. Find an object - it must be a soda bottle, bagel, hourglass, or television - and take a picture of it!
 2. Run our [Core ML](glossary://coreml) model on the object. This time; however, we won't be relying on [Vision](glossary://vision) to help us out. Instead, we will just be using [Core ML](glossary://coreml) and passing our images directly via the use of a [CVPixelBuffer](glossary://pixelbuffer). This will help demonstrate the options you have when recognizing images.
 - - -
 - Important:
 Unfortunately, the size of this model had to be limited to adhere to the 25 MB size limit of the playground. As a result, this model is trained only on a limited amount of items. As a result, a soda bottle, bagel, hourglass, and television are a few of the items it will work on along with a couple other more exotic items you may not be able to take a picture of. If you have access to the items listed above, take a picture 📸! If you don't, no worries! Sample images will be provided on the next screen which will work great with our model!
 - - -
 Alright, enough talk! Let's get started 🎉!
 
 **Your Task**: Take a quick stroll and find any object you like and take a picture of it!
 
 - Callout(Can't access the camera or prefer to use a sample image?):
 No worries, just *skip* this page and head over to the next page where sample images will be available!
 */

//#-hidden-code
import PlaygroundSupport

let page = PlaygroundPage.current
page.needsIndefiniteExecution = true

let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

func startCamera(desiredCameraPosition: CameraManager.CameraPosition, desiredFlashSetting: CameraManager.FlashSetting) {
    let message = PlaygroundMessageToLiveView.startObjectCamera(desiredCameraPosition: desiredCameraPosition, desiredFlashSetting: desiredFlashSetting).playgroundValue
    proxy?.send(message)
}

/// Handle messages from the live view.
class Listener: PlaygroundRemoteLiveViewProxyDelegate {
    func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        guard let message = PlaygroundMessageFromLiveView(playgroundValue: message) else { return }
        switch message {
        case .showObjectCameraSuccessMessage:
            page.assessmentStatus = .pass(message: "Sweet!! Now that we have our photo, on the [next page](@next) we will detect the object contained within the image you took. Feels like magic, huh 🎩!")
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

