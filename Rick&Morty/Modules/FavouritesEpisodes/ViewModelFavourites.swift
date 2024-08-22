//
//  ViewModelFavouritesController.swift
//  Rick&Morty

import Foundation

protocol ViewModelFavouritesControllerProtocol: AnyObject {
	var favouritesEpisodes: [Episode] { get }
	func isFavouriteToggle(for episode: Episode)
	func createCharcterVC(episode: Episode)
	func createViewModelCell(episode: Episode) -> ViewModelCollectionCellProtocol
	
	var updateUI: (() -> Void)? { get set }
}

final class ViewModelFavouritesController: ViewModelFavouritesControllerProtocol {
	var updateUI: (() -> Void)?
	
	
	private var mainViewModel: VMProtocol
	
	var favouritesEpisodes: [Episode] = [] {

		didSet {
			print("favor",favouritesEpisodes.count)
			updateUI?()
		}
	}
	
	init(mainViewModel: VMProtocol) {
		self.mainViewModel = mainViewModel
		bindToMainViewModel()
//		updateFavouritesEpisodes()
		
	}
	
	private func bindToMainViewModel() {
		mainViewModel.updateFavor = { models in
			self.favouritesEpisodes = models.filter { $0.isFavourite }
		}
	}
	
	private func updateFavouritesEpisodes() {
		favouritesEpisodes = mainViewModel.episodes.filter { $0.isFavourite }
	}
	
	func isFavouriteToggle(for episode: Episode) {
		if let index = favouritesEpisodes.firstIndex(where: { $0.id == episode.id }) {
			mainViewModel.episodes[index].isFavourite.toggle()
			updateFavouritesEpisodes()
		}

	}
	
	func createCharcterVC(episode: Episode) {
		mainViewModel.coordinator?.createCharcterVC(episode: episode)
	}
	
	func createViewModelCell(episode: Episode) -> ViewModelCollectionCellProtocol {
		return ViewModelCollectionCell(episode: episode)
	}
}
