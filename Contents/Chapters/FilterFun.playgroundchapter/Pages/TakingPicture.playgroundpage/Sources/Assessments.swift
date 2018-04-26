import PlaygroundSupport

public func assessmentPoint() -> PlaygroundPage.AssessmentStatus? {
    let contents = PlaygroundPage.current.text
    
    let positionHint = "Make sure you are inputing either .front or .back for the camera position."
    let flashHint = "Make sure you are inputing .on or .off for the flash setting."
    let solution = "`startCamera(desiredCameraPosition: .back, desiredFlashSetting: .off)`"
    
    let lines = contents.components(separatedBy: .newlines).filter { !$0.isEmpty }
    
    let startCameraLines = lines.filter { $0.hasPrefix("startCamera") }
    guard let startCameraLine = startCameraLines.first else { fatalError("Unexpected playground contents.") }
    
    guard let positionRange = startCameraLine.range(of: ".front") ?? startCameraLine.range(of: ".back") else { return .fail(hints: [positionHint, flashHint], solution: solution) }
    guard let flashRange = startCameraLine.range(of: ".on") ?? startCameraLine.range(of: ".off") else { return .fail(hints: [positionHint, flashHint], solution: solution) }
    guard positionRange.upperBound < flashRange.lowerBound else { return .fail(hints: [positionHint, flashHint], solution: solution) }
    
    // The code looks good so far but we won't return a pass status until the user takes the picture.
    return nil
}
