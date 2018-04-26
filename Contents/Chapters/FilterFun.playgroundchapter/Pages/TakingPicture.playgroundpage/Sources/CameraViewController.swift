import UIKit
import AVFoundation
import PlaygroundSupport

@objc(CameraViewController)
public class CameraViewController: UIViewController, StoryboardInstantiatable, PlaygroundLiveViewSafeAreaContainer {
    
    public static let storyboardIdentifier = "cameraVC"
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    
    var cameraManager: CameraManager?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        captureButton.layer.borderColor = UIColor.white.cgColor
        captureButton.layer.borderWidth = 4
        captureButton.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            captureButton.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor)
            ])
        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            previewView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            previewView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            ])
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after the view appeared.
        AVCaptureDevice.requestAccess(for: .video) { granted in }
    }
    
    override public func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotate(from: fromInterfaceOrientation)
        // Do any additional work after the orientation changed.
        cameraManager?.updatePreview(to: previewView.bounds.size, with: interfaceOrientation)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Starts running the camera in order for the user to take a picture.
    public func startCamera(desiredCameraPosition: CameraManager.CameraPosition, desiredFlashSetting: CameraManager.FlashSetting) {
        do {
            guard cameraManager == nil else { return } /* We have already initalized and configured the camera manager if this is not nil. */
            cameraManager = try CameraManager(desiredCameraPosition: desiredCameraPosition, desiredFlashSetting: desiredFlashSetting)
            try cameraManager?.displayPreview(on: previewView, with: interfaceOrientation)
        } catch let error {
            let alertController = UIAlertController(title: "Error Displaying Camera Preview", message: error.localizedDescription, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func takePicture(_ sender: Any) {
        cameraManager?.captureImage { image, error in
            if let image = image {
                guard let imageData = UIImagePNGRepresentation(image) else { return }
                PlaygroundKeyValueStore.current["filterImage"] = .data(imageData)
                self.send(PlaygroundMessageFromLiveView.showFilterCameraSuccessMessage.playgroundValue)
            } else if let error = error {
                let alertController = UIAlertController(title: "Error Capturing Picture", message: error.localizedDescription, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            self.captureButton.removeFromSuperview()
        }
    }
}

// MARK: - Live view message handler

extension CameraViewController: PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        guard let message = PlaygroundMessageToLiveView(playgroundValue: message) else { return }
        switch message {
        case .startFilterCamera(desiredCameraPosition: let position, desiredFlashSetting: let desiredFlashSetting):
            startCamera(desiredCameraPosition: position, desiredFlashSetting: desiredFlashSetting)
        default:
            break
        }
    }
}
