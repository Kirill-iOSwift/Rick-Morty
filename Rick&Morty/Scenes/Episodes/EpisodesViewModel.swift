//
//  EpisodesViewModel.swift
//  Rick&Morty

import Foundation

// MARK: Protocol View Model

protocol EpisodesViewModelProtocol: AnyObject {
	func load(complition: @escaping ([EpisodeTest]) -> Void)
}

// MARK: Class

class EpisodesViewModel: EpisodesViewModelProtocol {
	
	// MARK: Properties
	
	var items = [EpisodeTest]()
	
	// MARK: Dependency
	
	weak var network: NetworkManagerProtocol?
	
	// MARK: Methods
	
	func load(complition: @escaping ([EpisodeTest]) -> Void) {
		network?.fetchEpisodeData { models in
			complition(models)
		}
	}
	
	// MARK: Initialization
	
	init(network: NetworkManagerProtocol) {
		self.network = network
	}

	// TODO: - Получение избранного
	
	func toggleFavorite(for item: EpisodeTest) {
		print("!!!!")
		if !items.contains(where: { $0.id == item.id }) {
			print("!!!!")
			items.append(item)
		} else {
			guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
			print("!!!!")
			items.remove(at: index)
		}
	}
}

