/*:
 What we did in the last chapter was **insanely** cool! We were able to identify objects in images which was very interesting. Now, we are going to build some custom filters using the [Open GL Shading Language](glossary://opengl) to make you look stunning in every image!
 
 But before we get into building, we of course need to take a picture. Smile 😄!
 - - -
 Before we dive in, let's run through the process step by step in order to make sure you fully grasp what we are about to do.
 
 1. Take a picture of yourself 🤳! If you don't like photos not to worry at all, as usual a default image can be used in the next page.
 2. Using the iPad camera, we take a picture and obtain the wonderful pixels we will perform amazing effects on.
 3. We will build our custom filter using the [Open GL Shading Language](glossary://opengl). You'll be able to see the code, and if you are really feeling creative or are an Open GL pro, you can customize the underlying code to make different and interesting effects! You'll love it ❤️!
 4. Once we've built the filter, it's time to see it in action! We will work on applying the filter to the image you took, or the default image if none was provided.
 5. Lastly, we will work on chaining multiple filters together to create a true work of art with code!
 - - -
 
 **Your Task**: Take a picture of yourself! Say cheese 🧀!
 
 - Callout(Can't access the camera or prefer the default image?):
 No worries, just *skip* this page and head over to the next page where the default image will be available.
 */

//#-hidden-code
import PlaygroundSupport

let page = PlaygroundPage.current
page.needsIndefiniteExecution = true

let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

func startCamera(desiredCameraPosition: CameraManager.CameraPosition, desiredFlashSetting: CameraManager.FlashSetting) {
    let message = PlaygroundMessageToLiveView.startFilterCamera(desiredCameraPosition: desiredCameraPosition, desiredFlashSetting: desiredFlashSetting).playgroundValue
    proxy?.send(message)
}

/// Handle messages from the live view.
class Listener: PlaygroundRemoteLiveViewProxyDelegate {
    func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        guard let message = PlaygroundMessageFromLiveView(playgroundValue: message) else { return }
        switch message {
        case .showFilterCameraSuccessMessage:
            page.assessmentStatus = .pass(message: "You look stunning 😄!! Let's make the image even cooler with the use of filters! In the [next page](@next), we will build a custom filter using the [Open GL Shading Language](glossary://opengl) which I'm sure you'll find very intersting. What are you waiting for?! Onward!")
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
