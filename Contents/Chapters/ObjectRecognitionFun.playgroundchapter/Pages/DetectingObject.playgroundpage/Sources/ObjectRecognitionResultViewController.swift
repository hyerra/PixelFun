import PlaygroundSupport
import UIKit

@objc(ObjectRecognitionResultViewController)
public class ObjectRecognitionResultViewController: UIViewController, StoryboardInstantiatable, PlaygroundLiveViewSafeAreaContainer {
    
    public static let storyboardIdentifier = "objectResultVC"
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var topResult: UILabel!
    @IBOutlet weak var confidenceDescription: UILabel!
    
    @IBOutlet weak var objectImage: UIImageView!
    @IBOutlet var confidenceLabels: [UILabel]!
    
    @IBOutlet weak var zeroConfidence: UILabel!
    @IBOutlet weak var oneConfidence: UILabel!
    @IBOutlet weak var twoConfidence: UILabel!
    @IBOutlet weak var threeConfidence: UILabel!
    @IBOutlet weak var fourConfidence: UILabel!
    @IBOutlet weak var fiveConfidence: UILabel!
    @IBOutlet weak var sixConfidence: UILabel!
    @IBOutlet weak var sevenConfidence: UILabel!
    @IBOutlet weak var eightConfidence: UILabel!
    @IBOutlet weak var nineConfidence: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        confidenceDescription.text = "Run the code in the playground to get your results! This view is interactable and you can SCROLL DOWN if content gets cut off."
        confidenceLabels.forEach { $0.text = "" }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: liveViewSafeAreaGuide.rightAnchor),
            scrollView.leftAnchor.constraint(equalTo: liveViewSafeAreaGuide.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor)
            ])
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func display(confidences: [ObjectConfidence]) {
        var iteration = 0
        for confidence in confidences.sorted(by: >) {
            switch iteration {
            case 0:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                zeroConfidence.text = "\(confidence.object) - \(percent)"
            case 1:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                oneConfidence.text = "\(confidence.object) - \(percent)"
            case 2:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                twoConfidence.text = "\(confidence.object) - \(percent)"
            case 3:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                threeConfidence.text = "\(confidence.object) - \(percent)"
            case 4:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                fourConfidence.text = "\(confidence.object) - \(percent)"
            case 5:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                fiveConfidence.text = "\(confidence.object) - \(percent)"
            case 6:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                sixConfidence.text = "\(confidence.object) - \(percent)"
            case 7:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                sevenConfidence.text = "\(confidence.object) - \(percent)"
            case 8:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                eightConfidence.text = "\(confidence.object) - \(percent)"
            case 9:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                nineConfidence.text = "\(confidence.object) - \(percent)"
            default:
                continue
            }
            iteration += 1
        }
    }
}

// MARK: - Live view message handler

extension ObjectRecognitionResultViewController: PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        guard let message = PlaygroundMessageToLiveView(playgroundValue: message) else { return }
        switch message {
        case .showObjectMLResults(confidences: let confidences, objectImage: let objectImage):
            self.objectImage.image = objectImage
            guard let probableObjectConfidence = confidences.max() else { return }
            topResult.text = "The object is a(n) \(probableObjectConfidence.object)!"
            confidenceDescription.text = "Here are the percentages of how confident the Convolutional Neural Network was for other potential objects (this page is scrollable, so don't forget to scroll if it gets cut off!):"
            display(confidences: confidences)
        default:
            break
        }
    }
}
