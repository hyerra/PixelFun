import UIKit
import ARKit
import PlaygroundSupport

public class ARCameraViewController: UIViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after the view appeared.
        AVCaptureDevice.requestAccess(for: .video) { granted in }
    }
    
    private func displayUnsupportedMessage() {
        // This device does not support AR world tracking.
        let title = "ARKit Doesn't Work with this Device!"
        let message = "ARKit doesn't work with this device! Please try this challenge with a device that supports ARKit."
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func enableCamera() {
        guard ARWorldTrackingConfiguration.isSupported else { displayUnsupportedMessage(); return }
        
        let arscnView = ARSCNView(frame: view.frame)
        arscnView.session = ARSession()
        arscnView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin, .showBoundingBoxes, .showWireframe, .showSkeletons, .showPhysicsShapes, .showCameras]
        view.addSubview(arscnView)
        
        arscnView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arscnView.topAnchor.constraint(equalTo: view.topAnchor),
            arscnView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arscnView.leftAnchor.constraint(equalTo: view.leftAnchor),
            arscnView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        
        arscnView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
    }
}

// MARK: - Live view message handler

extension ARCameraViewController: PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        guard let liveViewMessage = PlaygroundMessageToLiveView(playgroundValue: message) else { return }
        
        switch liveViewMessage {
        case .enableCamera:
            enableCamera()
        default:
            break
        }
    }
}
