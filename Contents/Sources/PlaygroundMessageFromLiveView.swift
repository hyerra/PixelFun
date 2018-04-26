import Foundation

/// Enables the sending of messages from the live view to the playground.
public enum PlaygroundMessageFromLiveView: PlaygroundMessage {
    // MARK: - Handwriting Fun
    case showHandwritingCameraSuccessMessage
    
    // MARK: - Object Recognition Fun
    case showObjectCameraSuccessMessage
    
    // MARK: - Filter Fun
    case showFilterCameraSuccessMessage
    
    public enum MessageType: String, StringRawRepresentable {
        case showHandwritingCameraSuccessMessage
        
        case showObjectCameraSuccessMessage
        
        case showFilterCameraSuccessMessage
    }
    
    public var messageType: MessageType {
        switch self {
        case .showHandwritingCameraSuccessMessage:
            return .showHandwritingCameraSuccessMessage
        case .showObjectCameraSuccessMessage:
            return .showObjectCameraSuccessMessage
        case .showFilterCameraSuccessMessage:
            return .showFilterCameraSuccessMessage
        }
    }
    
    public init?(messageType: RawCodable, encodedMessage: Data?) {
        switch messageType {
        case .showHandwritingCameraSuccessMessage:
            self = .showHandwritingCameraSuccessMessage
        case .showObjectCameraSuccessMessage:
            self = .showObjectCameraSuccessMessage
        case .showFilterCameraSuccessMessage:
            self = .showFilterCameraSuccessMessage
        }
    }
    
    public func encodeMessage() -> Data? {
        switch self {
        case .showHandwritingCameraSuccessMessage:
            return nil
        case .showObjectCameraSuccessMessage:
            return nil
        case .showFilterCameraSuccessMessage:
            return nil
        }
    }
}

