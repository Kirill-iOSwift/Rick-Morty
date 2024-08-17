//
//  EpisodesViewModel.swift
//  Rick&Morty

import UIKit

// MARK: Protocol

protocol EpisodesViewModelProtocol: AnyObject {
	var episodes: [Episode] { get }
	func fetchData()
	
	var updateUI: (() -> Void)? { get set }
	
	func toggleFavorite(for episode: Episode)
	func removeEpisode(item: Episode)
	
	func cellViewModel(indexPath: IndexPath) -> EpisodeCellViewModelProtocol
	func getViewModelCharacter(item: Episode) -> CharacterTableViewModelProtocol?
	func openCell(viewController: UIViewController)
	
	func sortName()
	func sortSeason()
	
	func filterEpisodes(by searchText: String)
}

// MARK: Class

final class EpisodesViewModel: EpisodesViewModelProtocol {
	
	// MARK: Properties
	
	private let network = NetworkManager()
	let favouritesManager = FavoritesManager()

	
	private var originalEpisides = [Episode]()
	
	var episodes: [Episode] = [] {
		didSet {
			updateUI?()
		}
	}

	var updateUI: (() -> Void)?
	var coordinator: CoordinatorProtocol?
	
	init() {
		episodes = originalEpisides
		fetchData()
	}

	// MARK: Methods

	func fetchData() {
		network.fetchEpisodeData { models in
			self.originalEpisides = models
			self.episodes = models
		}
	}
	
	func cellViewModel(indexPath: IndexPath) -> EpisodeCellViewModelProtocol {
		let episode = episodes[indexPath.row]
		return EpisodeCellViewModel(episode: episode)
	}
	
	func openCell(viewController: UIViewController) {
		coordinator?.openScreen(viewController: viewController)
		
	}
	
	func getViewModelCharacter(item: Episode) -> CharacterTableViewModelProtocol? {
		let cellViewController = CharacterTableViewModel(character: item)
		cellViewController.coordinator = coordinator
		return cellViewController
	}

	func toggleFavorite(for episode: Episode) {
		if let index = episodes.firstIndex(where: { $0.id == episode.id }) {
			episodes[index].isFavourite.toggle()			
		}
	}

	func removeEpisode(item: Episode) {
		if let index = episodes.firstIndex(where: { $0.id == item.id }) {
			episodes.remove(at: index)
		}
	}
	
	func sortName() {
		episodes.sort { $0.nameEpisode < $1.nameEpisode }
	}
	
	func sortSeason() {
		episodes.sort { $0.numberEpisode < $1.numberEpisode}
	}
	
	func filterEpisodes(by searchText: String) {
		if searchText.isEmpty {
			episodes = originalEpisides
		} else {
			episodes = episodes.filter { episode in
				let episodeSuffix = episode.numberEpisode.suffix(2)
				return episodeSuffix.contains(searchText)
			}
		}
	}
}

