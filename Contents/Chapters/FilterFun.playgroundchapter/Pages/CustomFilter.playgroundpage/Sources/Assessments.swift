import PlaygroundSupport

public func assessmentPoint() -> PlaygroundPage.AssessmentStatus {
    let contents = PlaygroundPage.current.text
    
    let viennaFilterHint = "Make sure you are entering the `kernelText` variable."
    let convertedImageHint = "Make sure you are referencing the `image` variable created above."
    let solution = "`kernelText`; `image`"
    
    let lines = contents.components(separatedBy: .newlines).filter { !$0.isEmpty }
    
    let viennaFilterLines = lines.filter { $0.hasPrefix("let viennaFilter") }
    let convertedImageLines = lines.filter { $0.hasPrefix("let convertedImage") }
    
    guard let viennaFilterLine = viennaFilterLines.first else { fatalError("Unexpected playground contents.") }
    guard let convertedImageLine = convertedImageLines.first else { fatalError("Unexpected playground contents.") }
    
    guard viennaFilterLine.contains("kernelText") else { return .fail(hints: [viennaFilterHint, convertedImageHint], solution: solution) }
    guard convertedImageLine.contains("image") else { return .fail(hints: [viennaFilterHint, convertedImageHint], solution: solution) }
    
    return .pass(message: "Yayyyy! Nice job creating an custom image filter that looks stunning 📸! Hopefully, you enjoy the filter and the work of art we just created 👨‍🎨! If you are feeling creative, feel free to edit the `kernelText` to build some even cooler effects! In the next page, we will be detecting where faces are located in an image and chaining filters together. It'll be an awesome time so let's head onto the [next page](@next)!")
}
