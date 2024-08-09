//
//  Coordinator.swift
//  Rick&Morty

import UIKit

// MARK: Protocol

protocol CoordinatorProtocol: AnyObject {
	var navigationController: UINavigationController { get }
	func startMain()
	func openScreen(viewController: UIViewController) 
	func navigateBack()
}

// MARK: Class

final class MainCoordinator: CoordinatorProtocol {
	
	// MARK: Properties
	
	var navigationController: UINavigationController
	
	// MARK: Initialization
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
		print("init coordin")
	}
	
	// MARK: Methods
	
	private func setStartViewController() -> UIViewController {
		let viewModel = EpisodesViewModel()
		viewModel.coordinator = self
		let episodes = EpisodesViewController(viewModel: viewModel)
		let favourites = FavouriteEpisodeViewController(viewModel: viewModel)
		let tabbarController = TabbarViewController(episodes: episodes, favourites: favourites)
		return tabbarController
	}
	
	func startMain() {
		let mainViewController = LaunchScreenViewController()
		navigationController.pushViewController(mainViewController, animated: true)
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.startNext()
		}
	}
	
	private func startNext() {
		var viewControllers = navigationController.viewControllers
		viewControllers.removeAll { $0 is LaunchScreenViewController }
		let episodeViewController = setStartViewController()
		viewControllers.append(episodeViewController)
		navigationController.setViewControllers(viewControllers, animated: true)
	}
	
	func openScreen(viewController: UIViewController) {
		navigationController.pushViewController(viewController, animated: true)
	}
	
	func navigateBack() {
		navigationController.popViewController(animated: true)
	}
}

