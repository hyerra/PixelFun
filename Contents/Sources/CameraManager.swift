import UIKit
import AVFoundation

/// An `object` to help interact with the camera through `AVFoundation`.
public class CameraManager: NSObject {
    
    // MARK: - Properties
    
    /// The capture session object.
    private lazy var captureSession = AVCaptureSession()
    
    /// The front camera.
    private lazy var frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    /// The back camera.
    private lazy var backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    
    /// The desired camera position.
    private var desiredCameraPosition: CameraPosition
    /// The desired flash setting.
    private var desiredFlashSetting: FlashSetting
    
    /// The preview layer that will be displaying the image to be captured.
    var previewLayer: AVCaptureVideoPreviewLayer!
    /// The output of the photo capture which enables capturing a photo.
    private lazy var photoOutput: AVCapturePhotoOutput = {
        let photoOutput = AVCapturePhotoOutput()
        let photoSettings = AVCapturePhotoSettings(format: [kCVPixelBufferPixelFormatTypeKey as String :
            NSNumber(value: kCVPixelFormatType_32BGRA)])
        photoOutput.setPreparedPhotoSettingsArray([photoSettings], completionHandler: nil)
        photoOutput.isHighResolutionCaptureEnabled = true
        return photoOutput
    }()
    
    /// The handler type that's called after a photo has been captured. Contains an image if successful or an error explaining what went wrong.
    public typealias ImageCaptureCompletionHandler = (UIImage?, Error?) -> Void
    /// The handler that's called after a photo has been captured. Contains an image if successful or an error explaining what went wrong.
    var photoCaptureCompletionHandler: ImageCaptureCompletionHandler?
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `CameraManager` with a specified position.
    ///
    /// [AVCaptureDevice.Position Documentation]: https://developer.apple.com/documentation/avfoundation/avcapturedevice.position "AVCaptureDevice.Position documentation."
    /// - Parameters:
    ///   - desiredCameraPosition: The position of the camera you are trying to access. See [AVCaptureDevice.Position Documentation].
    ///   - desiredFlashSetting: A property determining whether or not the flash should be enabled for the camera.
    /// - Throws: An error that might've occured when preparing to use the camera.
    public init(desiredCameraPosition: CameraPosition, desiredFlashSetting: FlashSetting) throws {
        self.desiredCameraPosition = desiredCameraPosition
        self.desiredFlashSetting = desiredFlashSetting
        super.init()
        let position = AVCaptureDevice.Position(position: desiredCameraPosition)
        captureSession.startRunning()
        try prepareCamera(forPosition: position)
    }
    
    /// Initializes a new instance of `CameraManager` with the back facing camera and flash disabled. Errors thrown from this initializer are unhandled and fatal.
    public override init() {
        desiredCameraPosition = .back
        desiredFlashSetting = .off
        super.init()
        captureSession.startRunning()
        try! prepareCamera(forPosition: .back)
    }
    
    // MARK: - Helper Methods
    
    /// Configures the camera with a specified position to be added as an input for the `AVCaptureSession`.
    ///
    /// [AVCaptureDevice.Position Documentation]: https://developer.apple.com/documentation/avfoundation/avcapturedevice.position "AVCaptureDevice.Position documentation."
    /// - Parameter position: The camera's position, see [AVCaptureDevice.Position Documentation].
    /// - Throws: An error that might have occured when trying to add the camera as an input.
    private func configureInput(forPosition position: AVCaptureDevice.Position) throws {
        if position == .front {
            guard let frontCamera = frontCamera else { throw CameraError.cameraUnavailable }
            let frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            guard captureSession.canAddInput(frontCameraInput) else { throw CameraError.invalidInput }
            captureSession.addInput(frontCameraInput)
        } else if position == .back {
            guard let backCamera = backCamera else { throw CameraError.cameraUnavailable }
            let backCameraInput = try AVCaptureDeviceInput(device: backCamera)
            guard captureSession.canAddInput(backCameraInput) else { throw CameraError.invalidInput }
            captureSession.addInput(backCameraInput)
        }
    }
    
    /// Adds the output for the captureSession.
    ///
    /// - Throws: An error that might have occured when trying to add the camera as an output.
    private func configureOutput() throws {
        guard captureSession.canAddOutput(photoOutput) else { throw CameraError.invalidOutput }
        captureSession.addOutput(photoOutput)
    }
    
    /// Prepares the camera of a specified position to be used for photo capture.
    ///
    /// [AVCaptureDevice.Position Documentation]: https://developer.apple.com/documentation/avfoundation/avcapturedevice.position "AVCaptureDevice.Position documentation."
    /// - Parameter position: The position of the camera to be configured, see [AVCaptureDevice.Position Documentation].
    /// - Throws: An error that might have occured when preparing the camera for use.
    private func prepareCamera(forPosition position: AVCaptureDevice.Position) throws {
        try configureInput(forPosition: position)
        try configureOutput()
    }
    
    // MARK: - External Methods
    
    /// Starts running the capture session.
    public func startRunning() {
        captureSession.startRunning()
    }
    
    /// Stops running the capture session.
    public func stopRunning() {
        captureSession.stopRunning()
    }
    
    /// Displays a preview of the camera feed.
    ///
    /// - Parameters:
    ///   - view: The view to display the preview on.
    ///   - orientation: The orientation that the preview should be displayed as.
    /// - Throws: An error that might've occured when attempting to display the preview.
    public func displayPreview(on view: UIView, with orientation: UIInterfaceOrientation) throws {
        guard captureSession.isRunning else { throw CameraError.sessionNotRunning }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        if let connection = previewLayer.connection, connection.isVideoOrientationSupported { previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation(orientation: orientation) }
        
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = view.bounds
        
        self.previewLayer = previewLayer
    }
    
    /// Updates the orientation and bounds of a preview in order to handle rotation based adjustments.
    ///
    /// - Parameters:
    ///   - size: The size to update the preview layer to.
    ///   - orientation: The orientation to update the preview layer to.
    public func updatePreview(to size: CGSize, with orientation: UIInterfaceOrientation) {
        if let connection = previewLayer.connection, connection.isVideoOrientationSupported { previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation(orientation: orientation) }
        previewLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
    
    /// Captures an image from the video feed.
    ///
    /// - Parameter completion: The image that was captured or an error if unsuccessful.
    public func captureImage(completion: @escaping ImageCaptureCompletionHandler) {
        guard captureSession.isRunning else { completion(nil, CameraError.sessionNotRunning); return }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = desiredFlashSetting == .on ? .on : .off
        if desiredCameraPosition == .front { settings.flashMode = .off }
        if desiredCameraPosition == .back { if let backCamera = backCamera, !backCamera.isFlashAvailable { settings.flashMode = .off } }
                
        photoOutput.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionHandler = completion
    }
    
    // MARK: - Camera Position
    
    /// The position of the camera.
    ///
    /// - front: The front facing camera.
    /// - back: The back facing camera.
    public enum CameraPosition: String, Codable {
        case front
        case back
    }
    
    // MARK: - Flash Setting
    
    /// The flash setting for the camera.
    ///
    /// - on: Turns the flash of the camera on.
    /// - off: Turns the flash of the camera off.
    public enum FlashSetting: String, Codable {
        case on
        case off
    }
    
    // MARK: - Error
    
    /// Represents all the error cases that could be thrown when interacting with the camera.
    enum CameraError: Error {
        case cameraUnavailable
        case invalidInput
        case invalidOutput
        case sessionNotRunning
        case unknown
        
        var localizedDescription: String {
            switch self {
            case .cameraUnavailable: return "The camera isn't available or doesn't exist."
            case .invalidInput: return "The specified camera couldn't be used as an input."
            case .invalidOutput: return "The output couldn't be added which means that the photo can't be saved."
            case .sessionNotRunning: return "The camera session isn't running."
            case .unknown: return "An unexpected error occured when interacting with the camera."
            }
        }
    }
}

// MARK: - Photo capture delegate

extension CameraManager: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let captureOrientation = previewLayer?.connection?.videoOrientation else { return }
        
        if let data = photo.fileDataRepresentation(), let image = UIImage(data: data) {
            let correctedImage: UIImage
            switch captureOrientation {
            case .portrait: correctedImage = image.rotated(by: 270)
            case .landscapeLeft: correctedImage = image.rotated(by: 180)
            case .landscapeRight: correctedImage = image
            case .portraitUpsideDown: correctedImage = image.rotated(by: 90)
            }
            photoCaptureCompletionHandler?(correctedImage, nil)
        } else if let error = error {
            photoCaptureCompletionHandler?(nil, error)
        } else {
            photoCaptureCompletionHandler?(nil, CameraError.unknown)
        }
    }
}

// MARK: - Camera Position
public extension AVCaptureDevice.Position {
    
    /// Initializes a new value of position based on the `CameraManager.CameraPosition` value.
    ///
    /// - Parameter position: The `CameraManager.CameraPosition` value from which you are trying to initialize an AVCaptureDevice position value.
    init(position: CameraManager.CameraPosition) {
        switch position {
        case .front:
            self = .front
        case .back:
            self = .back
        }
    }
}

public extension AVCaptureVideoOrientation {
    
    /// Initializes a new `AVCaptureVideoOrientation` based on the `UIInterfaceOrientation`.
    ///
    /// - Parameter orientation: The orientation of the `UIInterfaceOrientation` to generate the `AVCaptureVideoOrientation` from.
    init(orientation: UIInterfaceOrientation) {
        switch orientation {
        case .unknown:
            self = .portrait
        case .portrait:
            self = .portrait
        case .portraitUpsideDown:
            self = .portraitUpsideDown
        case .landscapeRight:
            self = .landscapeRight
        case .landscapeLeft:
            self = .landscapeLeft
        }
    }
}

public extension UIInterfaceOrientation {
    
    /// Initializes a new `UIInterfaceOrientation` based on the `AVCaptureVideoOrientation`.
    ///
    /// - Parameter orientation: The orientation of the `AVCaptureVideoOrientation` to generate the `UIInterfaceOrientation` from.
    init(orientation: AVCaptureVideoOrientation) {
        switch orientation {
        case .portrait:
            self = .portrait
        case .portraitUpsideDown:
            self = .portraitUpsideDown
        case .landscapeRight:
            self = .landscapeRight
        case .landscapeLeft:
            self = .landscapeLeft
        }
    }
}
