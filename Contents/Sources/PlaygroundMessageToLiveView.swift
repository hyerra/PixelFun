import Foundation
import UIKit

/// Enables the sending of messages from the playground to the live view.
public enum PlaygroundMessageToLiveView: PlaygroundMessage {
    // MARK: - Handwriting Fun
    case startHandwritingCamera(desiredCameraPosition: CameraManager.CameraPosition, desiredFlashSetting: CameraManager.FlashSetting)
    case showHandwrittenImage(handwritingImage: UIImage, animationDuration: TimeInterval)
    case showHandwrittenOptimizedImage(optimizedImage: UIImage, animationDuration: TimeInterval)
    case showHandwrittenResizedImage(resizedImage: UIImage, animationDuration: TimeInterval)
    case showHandwritingMLResults(confidences: [DigitConfidence])
    
    // MARK: - Object Recogntion Fun
    case startObjectCamera(desiredCameraPosition: CameraManager.CameraPosition, desiredFlashSetting: CameraManager.FlashSetting)
    case showObjectMLResults(confidences: [ObjectConfidence], objectImage: UIImage)
    
    // MARK: - Filter Fun
    case startFilterCamera(desiredCameraPosition: CameraManager.CameraPosition, desiredFlashSetting: CameraManager.FlashSetting)
    case showCustomFilteredImage(image: UIImage)
    case showChainFilteredImage(image: UIImage)
    
    // MARK: - AR Fun
    case enableCamera
    case updateDrawingColor(color: UIColor)
    
    public enum MessageType: String, StringRawRepresentable {
        case startHandwritingCamera
        case showHandwrittenImage
        case showHandwrittenOptimizedImage
        case showHandwrittenResizedImage
        case showHandwritingMLResults
        
        case startObjectCamera
        case showObjectMLResults
        
        case startFilterCamera
        case showCustomFilteredImage
        case showChainFilteredImage
        
        case enableCamera
        case updateDrawingColor
    }
    
    public var messageType: MessageType {
        switch self {
        case .startHandwritingCamera:
            return .startHandwritingCamera
        case .showHandwrittenImage:
            return .showHandwrittenImage
        case .showHandwrittenOptimizedImage:
            return .showHandwrittenOptimizedImage
        case .showHandwrittenResizedImage:
            return .showHandwrittenResizedImage
        case .showHandwritingMLResults:
            return .showHandwritingMLResults
        case .startObjectCamera:
            return .startObjectCamera
        case .showObjectMLResults:
            return .showObjectMLResults
        case .startFilterCamera:
            return .startFilterCamera
        case .showCustomFilteredImage:
            return .showCustomFilteredImage
        case .showChainFilteredImage:
            return .showChainFilteredImage
        case .enableCamera:
            return .enableCamera
        case .updateDrawingColor:
            return .updateDrawingColor
        }
    }
    
    public init?(messageType: RawCodable, encodedMessage: Data?) {
        let decoder = JSONDecoder()
        
        switch messageType {
        case .startHandwritingCamera:
            guard let encodedMessage = encodedMessage else { return nil }
            guard let message = try? decoder.decode(StartCameraMessageData.self, from: encodedMessage) else { return nil }
            self = .startHandwritingCamera(desiredCameraPosition: message.desiredCameraPosition, desiredFlashSetting: message.desiredFlashSetting)
        case .showHandwrittenImage:
            guard let encodedMessage = encodedMessage else { return nil }
            guard let message = try? decoder.decode(ShowHandwrittenImageData.self, from: encodedMessage) else { return nil }
            guard let image = UIImage(data: message.handwritingImageData) else { return nil }
            self = .showHandwrittenImage(handwritingImage: image, animationDuration: message.animationDuration)
        case .showHandwrittenOptimizedImage:
            guard let encodedMessage = encodedMessage else { return nil }
            guard let message = try? decoder.decode(ShowHandwrittenOptimizedImageData.self, from: encodedMessage) else { return nil }
            guard let image = UIImage(data: message.optimizedImageData) else { return nil }
            self = .showHandwrittenOptimizedImage(optimizedImage: image, animationDuration: message.animationDuration)
        case .showHandwrittenResizedImage:
            guard let encodedMessage = encodedMessage else { return nil }
            guard let message = try? decoder.decode(ShowHandwrittenResizedImageData.self, from: encodedMessage) else { return nil }
            guard let image = UIImage(data: message.resizedImageData) else { return nil }
            self = .showHandwrittenResizedImage(resizedImage: image, animationDuration: message.animationDuration)
        case .showHandwritingMLResults:
            guard let encodedMessage = encodedMessage else { return nil }
            guard let message = try? decoder.decode(ShowHandwritingMLResultsData.self, from: encodedMessage) else { return nil }
            self = .showHandwritingMLResults(confidences: message.confidences)
        case .startObjectCamera:
            guard let encodedMessage = encodedMessage else { return nil }
            guard let message = try? decoder.decode(StartCameraMessageData.self, from: encodedMessage) else { return nil }
            self = .startObjectCamera(desiredCameraPosition: message.desiredCameraPosition, desiredFlashSetting: message.desiredFlashSetting)
        case .showObjectMLResults:
            guard let encodedMessage = encodedMessage else { return nil }
            guard let message = try? decoder.decode(ShowObjectMLResultsData.self, from: encodedMessage) else { return nil }
            guard let image = UIImage(data: message.objectImageData) else { return nil }
            self = .showObjectMLResults(confidences: message.confidences, objectImage: image)
        case .startFilterCamera:
            guard let encodedMessage = encodedMessage else { return nil }
            guard let message = try? decoder.decode(StartCameraMessageData.self, from: encodedMessage) else { return nil }
            self = .startFilterCamera(desiredCameraPosition: message.desiredCameraPosition, desiredFlashSetting: message.desiredFlashSetting)
        case .showCustomFilteredImage:
            guard let encodedMessage = encodedMessage else { return nil }
            guard let message = try? decoder.decode(ShowCustomFilteredImageData.self, from: encodedMessage) else { return nil }
            guard let image = UIImage(data: message.imageData) else { return nil }
            self = .showCustomFilteredImage(image: image)
        case .showChainFilteredImage:
            guard let encodedMessage = encodedMessage else { return nil }
            guard let message = try? decoder.decode(ShowChainFilteredImageData.self, from: encodedMessage) else { return nil }
            guard let image = UIImage(data: message.imageData) else { return nil }
            self = .showChainFilteredImage(image: image)
        case .enableCamera:
            self = .enableCamera
        case .updateDrawingColor:
            guard let encodedMessage = encodedMessage else { return nil }
            guard let message = try? decoder.decode(UpdateDrawingColorData.self, from: encodedMessage) else { return nil }
            self = .updateDrawingColor(color: message.color.color)
        }
    }
    
    public func encodeMessage() -> Data? {
        let encoder = JSONEncoder()
        
        switch self {
        case .startHandwritingCamera(desiredCameraPosition: let desiredCameraPosition, desiredFlashSetting: let desiredFlashSetting), .startObjectCamera(desiredCameraPosition: let desiredCameraPosition, desiredFlashSetting: let desiredFlashSetting), .startFilterCamera(desiredCameraPosition: let desiredCameraPosition, desiredFlashSetting: let desiredFlashSetting):
            let message = StartCameraMessageData(desiredCameraPosition: desiredCameraPosition, desiredFlashSetting: desiredFlashSetting)
            let encodedMessage = try? encoder.encode(message)
            return encodedMessage
        case .showHandwrittenImage(handwritingImage: let handwritingImage, animationDuration: let animationDuration):
            guard let handwritingImageData = UIImagePNGRepresentation(handwritingImage) else { return nil }
            let message = ShowHandwrittenImageData(handwritingImageData: handwritingImageData, animationDuration: animationDuration)
            let encodedMessage = try? encoder.encode(message)
            return encodedMessage
        case .showHandwrittenOptimizedImage(optimizedImage: let optimizedImage, animationDuration: let animationDuration):
            guard let optimizedImageData = UIImagePNGRepresentation(optimizedImage) else { return nil }
            let message = ShowHandwrittenOptimizedImageData(optimizedImageData: optimizedImageData, animationDuration: animationDuration)
            let encodedMessage = try? encoder.encode(message)
            return encodedMessage
        case .showHandwrittenResizedImage(let resizedImage, animationDuration: let animationDuration):
            guard let resizedImageData = UIImagePNGRepresentation(resizedImage) else { return nil }
            let message = ShowHandwrittenResizedImageData(resizedImageData: resizedImageData, animationDuration: animationDuration)
            let encodedMessage = try? encoder.encode(message)
            return encodedMessage
        case .showHandwritingMLResults(confidences: let confidences):
            let message = ShowHandwritingMLResultsData(confidences: confidences)
            let encodedMessage = try? encoder.encode(message)
            return encodedMessage
        case .showObjectMLResults(confidences: let confidences, objectImage: let objectImage):
            guard let objectImageData = UIImagePNGRepresentation(objectImage) else { return nil }
            let message = ShowObjectMLResultsData(confidences: confidences, objectImageData: objectImageData)
            let encodedMessage = try? encoder.encode(message)
            return encodedMessage
        case .showCustomFilteredImage(image: let image):
            guard let imageData = UIImagePNGRepresentation(image) else { return nil }
            let message = ShowCustomFilteredImageData(imageData: imageData)
            let encodedMessage = try? encoder.encode(message)
            return encodedMessage
        case .showChainFilteredImage(image: let image):
            guard let imageData = UIImagePNGRepresentation(image) else { return nil }
            let message = ShowChainFilteredImageData(imageData: imageData)
            let encodedMessage = try? encoder.encode(message)
            return encodedMessage
        case .enableCamera:
            return nil
        case .updateDrawingColor(color: let color):
            let codableColor = CodableColor(color: color)
            let message = UpdateDrawingColorData(color: codableColor)
            let encodedMessage = try? encoder.encode(message)
            return encodedMessage
        }
    }
}
