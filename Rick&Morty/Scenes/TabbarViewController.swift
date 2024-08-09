//
//  TabbarViewController.swift
//  Rick&Morty

import UIKit

final class TabbarViewController: UITabBarController {
	
	// MARK: Properties
	
	let episodes: UIViewController
	let favourites: UIViewController
	
	// MARK: Init
	
	init(episodes: UIViewController, favourites: UIViewController) {
		self.episodes = episodes
		self.favourites = favourites
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: LifeCycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tabBar.backgroundColor = .systemGray5
		self.viewControllers = [episodes, favourites]
	
		setupTabbar()
	}
	
	// MARK: Methods
	
	private func setupTabbar() {
		
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
	}
}
