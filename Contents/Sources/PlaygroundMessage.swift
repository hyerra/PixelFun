import Foundation
import PlaygroundSupport

/// A message that can be sent to and from the live view.
public protocol PlaygroundMessage {
    /// This type can be encoded and decoded based on a string raw value.
    associatedtype RawCodable: StringRawRepresentable
    /// The type of the message being sent.
    var messageType: RawCodable { get }
    
    /// Initializes a new instance of the `PlaygroundMessage` based on the `PlaygroundValue` of the sent message.
    ///
    /// - Parameters:
    ///   - playgroundValue: The playground value that was recieved.
    init?(playgroundValue: PlaygroundValue)
    
    /// Initializes a new instance of the `PlaygroundMessage` based on the type of the message and the data encoded.
    ///
    /// - Parameters:
    ///   - messageType: The type of the message that is being created.
    ///   - encodedMessage: The data being sent with the message.
    init?(messageType: RawCodable, encodedMessage: Data?)
    
    /// Encodes the message contents into data.
    ///
    /// - Returns: The data of the encoded message.
    func encodeMessage() -> Data?
}

/// A type that can be converted to and from an associated `String` raw value.
public protocol StringRawRepresentable {
    /// Initializes the conforming type based on the rawValue.
    ///
    /// - Parameters:
    ///   - rawValue: The raw value of the type.
    init?(rawValue: String)
    /// The raw value of the conforming type.
    var rawValue: String { get }
}

public extension PlaygroundMessage {
    public init?(playgroundValue: PlaygroundValue) {
        guard case let .array(values) = playgroundValue, !values.isEmpty else { return nil }
        guard case let .string(rawType) = values[0] else { return nil }
        
        guard let messageType = RawCodable(rawValue: rawType) else { return nil }
        
        var encodedMessage: Data? = nil
        if let encodedData = values.last, case let .data(message) = encodedData { encodedMessage = message }
        
        self.init(messageType: messageType, encodedMessage: encodedMessage)
    }
    
    /// The current message represented as a `PlaygroundValue`.
    public var playgroundValue: PlaygroundValue {
        if let encodedMessage = encodeMessage() { /* If we have data, include the message type and data. */
            return .array([.string(messageType.rawValue), .data(encodedMessage)])
        } else { /* If we don't have data, just include the message type. */
            return .array([.string(messageType.rawValue)])
        }
    }
}
