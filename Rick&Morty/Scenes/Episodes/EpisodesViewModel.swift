//
//  EpisodesViewModel.swift
//  Rick&Morty

import UIKit

// MARK: Protocol

protocol EpisodesViewModelProtocol: AnyObject {
	var episodes: [Episode] { get }
	func fetchData()
	
	func collectionDataSourse(collectionView: UICollectionView)
	
	func toggleFavorite(for episode: Episode)
	func removeEpisode(at indexPath: IndexPath)
	
	func cellViewModel(indexPath: IndexPath) -> EpisodeCellViewModelProtocol
	func getViewModelCharacter(indexPath: IndexPath) -> CharacterTableViewModelProtocol?
	func openCell(viewController: UIViewController)
}

// MARK: Class

final class EpisodesViewModel: EpisodesViewModelProtocol {
	
	// MARK: - enum DDS
	
	enum Section: Hashable {
		case main
	}
	
	// MARK: Properties
	
	private(set) var dataSource: UICollectionViewDiffableDataSource<Section, Episode>!
	
	private let episodesSave = RickAndMortyProvider()
	private let network = NetworkManager()
	
	var episodes: [Episode] {
		episodesSave.value
	}
	
	var coordinator: CoordinatorProtocol?

	// MARK: Methods

	func fetchData() {
		network.fetchEpisodeData { models in
			self.episodesSave.value = models
			DispatchQueue.main.async {
				self.updateSnapshot(episodes: self.episodes, animating: true)
			}
		}
	}
	
	func cellViewModel(indexPath: IndexPath) -> EpisodeCellViewModelProtocol {
		let episode = episodes[indexPath.row]
		return EpisodeCellViewModel(episode: episode)
	}
	
	func openCell(viewController: UIViewController) {
		coordinator?.openScreen(viewController: viewController)
		
	}
	
	func getViewModelCharacter(indexPath: IndexPath) -> CharacterTableViewModelProtocol? {
		guard let item = dataSource.itemIdentifier(for: indexPath) else { return nil }
		let cellViewController = CharacterTableViewModel(character: item)
		cellViewController.coordinator = coordinator
		return cellViewController
	}

	func toggleFavorite(for episode: Episode) {
		if let index = episodes.firstIndex(where: { $0.id == episode.id }) {
			var updatedEpisode = episodes[index]
			updatedEpisode.isFavourite.toggle()
			episodesSave.value[index] = updatedEpisode
			updateSnapshot(episodes: self.episodes, animating: true)
		}
	}

	func removeEpisode(at indexPath: IndexPath) {
		let itemToDelete = episodes[indexPath.item]
		episodesSave.value.remove(at: indexPath.item)
		delete(indexPath: itemToDelete)
	}
}

// MARK: Setup Collection View DDS

// TODO: - Убрать из ViewModel

extension EpisodesViewModel {
	
	internal func collectionDataSourse(collectionView: UICollectionView) {
		configureDataSourse(collectionView: collectionView)
		}
	
	private func configureDataSourse(collectionView: UICollectionView) {
		dataSource = UICollectionViewDiffableDataSource<Section, Episode>(collectionView: collectionView) {
			(collectionView, indexPath, item) -> UICollectionViewCell? in
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: EpisodeViewCell.reuseIdentifier,
				for: indexPath
			) as? EpisodeViewCell else { return UICollectionViewCell() }
			
			cell.configure(with: item)
			cell.onFavouriteToggle = { [weak self] in
				self?.toggleFavorite(for: item)
			}
			cell.onDelete = { [weak self] in
				self?.removeEpisode(at: indexPath)
			}
			
			return cell
		}
	}

	private func updateSnapshot(episodes: [Episode], animating: Bool) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Episode>()
			snapshot.appendSections([.main])
			snapshot.appendItems(episodes)
			self.dataSource.apply(snapshot, animatingDifferences: animating)
	}
	
	private func delete(indexPath: Episode) {
		var snapshot = dataSource.snapshot()
		snapshot.deleteItems([indexPath])
		dataSource.apply(snapshot, animatingDifferences: true)
	}
}
