//
//  AssemblyMainTabbar.swift
//  Rick&Morty

import UIKit

struct AssemblyMainTabbar {
	
	func createMainViewModel(coordinator: CoordinatorProtocol) -> ViewModelEpisodeProtocol {
		let mainViewModel = ViewModelEpisode(coordinator: coordinator)
		return mainViewModel
	}

	func createTabbar(episodes: UIViewController, favotites: UIViewController) -> UIViewController {
		let view = TabbarViewController(episodes: episodes, favourites: favotites)
		return view
	}	
	
}

struct AssemblyEpisodes {
	func createEpisodes(mainViewModel: ViewModelEpisodeProtocol) -> UIViewController {
		let view = EpisodesViewController(viewModel: mainViewModel)
		return view
	}
}

struct AssemblyFavouritesEpisodes {
	func createFavouritesEpisodes(mainViewModel: ViewModelEpisodeProtocol) -> UIViewController {
		let viewModel = ViewModelFavouritesController(mainViewModel: mainViewModel)
		let view = FavouriteEpisodeViewController(viewModel: viewModel)
		return view
	}
}

struct AssemblyCharacter {
	func create(episode: Episode, coordinator: CoordinatorProtocol) -> UIViewController {
		let characterVC = CharacterTableViewController()
		characterVC.viewModel = CharacterTableViewModel(character: episode)
		characterVC.viewModel?.coordinator = coordinator
		return characterVC
	}
}

