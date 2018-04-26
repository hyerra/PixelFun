import CoreImage

/// Represents a custom vienna filter in Core Image.
public class Vienna: CIFilter {
    
    @objc public dynamic var inputImage: CIImage?
    
    /// The text that represents the kernel code.
    var kernelText =
    """
    kernel vec4 viennaFilter(sampler image) {
        vec4 pixel = sample(image, samplerCoord(image));
        vec2 size = samplerSize(image);
        vec2 pixelLocation = destCoord();
        float width = size.x;
        pixel.r = (size.x - pixelLocation.x)/width;
        pixel.b = pixelLocation.x/width;
        return pixel;
    }
    """
    
    /// The kernel for the vienna filter.
    lazy var viennaKernel: CIKernel? = CIKernel(source: kernelText)
    
    public init(kernelText: String? = nil) {
        if let kernelText = kernelText { self.kernelText = kernelText }
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override var attributes: [String : Any] {
        return [
            kCIAttributeFilterName: "Vienna",
            kCIAttributeDescription: "Adjusts the red and blue values of a pixel depending on the position of the pixel.",
            kCIInputImageKey: [kCIAttributeIdentity: 0,
                               kCIAttributeClass: "CIImage",
                               kCIAttributeDisplayName: "Image",
                               kCIAttributeType: kCIAttributeTypeImage]
        ]
    }
    
    public override var outputImage: CIImage? {
        guard let inputImage = inputImage, let viennaKernel = viennaKernel else { return nil }
        return viennaKernel.apply(extent: inputImage.extent, roiCallback: { frame, rect in return rect }, arguments: [inputImage])
    }
}
