import Foundation
import AVFoundation

// MARK: - Handwriting Fun

/// Represents the data to be sent when requesting the camera to be started.
struct StartCameraMessageData: Codable {
    /// The camera position that should be used.
    var desiredCameraPosition: CameraManager.CameraPosition
    /// Whether or not flash should be enabled.
    var desiredFlashSetting: CameraManager.FlashSetting
}

/// Represents the data to be sent which is composed of the handwritting image that should be displayed.
struct ShowHandwrittenImageData: Codable {
    /// The data of the handwriting image that should be displayed.
    var handwritingImageData: Data
    /// The length of the animation that should occur when showing the image.
    var animationDuration: TimeInterval
}

/// Represents the data to be sent which is composed of the filtered handwriting image that should be displayed.
struct ShowHandwrittenOptimizedImageData: Codable {
    /// The data of the filtered handwriting image that should be displayed.
    var optimizedImageData: Data
    /// The length of the animation that should occur when showing the image.
    var animationDuration: TimeInterval
}

/// Represents the data to be sent which is composed of the resized handwriting image that should be displayed.
struct ShowHandwrittenResizedImageData: Codable {
    /// The data of the resized handwriting image that should be displayed.
    var resizedImageData: Data
    /// The length of the animation that should occur when showing the image.
    var animationDuration: TimeInterval
}

/// Represents the data to be sent which is composed of the confidences that the digit written is the actual digit.
struct ShowHandwritingMLResultsData: Codable {
    /// The list of confidences that the digit is correct.
    var confidences: [DigitConfidence]
}

/// Represents the data to be sent which is composed of the confidences that the object predicted is the actual object.
struct ShowObjectMLResultsData: Codable {
    /// The list of confidences that the object is correct.
    var confidences: [ObjectConfidence]
    /// The data of the image that contains the object that should be classified.
    var objectImageData: Data
}

/// Represents the data to be sent which is composed of the filtered image that should be displayed.
struct ShowCustomFilteredImageData: Codable {
    /// The image that should be displayed.
    var imageData: Data
}

/// Represents the data to be sent which is composed of the filtered image that should be displayed.
struct ShowChainFilteredImageData: Codable {
    /// The image that should be displayed.
    var imageData: Data
}

/// Represents the data to be sent when requesting to update the drawing color.
struct UpdateDrawingColorData: Codable {
    /// The color that should be used to draw.
    var color: CodableColor
}
