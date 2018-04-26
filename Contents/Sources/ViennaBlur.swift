import CoreImage

/// Represents a custom vienna blur filter in core image.
public class ViennaBlur: CIFilter {
    @objc public dynamic var inputImage: CIImage?
    @objc public dynamic var inputCenter: CIVector?
    @objc public dynamic var inputAmount: NSNumber?
    
    private let zoomBlur = CIFilter(name: "CIZoomBlur")!
    private let vienna = CIFilter(name: "Vienna")!
    
    public override var attributes: [String : Any] {
        return [
            kCIAttributeFilterName: "ViennaBlur",
            kCIAttributeDescription: "Mixes the Vienna Filter with a zoom blur to create an interesting effect.",
            kCIInputImageKey: [kCIAttributeClass: "CIImage",
                               kCIAttributeDisplayName: "Image",
                               kCIAttributeType: kCIAttributeTypeImage],
            kCIInputCenterKey: [kCIAttributeClass: "CIVector",
                                kCIAttributeDisplayName: "Center",
                                kCIAttributeType: kCIAttributeTypePosition],
            kCIInputIntensityKey: [kCIAttributeIdentity: 0,
                                   kCIAttributeClass: "NSNumber",
                                   kCIAttributeDisplayName: "Amount",
                                   kCIAttributeType: kCIAttributeTypeInteger]
        ]
    }
    
    public override func setDefaults() {
        inputCenter = CIVector(x: 150, y: 150)
        inputAmount = 20
        super.setDefaults()
    }
    
    public override var outputImage: CIImage? {
        guard let inputImage = inputImage else { return nil }
        
        vienna.setValue(inputImage, forKey: kCIInputImageKey)
        guard let viennaOutput = vienna.outputImage else { return nil }
        
        zoomBlur.setValue(viennaOutput, forKey: kCIInputImageKey)
        zoomBlur.setValue(inputCenter, forKey: kCIInputCenterKey)
        zoomBlur.setValue(inputAmount, forKey: "inputAmount")
        
        return zoomBlur.outputImage
    }
}
