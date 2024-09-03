import Foundation

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get }
}

extension Coordinator {
    var parentCoordinator: Coordinator? {
        nil
    }
}
