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
	
	let network = NetworkManager()
	
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func startMain() {
		network.fetchData()
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
			let episodes = EpisodesViewController(network: network)
			let favourites = FavouriteEpisodeViewController()
			tabbarController.viewControllers = [episodes, favourites]
	
			episodes.tabBarItem = UITabBarItem(
				title: "Episodes",
				image: UIImage(systemName: "house"),
				tag: 0
			)
	
			favourites.tabBarItem = UITabBarItem(
				title: "Favourites",
				image: UIImage(systemName: "heart"),
				tag: 1
			)
	
			tabbarController.tabBar.backgroundColor = .systemGray6
	
			return tabbarController
		}
	
	
}

