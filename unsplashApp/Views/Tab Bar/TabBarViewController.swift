//
//  TabBarViewController.swift
//  unsplashApp
//
//  Created by Илья Тимченко on 12.06.2023.
//

import UIKit

/// View-Controller for the tab bar
final class TabBarViewController: UITabBarController {
    
    /// Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        let feed = ImageFeedViewController()
        feed.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house"), tag: 0)
        let favourites = FavouritesViewController()
        favourites.tabBarItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: "heart"), tag: 1)
        let viewModel = ViewModel()
        let model = Model()
        viewModel.model = model
        feed.viewModel = viewModel
        favourites.viewModel = viewModel
        viewControllers = [feed, favourites]
    }
    
}
