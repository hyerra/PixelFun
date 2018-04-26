import CoreImage

/// Represents a custom luminance filter in Core Image.
public class Luminance: CIFilter {
    
    @objc public dynamic var inputImage: CIImage?
    
    /// The text that represents the kernel code.
    let kernelText =
    """
    kernel vec4 luminanceFilter(sampler src)
    {
        vec2 textureCoordinate = samplerCoord(src);
        const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);
        lowp vec4 textureColor = sample(src, textureCoordinate);
        float luminance = dot(textureColor.rgb, W);
        return vec4(vec3(luminance), textureColor.a);
    }
    """
    
    /// The kernel for the luminance filter.
    lazy var luminanceKernel: CIKernel? = CIKernel(source: kernelText)
    
    public override var attributes: [String : Any] {
        return [
            kCIAttributeFilterName: "Luminance",
            kCIAttributeDescription: "Reduces an image to just its luminance (greyscale).",
            kCIInputImageKey: [kCIAttributeIdentity: 0,
                               kCIAttributeClass: "CIImage",
                               kCIAttributeDisplayName: "Image",
                               kCIAttributeType: kCIAttributeTypeImage]
        ]
    }
    
    public override var outputImage: CIImage? {
        guard let inputImage = inputImage, let luminanceKernel = luminanceKernel else { return nil }
        return luminanceKernel.apply(extent: inputImage.extent, roiCallback: { frame, rect in return rect }, arguments: [inputImage])
    }
}
