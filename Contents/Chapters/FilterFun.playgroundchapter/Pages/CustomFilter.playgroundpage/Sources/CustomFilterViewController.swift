import UIKit
import PlaygroundSupport

@objc(CustomFilterViewController)
public class CustomFilterViewController: UIViewController, StoryboardInstantiatable {
    
    @IBOutlet weak var filterImageView: UIImageView!
    
    public static let storyboardIdentifier = "customFilterVC"
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Live view message handler

extension CustomFilterViewController: PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        guard let message = PlaygroundMessageToLiveView(playgroundValue: message) else { return }
        switch message {
        case .showCustomFilteredImage(image: let image):
            filterImageView.image = image
        default:
            break
        }
    }
}
