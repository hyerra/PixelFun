/*:
 Nice job getting the camera to work in the [previous page](@previous)! By now, you are probably a master of cameras haha 😀! In this page, we are going to get into the really fun part: drawing in 3D!
 - - -
 Before we dive in, let's run through the drawing process step by step in order to make sure you fully grasp what we are about to do.
 
 1. Initialize an `ARSCNView` that will allow us to place 3D content in AR.
 2. Store the previously drawn point and use that to draw a point between the previous and the current point.
 3. Apply the line color that you chose to the line that will be drawn.
 4. Enjoy the wonderful creation you've drawn in [ARKit](glossary://arkit).
 */

//#-hidden-code
import UIKit
import PlaygroundSupport

let page = PlaygroundPage.current

let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy
//#-code-completion(everything, hide)
//#-end-hidden-code
//: Choose the color you'd like to draw in below and then run your code! **Pro Tip:** You can change the color in the middle of your drawing and your previous work will be saved without resetting the drawing! Just tap the **Run My Code** button to update the color when you want to change it 🖼!
let drawingColor = /*#-editable-code*/#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)/*#-end-editable-code*/
//#-hidden-code
let message = PlaygroundMessageToLiveView.updateDrawingColor(color: drawingColor).playgroundValue
proxy?.send(message)

page.assessmentStatus = .pass(message: "Good work 😄! Your 3D drawings are ahead of your time and they look stunning! You must be a true artist 🎨. I really hope you enjoyed this playground and were able to appreicate all of the amazing technologies iOS has to offer such as `Core Image`, `Machine Learning`, and `Augmented Reality` which are very powerful and fun to use. I hope you have a good rest of your day and good luck grading the other submissions 😃!")
//#-end-hidden-code
