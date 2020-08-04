import Foundation

class BaseCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []

    func start() {

    }

    func addDependency(_ coordinator: Coordinator) {
        if self.childCoordinators.contains(where: {$0 === coordinator}) {
            return
        }

        childCoordinators.append(coordinator)
    }

    func removeDependency(_ coordinator: Coordinator?) {
        guard let coordinator = coordinator, !childCoordinators.isEmpty else { return }

        if let coordinator = coordinator as? BaseCoordinator {
            coordinator.childCoordinators.filter({ $0 !== coordinator }).forEach({ coordinator.removeDependency($0) })
        }

        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
}

