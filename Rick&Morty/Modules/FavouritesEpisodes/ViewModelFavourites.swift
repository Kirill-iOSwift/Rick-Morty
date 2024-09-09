//
//  ViewModelFavouritesController.swift
//  Rick&Morty

import Foundation

protocol ViewModelFavouritesControllerProtocol: AnyObject {
	var favouritesEpisodes: [Episode] { get }
	var updateBaige: ((String) -> Void)? { get set }
	var updateUI: (() -> Void)? { get set }
	
	func isFavouriteToggle(for episode: Episode)
	func createCharcterVC(episode: Episode)
	func createViewModelCell(episode: Episode) -> ViewModelCollectionCellProtocol
	
	func saveEpisodes()
	func removeEpisode(item: Episode)
}

final class ViewModelFavouritesController: ViewModelFavouritesControllerProtocol {
	
	var updateUI: (() -> Void)?
	var updateBaige: ((String) -> Void)?
	
	private var mainViewModel: ViewModelEpisodeProtocol
	
	var favouritesEpisodes: [Episode] = [] {
		didSet {
			updateBaige?("\(favouritesEpisodes.count)")
			updateUI?()
			saveEpisodes()
		}
	}
	
	init(mainViewModel: ViewModelEpisodeProtocol) {
		self.mainViewModel = mainViewModel
		bindToMainViewModel()
		favouritesEpisodes = loadEpisodes()
	}
	
	private func bindToMainViewModel() {
		mainViewModel.updateFavor = { models in
			self.favouritesEpisodes.append(models)
		}
	}
	
	func isFavouriteToggle(for episode: Episode) {
		mainViewModel.isFavouriteToggle(for: episode)
	}
	
	func createCharcterVC(episode: Episode) {
		mainViewModel.coordinator?.createCharcterVC(episode: episode)
	}
	
	func createViewModelCell(episode: Episode) -> ViewModelCollectionCellProtocol {
		return mainViewModel.createViewModelCell(episode: episode)
	}
	
	// MARK: - User Defaults
	
	func saveEpisodes() {
		let userDefaults = UserDefaults.standard
		if let encodedData = try? JSONEncoder().encode(favouritesEpisodes) {
			userDefaults.set(encodedData, forKey: "savedEpisodes")
		}
	}
	
	func loadEpisodes() -> [Episode] {
		let userDefaults = UserDefaults.standard
		if let savedData = userDefaults.data(forKey: "savedEpisodes") {
			if let decodedEpisodes = try? JSONDecoder().decode([Episode].self, from: savedData) {
				return decodedEpisodes
			}
		}
		return []
	}
	
	func removeEpisode(item: Episode) {
		if let index = favouritesEpisodes.firstIndex(where: { $0.id == item.id }) {
			favouritesEpisodes.remove(at: index)
		}
	}
}
