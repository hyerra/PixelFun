import Foundation

/// The confidence the machine learning model has that a digit is the correct digit.
public struct DigitConfidence: Codable {
    /// The digit that the confidence is for.
    public var digit: Int
    /// The confidence the model has that the digit is correct.
    public var confidence: Float
    
    public init(digit: Int, confidence: Float) {
        self.digit = digit
        self.confidence = confidence
    }
}

// MARK: - Comparable

extension DigitConfidence: Comparable {
    public static func <(lhs: DigitConfidence, rhs: DigitConfidence) -> Bool {
        return lhs.confidence < rhs.confidence
    }
    
    public static func ==(lhs: DigitConfidence, rhs: DigitConfidence) -> Bool {
        return lhs.confidence == rhs.confidence
    }
}
