import UIKit
import PlaygroundSupport

@objc(OptimizingImageViewController)
public class OptimizingImageViewController: UIViewController, StoryboardInstantiatable {
    
    public static let storyboardIdentifier = "optimizingImageVC"
    
    @IBOutlet weak var optimizingImageView: UIImageView!
    
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

extension OptimizingImageViewController: PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        guard let message = PlaygroundMessageToLiveView(playgroundValue: message) else { return }
        switch message {
        case .showHandwrittenImage(handwritingImage: let handwritingImage, animationDuration: let duration):
            optimizingImageView.changeImage(to: handwritingImage, animated: true, duration: duration)
        case .showHandwrittenOptimizedImage(optimizedImage: let optimizedImage, animationDuration: let duration):
            optimizingImageView.changeImage(to: optimizedImage, animated: true, duration: duration)
        default:
            break
        }
    }
}
