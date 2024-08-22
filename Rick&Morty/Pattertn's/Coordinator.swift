//
//  Coordinator.swift
//  Rick&Morty

import UIKit

// MARK: Protocol

protocol CoordinatorProtocol: AnyObject {
	var navigationController: UINavigationController { get }
	func startMain()
	func navigateBack()
	
	func createCharcterVC(episode: Episode)
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

		let main = AssemblyMainTabbar()
		let mainViewModel = main.createMainViewModel(coordinator: self)
		
		let episodec = AssemblyEpisodes()
		let episodecView = episodec.createEpisodes(mainViewModel: mainViewModel)
		
		
		let favorites = AssemblyFavouritesEpisodes()
		let favouritesView = favorites.createFavouritesEpisodes(mainViewModel: mainViewModel)
		
		let tabbar = main.createTabbar(episodes: episodecView, favotites: favouritesView)
		
		return tabbar
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
	
	func navigateBack() {
		navigationController.popViewController(animated: true)
	}
	
	func createCharcterVC(episode: Episode) {
		let assebly = AssemblyCharacter()
		let character = assebly.create(episode: episode, coordinator: self)
		navigationController.pushViewController(character, animated: true)
	}
}

