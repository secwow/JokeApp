import DomainLogic
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: Coordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        startFlow()
        
        return true
    }
    
    func startFlow() {
        window = UIWindow()
        
        let navigationController = UINavigationController()
        let router = ApplicationRouter(rootController: navigationController)
        self.coordinator = AppCoordinator(router: router,
        serviceFactory: ServiceFactory())
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        coordinator?.start()
    }
}

