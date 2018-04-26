import PlaygroundSupport
import UIKit

@objc(DigitRecognitionResultViewController)
public class DigitRecognitionResultViewController: UIViewController, StoryboardInstantiatable, PlaygroundLiveViewSafeAreaContainer {
    
    public static let storyboardIdentifier = "digitResultVC"
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var topResult: UILabel!
    @IBOutlet weak var confidenceDescription: UILabel!
    
    @IBOutlet weak var handwritingImage: UIImageView!
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
        
        handwritingImage.image = loadHandwritingImage()
        
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
    
    private func loadHandwritingImage() -> UIImage {
        if let playgroundImage = PlaygroundKeyValueStore.current["handwritingImage"], case let .data(imageData) = playgroundImage, let image = UIImage(data: imageData) {
            return image
        } else {
            return #imageLiteral(resourceName: "handwritingimage")
        }
    }
    
    private func display(confidences: [DigitConfidence]) {
        for confidence in confidences {
            switch confidence.digit {
            case 0:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                zeroConfidence.text = "0 - \(percent)"
            case 1:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                oneConfidence.text = "1 - \(percent)"
            case 2:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                twoConfidence.text = "2 - \(percent)"
            case 3:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                threeConfidence.text = "3 - \(percent)"
            case 4:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                fourConfidence.text = "4 - \(percent)"
            case 5:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                fiveConfidence.text = "5 - \(percent)"
            case 6:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                sixConfidence.text = "6 - \(percent)"
            case 7:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                sevenConfidence.text = "7 - \(percent)"
            case 8:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                eightConfidence.text = "8 - \(percent)"
            case 9:
                guard let percent = confidence.confidence.formatToPercent() else { continue }
                nineConfidence.text = "9 - \(percent)"
            default:
                continue
            }
        }
    }
}

// MARK: - Live view message handler

extension DigitRecognitionResultViewController: PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        guard let message = PlaygroundMessageToLiveView(playgroundValue: message) else { return }
        switch message {
        case .showHandwritingMLResults(confidences: let confidences):
            guard let probableDigitConfidence = confidences.max() else { return }
            topResult.text = "The number is \(probableDigitConfidence.digit)!"
            confidenceDescription.text = "Here are the percentages of how confident the Convolutional Neural Network was for other numbers (this page is scrollable, so don't forget to scroll if it gets cut off!):"
            display(confidences: confidences)
        default:
            break
        }
    }
}
