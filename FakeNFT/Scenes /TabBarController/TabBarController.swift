
import Foundation
import UIKit

class TabBarController: UITabBarController{
    let profileVC = ProfileViewController()
    let catalogVC = CatalogViewController()
    let shoppingСart = ShoppingСartViewController()
    let statisticVC = StatisticViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setupTabBar()
    }
    private func generateTabBar(){
        let profileNav = UINavigationController(rootViewController: profileVC)
        let catalogNav = UINavigationController(rootViewController: catalogVC)
        let shoppingСartNav = UINavigationController(rootViewController: shoppingСart)
        let statisticNav = UINavigationController(rootViewController: statisticVC)
        viewControllers = [
            generateVC(viewController: profileNav,  title: "Профиль", image: UIImage(systemName: "person.crop.circle.fill")),
            generateVC(viewController: catalogNav,  title: "Каталог", image: UIImage(systemName: "rectangle.stack.fill")),
            generateVC(viewController: shoppingСartNav,title: "Корзина", image: UIImage(systemName: "bag.fill")),
            generateVC(viewController: statisticNav,title: "Статистика", image: UIImage(systemName: "flag.2.crossed.fill"))
        ]
    }
    private func generateVC(viewController: UINavigationController, title: String, image: UIImage?) -> UINavigationController{
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        
        return viewController
        
    }
    private func setupTabBar(){
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .black
    }
}

