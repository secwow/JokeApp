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
    
    enum Tabs: Int {
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
        self.tabBar.items?[Tabs.jokesFeed.rawValue].title = Tabs.jokesFeed.titleTab
        self.tabBar.items?[Tabs.myJokes.rawValue].title = Tabs.myJokes.titleTab
        self.tabBar.items?[Tabs.settings.rawValue].title = Tabs.settings.titleTab
        
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
            tabDelegate?.didSelected(tab: .jokesFeed, navigation: controller)
        }
    }
}

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController,
            let tab = Tabs(rawValue: selectedIndex) else { return }
        tabDelegate?.didSelected(tab: tab, navigation: controller)
    }
}

extension MainTabBarViewController.Tabs {
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
