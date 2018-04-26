import PlaygroundSupport

public func assessmentPoint() -> PlaygroundPage.AssessmentStatus {
    let contents = PlaygroundPage.current.text
    
    let enableCameraHint = "Make sure you are calling the `enableCamera()` function."
    let solution = "`enableCamera()`"
    
    guard contents.contains("enableCamera()") else { return .fail(hints: [enableCameraHint], solution: solution) }
    
    return .pass(message: "Nice Work 😄! Using [Augmented Reality](glossary://ar), we are able to see many interesting things like planes and objects in the scene! On the [next page](@next), we will explore 3D drawing in the real world using AR! It'll be so much fun, and you'll be drawing amazing things in the real world 🎨.")
}
