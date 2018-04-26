import PlaygroundSupport

public func assessmentPoint() -> PlaygroundPage.AssessmentStatus {
    let contents = PlaygroundPage.current.text
    
    let resizedImageHint = "Make sure you are setting the width and height to 227."
    let modelHint = "Make sure you are instantiating the model properly by typing `SqueezeNet()`."
    let solution = "`227`; `227`; `SqueezeNet()`"
    
    let lines = contents.components(separatedBy: .newlines).filter { !$0.isEmpty }
    
    let resizedImageLines = lines.filter { $0.hasPrefix("let resizedImage") }
    let modelLines = lines.filter { $0.hasPrefix("let model") }
    
    guard let resizedImageLine = resizedImageLines.first else { fatalError("Unexpected playground contents.") }
    guard let modelLine = modelLines.first else { fatalError("Unexpected playground contents.") }
    
    let amountOf227 = resizedImageLine.components(separatedBy: "227").count - 1
    guard amountOf227 == 2 else { return .fail(hints: [resizedImageHint, modelHint], solution: solution) }
    
    guard modelLine.contains("SqueezeNet()") else { return .fail(hints: [resizedImageHint, modelHint], solution: solution) }
    
    return .pass(message: "Nice work, you should feel proud of yourself 🎉! We used a [Core ML](glossary://coreml) model to determine what an object was in an image! iOS is like a magical platform that can do amazing things with pixels as you have seen so far. Next up, we are going to dive into the world of filters.. yup kinda like the ones on the Camera app!")
}
