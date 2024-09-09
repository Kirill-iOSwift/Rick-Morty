//
//  ViewModelEpisode.swift
//  Rick&Morty

import Foundation

protocol ViewModelEpisodeProtocol: AnyObject {
	var episodes: [Episode] { get set }
	var coordinator: CoordinatorProtocol? { get }
	var updateUI: (() -> Void)? { get set }
	
	func removeEpisode(item: Episode)
	func isFavouriteToggle(for episode: Episode)
	func filterEpisodes(by searchText: String)
	
	func createCharcterVC(episode: Episode)
	func createViewModelCell(episode: Episode) -> ViewModelCollectionCellProtocol
	
	var updateFavor: ((Episode) -> Void)? { get set }
}

extension ViewModelEpisodeProtocol {
	func sortName() {
		episodes.sort { $0.nameEpisode < $1.nameEpisode }
	}

	func sortSeason() {
		episodes.sort { $0.numberEpisode < $1.numberEpisode }
	}
}

final class ViewModelEpisode: ViewModelEpisodeProtocol {
	
	private let networkManager = NetworkManager()
	private var originalEpisides: [Episode] = []
	
	var episodes: [Episode] = [] {
		didSet {
			updateUI?()
		}
	}
	var updateUI: (() -> Void)?
	var updateFavor: ((Episode) -> Void)?
	
	weak var coordinator: CoordinatorProtocol?
	
	init(coordinator: CoordinatorProtocol) {
		self.coordinator = coordinator
		loadData()
	}

	private func loadData() {
		networkManager.fetchEpisodeData { episodes in
			switch episodes {
				case .success(let models):
					self.originalEpisides = models
					self.episodes = models
				case .failure(let error):
					print(error.localizedDescription)
			}
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
			updateFavor?(episode)
			removeEpisode(item: episode)
		}
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
