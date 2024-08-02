//
//  Coordinator.swift
//  Rick&Morty


import UIKit

// MARK: - Coordinator

// MARK: Protocol

protocol CoordinatorProtocol {
	var navigationController: UINavigationController { get }
	func startMain()
	func startNext()
	func startBack()
}

// MARK: Class

class MainCoordinator: CoordinatorProtocol {
	
	// MARK: Properties
	
	var navigationController: UINavigationController
	
	// MARK: Initialization
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	// MARK: Methods
	
	private func setStartViewController() -> UIViewController {
		let tabbarController = UITabBarController()
		let network = NetworkManager()
		let viewModel = EpisodesViewModel(network: network)
		let episodes = EpisodesViewController(viewModel: viewModel)
		let favourites = FavouriteEpisodeViewController(viewModel: viewModel)
		tabbarController.viewControllers = [episodes, favourites]
		
		episodes.tabBarItem = UITabBarItem(
			title: "Episode",
			image: UIImage(systemName: "house"),
			selectedImage: UIImage(systemName: "house.fill")
		)
		
		favourites.tabBarItem = UITabBarItem(
			title: "Favourites",
			image: UIImage(systemName: "heart"),
			selectedImage: UIImage(systemName: "heart.fill")
		)
		
		tabbarController.tabBar.backgroundColor = .systemGray6
		
		return tabbarController
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
	
	func startBack() {
		navigationController.popViewController(animated: true)
	}
}

