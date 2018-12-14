import UIKit
import RxSwift
import RxCocoa

extension UITableViewCell: Reusable {}

extension UITableView {
    
    /// Gets the cell identifier by reuseId
    func dequeueReusableCell<T>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseId,
                                             for: indexPath) as? T else {
                                                fatalError()
        }
        return cell
    }
}

extension UIScrollView {
    
    /// Notifies when tableview is in the bottom
    var rx_reachedBottom: Observable<Void> {
        return rx.contentOffset
            .flatMap { [weak self] contentOffset -> Observable<Void> in
                guard let scrollView = self else {
                    return Observable.empty()
                }
                
                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
                
                return y > threshold ? Observable.just(()) : Observable.empty()
        }
    }
}
