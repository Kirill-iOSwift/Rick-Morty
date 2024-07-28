//
//  Coordinator.swift
//  Rick&Morty
//
//  Created by Кирилл on 21.07.2024.
//

import UIKit

protocol CoordinatorProtocol {
	var navigationController: UINavigationController { get }
	func startMain()
	func startNext()
}

class MainCoordinator: CoordinatorProtocol {
	
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func startMain() {
		let mainViewController = LaunchScreenViewController()
		mainViewController.coordinator = self
		navigationController.pushViewController(mainViewController, animated: true)
	
	}
	
	func startNext() {
		let episodeViewController = setStartViewController()
		navigationController.pushViewController(episodeViewController, animated: true)
	}
	
		private func setStartViewController() -> UIViewController {
			let tabbarController = UITabBarController()
			let network = NetworkManager()
			let viewModel = EpisodesViewModel(network: network)
			let episodes = EpisodesViewController(viewModel: viewModel)
			let favourites = FavouriteEpisodeViewController(viewModel: viewModel)
			tabbarController.viewControllers = [episodes, favourites]
	
			episodes.tabBarItem = UITabBarItem(title: "Episode", image: UIImage(systemName: "house"), tag: 0)
	
			favourites.tabBarItem = UITabBarItem(
				title: "Favourites",
				image: UIImage(systemName: "heart"),
				tag: 1
			)
	
			tabbarController.tabBar.backgroundColor = .systemGray6
	
			return tabbarController
		}
	
	
}

