import UIKit

public protocol StoryboardInstantiatable: class {
    static var storyboardIdentifier: String { get }
    static func instantiateFromStoryboard<T: UIViewController>() -> T
}

extension StoryboardInstantiatable {
    public static func instantiateFromStoryboard<T: UIViewController>() -> T {
        let bundle = Bundle(for: T.self)
        let storyboard = UIStoryboard(name: "PixelFun", bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! T
    }
}
