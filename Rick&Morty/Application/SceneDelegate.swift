//
//  SceneDelegate.swift
//  Rick&Morty
//
//  Created by Кирилл on 12.07.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	var coordinator: CoordinatorProtocol?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: windowScene)
		
		let navigationController = UINavigationController()
		navigationController.setNavigationBarHidden(true, animated: false)
		coordinator = MainCoordinator(navigationController: navigationController)
		coordinator?.startMain()
		
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
		
		self.window = window
	}
	
//	private func showStartViewController() {
//		let vs = LaunchScreenViewController()
//		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//			self.setStartViewController()
//		}
//	}
	
//	private func setStartViewController() -> UIViewController {
//		let tabbarController = UITabBarController()
//		let episodes = EpisodesViewController()
//		let favourites = FavoriteEpisodeViewController()
//		tabbarController.viewControllers = [episodes, favourites]
//		
//		episodes.tabBarItem = UITabBarItem(
//			title: "Episodes",
//			image: UIImage(systemName: "house"),
//			tag: 0
//		)
//		
//		favourites.tabBarItem = UITabBarItem(
//			title: "Favourites",
//			image: UIImage(systemName: "heart"),
//			tag: 1
//		)
//		
//		tabbarController.tabBar.backgroundColor = .systemGray6
//		
//		return UINavigationController(rootViewController: tabbarController)
//	}
}

