/*:
 Welcome back 😀! Hopefully, you've had a lot of fun in the last chapter where we built really awesome customized filters together.
 
 In this chapter, we are going to be using the awesomeness of [Augmented Reality](glossary://ar) to allow you to draw in 3D in the world.
 
 However, in order to start drawing in the real world, we need to turn on the camera!
 
 What are we waiting for?! Let's get to work 🎊!
 */

//#-hidden-code
import PlaygroundSupport

let page = PlaygroundPage.current

let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

func enableCamera() {
    let message = PlaygroundMessageToLiveView.enableCamera.playgroundValue
    proxy?.send(message)
}

page.assessmentStatus = assessmentPoint()
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, enableCamera())
//#-end-hidden-code
//: Call the `enableCamera()` function to start loading up the camera!
//#-editable-code
<#enable camera#>
//#-end-editable-code
