import UIKit
import SceneKit
import ARKit
import PlaygroundSupport

@objc(ARDrawingViewController)
public class ARDrawingViewController: UIViewController, ARSCNViewDelegate, PlaygroundLiveViewSafeAreaContainer, StoryboardInstantiatable {
    
    public static let storyboardIdentifier = "arDrawingVC"
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var drawButton: UIButton!
    
    private var previousPoint: SCNVector3?
    var lineColor: UIColor = .white
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        NSLayoutConstraint.activate([
            drawButton.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor, constant: -5)
            ])
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup right before the view will appear.
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Do any cleanup right before the view will disappear.
        sceneView.session.pause()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Scene view delegate
    
    public func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else { return }
        
        let matrix = pointOfView.transform
        let dir = SCNVector3(x: -1 * matrix.m31 * 0.1, y: -1 * matrix.m32 * 0.1, z: -1 * matrix.m33 * 0.1)
        let currentPosition = pointOfView.position + dir

        if drawButton.isHighlighted {
            if let previousPoint = previousPoint {
                let generatedLine = line(fromVector: previousPoint, toVector: currentPosition)
                let lineNode = SCNNode(geometry: generatedLine)
                lineNode.geometry?.firstMaterial?.diffuse.contents = lineColor
                sceneView.scene.rootNode.addChildNode(lineNode)
            }
        }

        previousPoint = currentPosition
    }
    
    func line(fromVector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        return SCNGeometry(sources: [source], elements: [element])
    }
    
}

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

// MARK: - Live view message handler

extension ARDrawingViewController: PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        guard let liveViewMessage = PlaygroundMessageToLiveView(playgroundValue: message) else { return }
        
        switch liveViewMessage {
        case .updateDrawingColor(let color):
            lineColor = color
        default:
            break
        }
    }
}
