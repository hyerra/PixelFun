import CoreImage
import UIKit

/// Extracts the handwriting from the image while trying to remove noise, shadows, etc.
public class HandwritingExtractor: NSObject {
    
    // MARK: - Context
    let mtlDevice: MTLDevice = MTLCreateSystemDefaultDevice()!
    lazy var context: CIContext = CIContext(mtlDevice: mtlDevice, options: [kCIContextCacheIntermediates: false])
    
    // MARK: - Filters
    let highlightsAndShadows = CIFilter(name: "CIHighlightShadowAdjust")!
    let contrast = CIFilter(name: "CIColorControls")!
    let noiseReduction = CIFilter(name: "CINoiseReduction")!
    let adaptiveThreshold = CIFilter(name: "AdaptiveThreshold")!
    let colorInvert = CIFilter(name: "CIColorInvert")!
    
    // MARK: - Initialization
    
    /// The image that contains the handwriting that has to be processed.
    let handwritingImage: UIImage
    
    /// A multipiler for calculating the average amount of background blur.
    let blurRadius: NSNumber
    
    /// Initalizes a new object of `HandwritingExtractor` to extract handwriting from a specified image.
    ///
    /// - Parameter handwritingImage: The image that contains the handwriting that has to be processed.
    public init(handwritingImage: UIImage, blurRadius: NSNumber = 190) {
        self.handwritingImage = handwritingImage
        self.blurRadius = blurRadius
    }
    
    // MARK: - Image Processing
    
    /// Processes the image in order to extract just the handwriting while removing blemishes like shadows and noise.
    ///
    /// - Returns: The processed image that contains the handwriting.
    public func processImage() -> UIImage? {
        let handwritingCIImage = CIImage(cgImage: handwritingImage.cgImage!)
        
        contrast.setValuesForKeys([kCIInputImageKey: handwritingCIImage, "inputContrast": 1])
        guard let contrastOutput = contrast.outputImage else { return nil }
        
        highlightsAndShadows.setValuesForKeys([kCIInputImageKey: contrastOutput, "inputShadowAmount": 1, "inputHighlightAmount": 1])
        guard let highlightOutput = highlightsAndShadows.outputImage else { return nil }
        
        noiseReduction.setValuesForKeys([kCIInputImageKey: highlightOutput, "inputNoiseLevel" : 1, "inputSharpness" : 0])
        guard let noiseReductionOutput = noiseReduction.outputImage else { return nil }
        
        adaptiveThreshold.setValuesForKeys([kCIInputImageKey: noiseReductionOutput, "inputRadius": blurRadius])
        guard let adaptiveThresholdOutput = adaptiveThreshold.outputImage else { return nil }
        
        colorInvert.setValuesForKeys([kCIInputImageKey: adaptiveThresholdOutput])
        guard let colorInvertOutput = colorInvert.outputImage else { return nil }
        
        guard let handwritingCGFilteredImage = context.createCGImage(colorInvertOutput, from: noiseReductionOutput.extent) else { return nil }
        let correctlyRotatedImage = UIImage(cgImage: handwritingCGFilteredImage, scale: handwritingImage.scale, orientation: handwritingImage.imageOrientation)
        return correctlyRotatedImage
    }
}
