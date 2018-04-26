import PlaygroundSupport

public func assessmentPoint() -> PlaygroundPage.AssessmentStatus {
    let contents = PlaygroundPage.current.text
    
    let optimizedImageHint = "Call the `loadOptimizedHandwritingImage()` function to load an image for the `optimizedHandwritingImage` variable."
    let mnistHint = "Make sure you are loading the model by calling: `MNIST().model`."
    let requestHint = "Make sure you are creating the request properly by referencing the `mnist` variable."
    let solution = "`loadOptimizedHandwritingImage()`; `MNIST().model`; `mnist`"
    
    let lines = contents.components(separatedBy: .newlines).filter { !$0.isEmpty }
    
    let optimizedImageLines = lines.filter { $0.hasPrefix("let optimizedHandwritingImage") }
    let mnistLines = lines.filter { $0.hasPrefix("let mnist =") }
    let requestLines = lines.filter { $0.hasPrefix("let request") }
    
    guard let optimizedImageLine = optimizedImageLines.first else { fatalError("Unexpected playground contents.") }
    guard let mnistLine = mnistLines.first else { fatalError("Unexpected playground contents.") }
    guard let requestLine = requestLines.first else { fatalError("Unexpected playground contents.") }
    
    guard optimizedImageLine.contains("loadOptimizedHandwritingImage()") else { return .fail(hints: [optimizedImageHint, mnistHint, requestHint], solution: solution) }
    guard mnistLine.contains("MNIST().model") else { return .fail(hints: [optimizedImageHint, mnistHint, requestHint], solution: solution) }
    guard requestLine.contains("mnist") else { return .fail(hints: [optimizedImageHint, mnistHint, requestHint], solution: solution) }
    
    return .pass(message: "Woohoo 🎉! We successfully used [Core ML](glossary://coreml) to make our first prediction together, and you should feel proud! Now with a wonderfully written model and image optimization code, you proudly get to work applying it to all the 5000 images he gives you. With all your co-workers awestruck with how fast you worked, your employer awards you the $2000 💵! (P.S. Hopefully the prediction was right 😅. If not, feel free to reset the playground and **skip** the first page in order to use the default image which should produce an accurate prediction.)")
}
