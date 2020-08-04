import DomainLogic
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: Coordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let client = SessionHTTPClient(session: URLSession.shared)
        let remoteJokesLoader = RemoteJokesLoader(url: URL(string: "http://api.icndb.com/jokes/random/10")!,
                                                  client: client)
        let inMemoryCache = InMemoryCachedJokesStore()
        let replacingState = ReplacingState()
        
        
        let localJokesLoader = LocalJokesLoader(with: inMemoryCache, currentDate: Date.init)
        let replacer = ChuckNorrisReplaceDecorator(decoratee: localJokesLoader, service: replacingState)
        
        let mainLoader = JokesLoaderCompositor(primaryLoader: CachedJokesLoader(decoratee: remoteJokesLoader,
                                                                                cache: localJokesLoader),
                                               secondaryLoader: replacer,
                                               instructor: replacingState)
        let store = InMemoryJokesStore()
        
        
        let navigationController = UINavigationController()
        window = UIWindow()
        
        let router = RouterImp(rootController: navigationController)
        self.coordinator = AppCoordinator(router: router,
                                          window: window!,
                                          remoteLoader: mainLoader,
                                          localLoader: MainQueueDispatchDecorator(store),
                                          service: store,
                                          networkService: replacingState)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        coordinator?.start()
        
        return true
    }
}

