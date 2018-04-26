import PlaygroundSupport

public func assessmentPoint() -> PlaygroundPage.AssessmentStatus {
    let contents = PlaygroundPage.current.text
    
    let firstFaceRectHint = "Make sure you are entering the `.high` or `.low`."
    let blurCenterHint = "Make sure you are referencing the `blurCenterPoint` for the `inputCenter`."
    let solution = "`.high`; `blurCenterPoint`"
    
    let lines = contents.components(separatedBy: .newlines).filter { !$0.isEmpty }
    
    let firstFaceRectLines = lines.filter { $0.hasPrefix("let firstFaceRect") }
    let blurCenterLines = lines.filter { $0.hasPrefix("zoomBlurFilter") && $0.contains("inputCenter") }
    
    guard let firstFaceRectLine = firstFaceRectLines.first else { fatalError("Unexpected playground contents.") }
    guard let blurCenterLine = blurCenterLines.first else { fatalError("Unexpected playground contents.") }
    
    guard firstFaceRectLine.contains("high") || firstFaceRectLine.contains("low") else { return .fail(hints: [firstFaceRectHint, blurCenterHint], solution: solution) }
    guard blurCenterLine.contains("blurCenterPoint") else { return .fail(hints: [firstFaceRectHint, blurCenterHint], solution: solution) }
    
    return .pass(message: "Wowww! That blur really adds a bang to that filter 🧙‍♂️! You show the boss the images that you produced with that filter and he loves it. He thanks you for your hard work and gives you $100 as a thank you gift! In the next chapter, we will be having lots of fun with [Augmented Reality](glossary://ar), so get ready!")
}

