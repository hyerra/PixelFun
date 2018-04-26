//
// MNIST.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class MNISTInput : MLFeatureProvider {
    
    /// A 28x28 pixel grayscale Image. as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 28 pixels wide by 28 pixels high
    public var image: CVPixelBuffer
    
    public var featureNames: Set<String> {
        get {
            return ["image"]
        }
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "image") {
            return MLFeatureValue(pixelBuffer: image)
        }
        return nil
    }
    
    public init(image: CVPixelBuffer) {
        self.image = image
    }
}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class MNISTOutput : MLFeatureProvider {
    
    /// A one-hot MLMultiArray where the index with the biggest confidence from 0-1 is the recognized digit. as dictionary of strings to doubles
    public let confidences: [String : Double]
    
    /// classLabel as string value
    public let classLabel: String
    
    public var featureNames: Set<String> {
        get {
            return ["confidences", "classLabel"]
        }
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "confidences") {
            return try! MLFeatureValue(dictionary: confidences as [NSObject : NSNumber])
        }
        if (featureName == "classLabel") {
            return MLFeatureValue(string: classLabel)
        }
        return nil
    }
    
    public init(confidences: [String : Double], classLabel: String) {
        self.confidences = confidences
        self.classLabel = classLabel
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class MNIST {
    public var model: MLModel
    
    /**
     Construct a model with explicit path to mlmodel file
     - parameters:
     - url: the file url of the model
     - throws: an NSError object that describes the problem
     */
    public init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }
    
    /// Construct a model that automatically loads the model from the app's bundle
    public convenience init() {
        let bundle = Bundle(for: MNIST.self)
        let assetPath = bundle.url(forResource: "MNIST", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }
    
    /**
     Make a prediction using the structured interface
     - parameters:
     - input: the input to the prediction as MNISTInput
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as MNISTOutput
     */
    public func prediction(input: MNISTInput) throws -> MNISTOutput {
        let outFeatures = try model.prediction(from: input)
        let result = MNISTOutput(confidences: outFeatures.featureValue(for: "confidences")!.dictionaryValue as! [String : Double], classLabel: outFeatures.featureValue(for: "classLabel")!.stringValue)
        return result
    }
    
    /**
     Make a prediction using the convenience interface
     - parameters:
     - image: A 28x28 pixel grayscale Image. as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 28 pixels wide by 28 pixels high
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as MNISTOutput
     */
    public func prediction(image: CVPixelBuffer) throws -> MNISTOutput {
        let input_ = MNISTInput(image: image)
        return try self.prediction(input: input_)
    }
}

