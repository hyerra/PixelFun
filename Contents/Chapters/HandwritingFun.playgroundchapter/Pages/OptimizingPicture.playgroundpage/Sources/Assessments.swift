import PlaygroundSupport

public func assessmentPoint() -> PlaygroundPage.AssessmentStatus {
    let contents = PlaygroundPage.current.text
    
    let showLineHint = "Make sure you are using the **handwriting image** and not the **optimized image** when calling the `show` function."
    let optimizedLineHint = "Make sure you are using the **handwriting image** and not the **optimized image** when calling the `optimize` function."
    let resizeLineHint = "Make sure you are using the **optimized image** and not the **handwriting image** when calling the `resize` function."
    let solution = "`show(handwritingImage)`; `let optimizedImage = optimize(handwritingImage, withBlurRadius: 190)`; `resize(optimizedImage)`"
    
    let lines = contents.components(separatedBy: .newlines).filter { !$0.isEmpty }
    
    let showLines = lines.filter { $0.hasPrefix("show") }
    let optimizedLines = lines.filter { $0.hasPrefix("let optimizedImage") }
    let resizeLines = lines.filter { $0.hasPrefix("let resizedImage") }
    
    guard let showLine = showLines.first else { fatalError("Unexpected playground contents.") }
    guard let optimizedLine = optimizedLines.first else { fatalError("Unexpected playground contents.") }
    guard let resizeLine = resizeLines.first else { fatalError("Unexpected playground contents.") }
    
    guard showLine.contains("handwritingImage") else { return .fail(hints: [showLineHint, optimizedLineHint, resizeLineHint], solution: solution) }
    guard optimizedLine.contains("handwritingImage") else { return .fail(hints: [showLineHint, optimizedLineHint, resizeLineHint], solution: solution) }
    guard resizeLine.contains("optimizedImage") else { return .fail(hints: [showLineHint, optimizedLineHint, resizeLineHint], solution: solution) }
    
    return .pass(message: "Yay, nice job 🙌! At this rate, you are going to be winning that cash in no time 💵! Now that we've finished optimizing our image, let's actually determine the handwritten number contained within the image using our [Convolutional Neural Network](glossary://cnn) on the [next page](@next).")
}

