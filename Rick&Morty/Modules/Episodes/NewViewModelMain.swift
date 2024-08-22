//
//  NewViewModelMain.swift
//  Rick&Morty

import Foundation

enum MainModel: Hashable {
	enum Section: Hashable  {
		case main
	}
	enum Structure: Hashable  {
		case episodes(Episode)
	}
}

protocol VMProtocol: AnyObject {
	var episodes: [Episode] { get set }
	var coordinator: CoordinatorProtocol? { get }
	var updateUI: (() -> Void)? { get set }
	
	func removeEpisode(item: Episode)
	func isFavouriteToggle(for episode: Episode)
	func filterEpisodes(by searchText: String)
	
	func createCharcterVC(episode: Episode)
	func createViewModelCell(episode: Episode) -> ViewModelCollectionCellProtocol
	
	var updateFavor: (([Episode]) -> Void)? { get set }
}

extension VMProtocol {
	func sortName() {
		episodes.sort { $0.nameEpisode < $1.nameEpisode }
	}

	func sortSeason() {
		episodes.sort { $0.numberEpisode < $1.numberEpisode }
	}
}

final class NewViewModelMain: VMProtocol {
	
//	private let mainEpisodes = RickAndMortyProvider()
	private let networkManager = NetworkManager()
	private var originalEpisides: [Episode] = []
	
	var episodes: [Episode] = [] {
		didSet {
			print(episodes.count)
			updateUI?()
			updateFavor?(episodes)
		}
	}
	var updateUI: (() -> Void)?
	var updateFavor: (([Episode]) -> Void)?
	
	weak var coordinator: CoordinatorProtocol?
	
	init(coordinator: CoordinatorProtocol) {
		self.coordinator = coordinator
		loadData()
	}

	private func loadData() {
		networkManager.fetchEpisodeData { episodes in
			self.originalEpisides = episodes
			self.episodes = episodes
		}
	}
	
	func removeEpisode(item: Episode) {
		if let index = episodes.firstIndex(where: { $0.id == item.id }) {
			episodes.remove(at: index)
		}
	}
	
	func isFavouriteToggle(for episode: Episode) {
		if let index = episodes.firstIndex(where: { $0.id == episode.id }) {
			episodes[index].isFavourite.toggle()
		}
//		print(episodes.filter { $0.isFavourite }.count)
	}
	
	func createCharcterVC(episode: Episode) {
		coordinator?.createCharcterVC(episode: episode)
	}
	
	func createViewModelCell(episode: Episode) -> ViewModelCollectionCellProtocol {
		return ViewModelCollectionCell(episode: episode)
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
