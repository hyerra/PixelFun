import Foundation
import CoreImage
import UIKit

/// Represents an object that can detect facial features in an image.
public class FacialFeatures: NSObject {
    
    /// The image of the subjects.
    var image: CIImage
    /// The context used for the image processing.
    var context = CIContext(options: [kCIContextCacheIntermediates: false])
    
    // MARK: - Initialization
    
    /// Initializes an instance of `FacialFeatures` with the image specified.
    ///
    /// - Parameter image: A `CIImage` object with the image used for detecting the face features.
    public init(image: CIImage) {
        self.image = image
    }
    
    public convenience init?(image: UIImage) {
        guard let ciImage = CIImage(image: image) else { return nil }
        self.init(image: ciImage)
    }
    
    /// Specifies the various features in a face.
    ///
    /// - notSmiling: Specifies the user is not smiling 😟.
    /// - smiling: Specifies the user is smiling 😁!
    /// - leftEyeClosed: Specifies the user's left eye is closed 😉!
    /// - rightEyeClosed: Specifies the user's right eye is closed 😉!
    public enum FacialFeature {
        case notSmiling
        case smiling
        case leftEyeClosed
        case rightEyeClosed
    }
    
    /// Specifies the accuracy that should be used when detecting the face features. High Accuracy -> Better Results; Low Accuracy -> Better Performance
    public enum Accuracy {
        case high
        case low
        
        var rawValue: String {
            switch self {
            case .high: return CIDetectorAccuracyHigh
            case .low: return CIDetectorAccuracyLow
            }
        }
    }
    
    // MARK: - Detect Face Features
    
    /// Detects the location of the subjects' faces in the image.
    ///
    /// - Parameter accuracy: The accuracy of the face detection.
    /// - Returns: A `CGRect` that specifies where the face is located relative to the `Core Image` coordinate space.
    public func detectLocationOfFaces(withAccuracy accuracy: Accuracy) -> [CGRect]? {
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: [CIDetectorAccuracy: accuracy.rawValue])
        guard let faces = faceDetector?.features(in: image, options: nil) else { return nil }
        
        let locationsOfFaces = faces.map { return $0.bounds }
        return locationsOfFaces
    }
    
    /// Determines if the face has a smile or not.
    ///
    /// - Parameter accuracy: The accuracy of the face detection.
    /// - Returns: `notSmiling` if the subject is not smiling and `smiling` if the subject is smiling.
    public func detectSmile(withAccuracy accuracy: Accuracy) -> [FacialFeature]? {
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: [CIDetectorAccuracy: accuracy.rawValue])
        guard let faces = faceDetector?.features(in: image, options: [CIDetectorSmile: true]) as? [CIFaceFeature] else { return nil }
        
        let facesSmiling: [FacialFeature] = faces.map { return $0.hasSmile ? .smiling : .notSmiling }
        return facesSmiling
    }
    
    /// Detects whether the eyes are closed in an image.
    ///
    /// - Parameter accuracy: The accuracy of the face detection.
    /// - Returns: Whether or not the left/right eye is closed for *each* face.
    public func detectEyesClosed(withAccuracy accuracy: Accuracy) -> [[FacialFeature]]? {
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: [CIDetectorAccuracy: accuracy.rawValue])
        guard let faces = faceDetector?.features(in: image, options: [CIDetectorEyeBlink: true]) as? [CIFaceFeature] else { return nil }
        
        var facesFeatures: [[FacialFeature]] = []
        
        for face in faces {
            var faceFeatures: [FacialFeature] = []
            
            if face.leftEyeClosed { faceFeatures.append(.leftEyeClosed) }
            if face.rightEyeClosed { faceFeatures.append(.rightEyeClosed) }
            facesFeatures.append(faceFeatures)
        }
        
        return facesFeatures
    }
    
    /// Detects whether the eyes are closed in an image AND whether the user is smiling or not!
    ///
    /// - Parameter accuracy: The accuracy of the face detection.
    /// - Returns: Whether or not the subject is smiling and if the left/right eye is closed for *each* face.
    public func detectFacialExpressions(withAccuracy accuracy: Accuracy) -> [[FacialFeature]]? {
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: [CIDetectorAccuracy: accuracy.rawValue])
        guard let faces = faceDetector?.features(in: image, options: [CIDetectorSmile: true, CIDetectorEyeBlink: true]) as? [CIFaceFeature] else { return nil }
        
        var facesFeatures: [[FacialFeature]] = []
        
        for face in faces {
            var faceFeatures: [FacialFeature] = []
            
            if face.hasSmile { faceFeatures.append(.smiling) }
            if face.leftEyeClosed { faceFeatures.append(.leftEyeClosed) }
            if face.rightEyeClosed { faceFeatures.append(.rightEyeClosed) }
            facesFeatures.append(faceFeatures)
        }
        
        return facesFeatures
    }
}
