import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupTabBarColors()
    }
    
    private func setupTabBar() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let shortsVC = ShortsTabViewController()
        shortsVC.tabBarItem = UITabBarItem(
            title: "Shorts",
            image: UIImage(systemName: "play.rectangle.on.rectangle"),
            selectedImage: UIImage(systemName: "play.rectangle.on.rectangle.fill")
        )
        
        let createVC = UIViewController()
        createVC.view.backgroundColor = .systemBackground
        createVC.title = "Create"
        createVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "plus.circle.fill"),
            selectedImage: UIImage(systemName: "plus.circle.fill")
        )
        
        let subscriptionsVC = UIViewController()
        subscriptionsVC.view.backgroundColor = .systemBackground
        subscriptionsVC.title = "Subscriptions"
        subscriptionsVC.tabBarItem = UITabBarItem(
            title: "Subscriptions",
            image: UIImage(systemName: "play.square.stack"),
            selectedImage: UIImage(systemName: "play.square.stack.fill")
        )
        
        let libraryVC = UIViewController()
        libraryVC.view.backgroundColor = .systemBackground
        libraryVC.title = "You"
        libraryVC.tabBarItem = UITabBarItem(
            title: "You",
            image: UIImage(systemName: "person.circle"),
            selectedImage: UIImage(systemName: "person.circle.fill")
        )
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let shortsNav = UINavigationController(rootViewController: shortsVC)
        let createNav = UINavigationController(rootViewController: createVC)
        let subscriptionsNav = UINavigationController(rootViewController: subscriptionsVC)
        let libraryNav = UINavigationController(rootViewController: libraryVC)
        
        viewControllers = [homeNav, shortsNav, createNav, subscriptionsNav, libraryNav]
    }
    
    private func setupTabBarColors() {
        tabBar.tintColor = .label
        tabBar.unselectedItemTintColor = .secondaryLabel
        tabBar.backgroundColor = .systemBackground
    }
}
