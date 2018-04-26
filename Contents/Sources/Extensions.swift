import UIKit
import SceneKit
import ImageIO

public extension UIImageView {
    
    /// Changes the image from the current image to a new image with an optional, fun animation.
    ///
    /// - Parameters:
    ///   - newImage: The image that should be changed.
    ///   - animated: Whether or not there should be an animation.
    ///   - duration: How long the animation should take.
    ///   - completion: A completion handler that will be executed after the animation ends. This handler has a `Bool` value that indicates whether or not the animations actually finished before the completion handler was called.
    func changeImage(to newImage: UIImage, animated: Bool, duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        if animated {
            UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: { self.image = newImage }, completion: completion)
        } else {
            image = newImage
            if let completion = completion { completion(true) }
        }
    }
}

public extension Collection {
    
    /// Returns the element at the specified index only it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension CGImagePropertyOrientation {
    
    /// Initializes a new instance of `CGImagePropertyOrientation` from `UIImageOrientation`.
    ///
    /// - Parameter uiOrientation: The `UIImageOrientation` property you want to create the `CGImagePropertyOrientation` property from.
    init(uiOrientation: UIImageOrientation) {
        switch uiOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}

public extension Float {
    
    /// Formats the number to a percent for display.
    ///
    /// - Returns: The number to convert to a percent.
    func formatToPercent() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        let number = NSNumber(value: self)
        return numberFormatter.string(from: number)
    }
}

extension UIImage {
    
    /// Rotates the image by a specified amount of degrees
    ///
    /// - Parameter degrees: The degrees to rotate the image by.
    /// - Returns: The rotated image or if there was an issue, the original image.
    func rotated(by degrees: CGFloat) -> UIImage {
        guard let cgImage = self.cgImage else { return self }
        let convertedImage = CIImage(cgImage: cgImage)
        let radians = degrees * (CGFloat.pi / CGFloat(180))
        
        let transformFilter = CIFilter(name: "CIAffineTransform")!
        let rotationTransform = CGAffineTransform(rotationAngle: radians)
        
        transformFilter.setValue(convertedImage, forKey: "inputImage")
        transformFilter.setValue(rotationTransform, forKey: "inputTransform")
        guard let outputImage = transformFilter.outputImage else { return self }
        
        let context = CIContext()
        guard let rotatedCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return self }
        
        return UIImage(cgImage: rotatedCGImage)
    }
}
