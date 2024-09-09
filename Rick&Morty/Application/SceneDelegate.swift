//
//  SceneDelegate.swift
//  Rick&Morty

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

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
}

