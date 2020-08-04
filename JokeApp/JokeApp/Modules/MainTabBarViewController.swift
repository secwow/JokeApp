import UIKit

class MainTabBarViewController: UITabBarController {
    private weak var tabDelegate: MainBarDelegate?
    
    init(delegate: MainBarDelegate) {
        self.tabDelegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    enum MainTab: Int {
        case jokesFeed = 0
        case myJokes
        case settings
    }
    
    override var selectedIndex: Int {
        didSet {
            self.tabBarController(self, didSelect: viewControllers![selectedIndex])
        }
    }
    
    func setupTabBar() {
        self.tabBar.items?[MainTab.jokesFeed.rawValue].title = MainTab.jokesFeed.titleTab
        self.tabBar.items?[MainTab.myJokes.rawValue].title = MainTab.myJokes.titleTab
        self.tabBar.items?[MainTab.settings.rawValue].title = MainTab.settings.titleTab
        
        self.tabBar.tintColor = .red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vcs = [UINavigationController(),
                   UINavigationController(),
                   UINavigationController()]
        vcs.forEach { (controller) in
            controller.isNavigationBarHidden = true
        }
        viewControllers = vcs
        
        delegate = self
        setupTabBar()
        
        if let controller = customizableViewControllers?.first as? UINavigationController {
            tabDelegate?.didSelectedJokesFeed(navigation: controller)
        }
        
    }
}

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController,
            let tabIndex = MainTab(rawValue: selectedIndex) else { return }
        
        switch tabIndex {
        case .jokesFeed:
            self.tabDelegate?.didSelectedJokesFeed(navigation: controller)
        case .myJokes:
            self.tabDelegate?.didSelectedMyJokes(navigation: controller)
        case .settings:
            self.tabDelegate?.didSelectedSettings(navigation: controller)
        }
    }
}

extension MainTabBarViewController.MainTab {
    var titleTab: String {
        switch self {
        case .jokesFeed:
            return "Feed"
        case .myJokes:
            return "My Jokes"
        case .settings:
            return "Settings"
        }
    }
}
