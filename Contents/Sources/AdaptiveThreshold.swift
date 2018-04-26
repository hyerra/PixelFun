import CoreImage

/// Represents a custom adaptive threshold filter in core image. Based on luminance, it adjusts whether or not the pixel is black or white.
public class AdaptiveThreshold: CIFilter {
    @objc public dynamic var inputImage: CIImage?
    @objc public dynamic var inputRadius: NSNumber?
    
    /// The text that represents the kernel code.
    let kernelText =
    """
    kernel vec4 adaptiveThresholdFilter(sampler originalImage, sampler blurredImage)
    {
        vec2 textureCoordinate = samplerCoord(originalImage);
        vec2 textureCoordinate2 = samplerCoord(blurredImage);

        highp float localLuminance = sample(originalImage, textureCoordinate).r;
        highp float blurredInput = sample(blurredImage, textureCoordinate2).r;
        highp float thresholdResult = step(blurredInput - 0.05, localLuminance);
        return vec4(vec3(thresholdResult), 1.0);
    }
    """
    
    /// The kernel for the adaptive threshold filter.
    lazy var adaptiveThresholdKernel: CIKernel? = CIKernel(source: kernelText)
    
    let luminance = CIFilter(name: "Luminance")!
    let boxBlur = CIFilter(name: "CIBoxBlur")!
    
    public override var attributes: [String : Any] {
        return [
            kCIAttributeFilterName: "AdaptiveThreshold",
            kCIAttributeDescription: "Determines the local luminance around a pixel, then turns the pixel black if it is below that local luminance and white if above. This can be useful for picking out text under varying lighting conditions.",
            kCIInputImageKey: [kCIAttributeIdentity: 0,
                               kCIAttributeClass: "CIImage",
                               kCIAttributeDisplayName: "Image",
                               kCIAttributeType: kCIAttributeTypeImage]
        ]
    }
    
    public override var outputImage: CIImage? {
        guard let inputImage = inputImage, let inputRadius = inputRadius, let adaptiveThresholdKernel = adaptiveThresholdKernel else { return nil }
        
        luminance.setValuesForKeys([kCIInputImageKey: inputImage])
        guard let luminanceOutput = luminance.outputImage else { return nil }
        
        boxBlur.setValuesForKeys([kCIInputImageKey: luminanceOutput, "inputRadius": inputRadius])
        guard let boxBlurOutput = boxBlur.outputImage else { return nil }
        
        return adaptiveThresholdKernel.apply(extent: inputImage.extent, roiCallback: { frame, rect in return rect }, arguments: [inputImage, boxBlurOutput])
    }
}
