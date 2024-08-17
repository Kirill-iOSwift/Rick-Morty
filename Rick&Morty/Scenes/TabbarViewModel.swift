//
//  TabbarViewModel.swift
//  Rick&Morty

import Foundation

protocol TabbarViewModelProtocol: AnyObject {
	var episodes: [Episode] { get set }
}

class TabbarViewModel: TabbarViewModelProtocol {
	
	var episodes = [Episode]()
	
	init() {
		fetchEpisodes()
	}
	
	func fetchEpisodes() {
		let networkManager = NetworkManager()
		networkManager.fetchEpisodeData { [weak self] episodes in
			self?.episodes = episodes
		}
	}
}
