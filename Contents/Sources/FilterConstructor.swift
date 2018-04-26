import CoreImage

/// Used to help register the custom filters with Core Image.
public class FilterConstructor: NSObject, CIFilterConstructor {
    /// Call this function before using the custom filters to register the custom filters with Core Image.
    public static func registerFilters() {
        // Register the luminance filter.
        CIFilter.registerName("Luminance", constructor: FilterConstructor(), classAttributes: [kCIAttributeFilterDisplayName: "Luminance", kCIAttributeFilterCategories: [kCICategoryColorAdjustment]])
        // Register the adaptive threshold filter.
        CIFilter.registerName("AdaptiveThreshold", constructor: FilterConstructor(), classAttributes: [kCIAttributeFilterDisplayName: "Adaptive Threshold", kCIAttributeFilterCategories: [kCICategoryColorAdjustment]])
        // Register the vienna filter.
        CIFilter.registerName("Vienna", constructor: FilterConstructor(), classAttributes: [kCIAttributeFilterDisplayName: "Vienna", kCIAttributeFilterCategories: [kCICategoryColorAdjustment]])
        // Register the vienna blur filter.
        CIFilter.registerName("ViennaBlur", constructor: FilterConstructor(), classAttributes: [kCIAttributeFilterDisplayName: "Vienna Blur", kCIAttributeFilterCategories: [kCICategoryColorAdjustment]])
    }
    
    public func filter(withName name: String) -> CIFilter? {
        switch name {
        case "Luminance": return Luminance()
        case "AdaptiveThreshold": return AdaptiveThreshold()
        case "Vienna": return Vienna()
        case "ViennaBlur": return ViennaBlur()
        default: return nil
        }
    }
}
