import UIKit
final class TabBarController: UITabBarController {


    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setupTabBar()
    }

    private func generateTabBar() {
        let catalogPresenter = CatalogPresenter()
        let catalogViewController = CatalogViewController(presenter: catalogPresenter)
        catalogPresenter.view = catalogViewController

        let profileNav = UINavigationController(rootViewController: ProfileViewController(nftServise: NetworkNFTService()))
        let catalogNav = UINavigationController(rootViewController: catalogViewController)
        let shoppingСartNav = UINavigationController(rootViewController: ShoppingСartViewController())
        let statisticNav = UINavigationController(rootViewController: StatisticViewController())

        viewControllers = [
            generateVC(viewController: profileNav,
                       title: "Профиль",
                       image: UIImage(systemName: "person.crop.circle.fill")),
            generateVC(viewController: catalogNav,
                       title: "Каталог",
                       image: UIImage(systemName: "rectangle.stack.fill")),
            generateVC(viewController: shoppingСartNav,
                       title: "Корзина",
                       image: UIImage(systemName: "bag.fill")),
            generateVC(viewController: statisticNav,
                       title: "Статистика",
                       image: UIImage(systemName: "flag.2.crossed.fill"))
        ]
    }
    private func generateVC(viewController: UINavigationController,
                            title: String,
                            image: UIImage?) -> UINavigationController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image

        return viewController
    }

    private func setupTabBar() {
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .black
    }
}
