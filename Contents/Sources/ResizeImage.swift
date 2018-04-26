import UIKit

public extension UIImage {
    
    /// Scales the image to fill the specified size, preserving aspect ratio.
    ///
    /// - Parameter newSize: The size the image should be filled to.
    /// - Returns: The image filled to the specified size.
    func scaledToFill(size newSize: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth: CGFloat = newSize.width / self.size.width
        let aspectHeight: CGFloat = newSize.height / self.size.height
        let aspectRatio: CGFloat = max(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    
    /// Scales the image to fit the specified size, preserving aspect ratio.
    ///
    /// - Parameter newSize: The size the image should be fitted to.
    /// - Returns: The image fitted to the specified size based on aspect ratio.
    func scaledToFit(size newSize: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth: CGFloat = newSize.width / self.size.width
        let aspectHeight: CGFloat = newSize.height / self.size.height
        let aspectRatio: CGFloat = min(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    /// Scales the image to the specified size.
    ///
    /// - Parameter newSize: The size the image should be scaled to.
    /// - Returns: The image scaled to the specified size.
    func scaledTo(size newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        draw(in: newRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
