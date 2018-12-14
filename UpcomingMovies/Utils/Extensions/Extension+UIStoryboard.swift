import UIKit

extension UIViewController: Reusable {}

extension UIStoryboard {
    
    /// Gets the view controller identifier by reuseId
    func instantiateViewController<T>(ofType type: T.Type = T.self) -> T where T: UIViewController {
        guard let viewController = instantiateViewController(withIdentifier: type.reuseId) as? T else {
            fatalError()
        }
        return viewController
    }
}
