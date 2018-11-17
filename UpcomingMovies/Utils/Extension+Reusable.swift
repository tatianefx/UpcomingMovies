import Foundation

protocol Reusable {
    static var reuseId: String { get }
}

extension Reusable {
    static var reuseId: String {
        return String(describing: self)
    }
}
