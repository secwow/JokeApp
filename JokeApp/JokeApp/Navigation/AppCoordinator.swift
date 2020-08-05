import DomainLogic
import UIKit

protocol MainBarDelegate: AnyObject {
    func didSelected(tab: MainTabBarViewController.Tabs, navigation: UINavigationController)
}

protocol ShareDelegate: AnyObject {
    func share(_ joke: String)
}

class AppCoordinator: Coordinator {
    let router: Router
    let serviceFactory: ServiceFactory
    
    init(router: Router,
         serviceFactory: ServiceFactory) {
        self.router = router
        self.serviceFactory = serviceFactory
    }
    
    func start() {
        let tab = MainTabBarViewController(delegate: self)
        self.router.setRootModule(tab, hideBar: true)
    }
    
    func presentAddNewJoke() {
        let dismissClosure: (() -> ())? = { [weak self] in
            self?.router.dismissModule()
        }
        let vc = AddNewJokeComposer.compose(serviceFactory.storage,
                                            onClose: dismissClosure,
                                            onSave: dismissClosure)
        
        self.router.present(vc)
    }
}

extension AppCoordinator: MainBarDelegate {
    func didSelected(tab: MainTabBarViewController.Tabs, navigation: UINavigationController) {
        guard navigation.viewControllers.isEmpty else {
            return
        }
        
        switch tab {
            
        case .jokesFeed:
            navigation.pushViewController(JokeListComposer.compose(jokesLoader: serviceFactory.mainLoader,
                                                                   jokesFavourite: serviceFactory.storage,
                                                                   networkInstructor: serviceFactory.reaplacingInstructor,
                                                                   shareDelegate: self),
                                          animated: false)
        case .myJokes:
            let (vc, viewModel) = MyJokeListComposer.compose(jokesLoader: serviceFactory.storage,
                                                             jokesDeletionService: serviceFactory.storage)
            vc.addNewJoke = { [weak self] in
                self?.presentAddNewJoke()
            }
            
            serviceFactory.storage.onUpdate = { [weak viewModel] in
                viewModel?.loadFeed()
            }
            
            navigation.pushViewController(vc, animated: false)
        case .settings:
            let vc = SettingsComposer.compose(service: serviceFactory.reaplacingInstructor)
            navigation.pushViewController(vc, animated: false)
        }
    }
}

extension AppCoordinator: ShareDelegate {
    func share(_ joke: String) {
        let activityViewController = UIActivityViewController(activityItems: [joke], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]
        self.router.present(activityViewController)
    }
}
