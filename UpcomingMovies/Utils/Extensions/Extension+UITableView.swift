import UIKit

extension UITableViewCell: Reusable {}

extension UITableView {
    
    func dequeueReusableCell<T>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseId,
                                             for: indexPath) as? T else {
                                                fatalError()
        }
        return cell
    }
    
    func  isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
    
}
