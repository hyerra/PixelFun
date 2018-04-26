import Foundation

/// The confidence the machine learning model has that the predicted object is the actual object.
public struct ObjectConfidence: Codable {
    /// The object that the confidence is for.
    public var object: String
    /// The confidence the model has that the object is correct.
    public var confidence: Float
    
    public init(object: String, confidence: Float) {
        self.object = object
        self.confidence = confidence
    }
}

// MARK: - Comparable

extension ObjectConfidence: Comparable {
    public static func <(lhs: ObjectConfidence, rhs: ObjectConfidence) -> Bool {
        return lhs.confidence < rhs.confidence
    }
    
    public static func ==(lhs: ObjectConfidence, rhs: ObjectConfidence) -> Bool {
        return lhs.confidence == rhs.confidence
    }
}

