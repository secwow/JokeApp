import DomainLogic
import UIKit

protocol MainBarDelegate: AnyObject {
    func didSelectedJokesFeed(navigation: UINavigationController)
    func didSelectedMyJokes(navigation: UINavigationController)
    func didSelectedSettings(navigation: UINavigationController)
}

protocol ShareDelegate: AnyObject {
    func share(_ joke: String)
}

class AppCoordinator: BaseCoordinator {
    let router: Router
    let remoteLoader: JokesLoader
    let localLoader: JokesLoader
    let service: InMemoryJokesStore
    let networkService: ReplacingState
    
    init(router: Router,
         remoteLoader: JokesLoader,
         localLoader: JokesLoader,
         service: InMemoryJokesStore,
         networkService: ReplacingState) {
        self.router = router
        self.remoteLoader = remoteLoader
        self.localLoader = localLoader
        self.service = service
        self.networkService = networkService
    }
    
    override func start() {
        let tab = MainTabBarViewController(delegate: self)
        self.router.setRootModule(tab, hideBar: true)
    }
    
    func presentAddNewJoke() {
        let vc = AddNewJokeComposer.compose(service)
        vc.modalPresentationStyle = .overFullScreen
        
        vc.cancel = { [weak self] in
            self?.router.dismissModule()
        }
        
        vc.save = { [weak self] _ in
            self?.router.dismissModule()
        }
        self.router.present(vc)
    }
}

extension AppCoordinator: MainBarDelegate {
    func didSelectedJokesFeed(navigation: UINavigationController) {
        if navigation.viewControllers.isEmpty == true {
            navigation.pushViewController(JokeListComposer.compose(jokesLoader: remoteLoader,
                                                                   jokesFavourite: service,
                                                                   networkInstructor: networkService,
                                                                   shareDelegate: self),
                                          animated: false)
        }
    }
    
    func didSelectedMyJokes(navigation: UINavigationController) {
        if navigation.viewControllers.isEmpty == true {
            let (vc, viewModel) = MyJokeListComposer.compose(jokesLoader: localLoader,
                                                jokesDeletionService: service)
            vc.addNewJoke = { [weak self] in
                self?.presentAddNewJoke()
            }
            
            service.onUpdate = { [weak viewModel] in
                viewModel?.loadFeed()
            }
            
            navigation.pushViewController(vc, animated: false)
        }
    }
    
    func didSelectedSettings(navigation: UINavigationController) {
        if navigation.viewControllers.isEmpty == true {
            let vc = SettingsComposer.compose(service: networkService)
            navigation.pushViewController(vc, animated: false)
        }
    }
}

extension AppCoordinator: ShareDelegate {
    func share(_ joke: String) {
        let activityViewController = UIActivityViewController(activityItems: [joke], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.router.present(activityViewController)
    }
}
