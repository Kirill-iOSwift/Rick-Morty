//
//  EpisodeCellViewModel.swift
//  Rick&Morty

import Foundation

// MARK: - Protocol

protocol EpisodeCellViewModelProtocol: AnyObject {
	var titleEpiside: String { get }
	var numberEpisode: String { get }
	var imageEpiside: URL { get }
}

// MARK: - Class

final class EpisodeCellViewModel: EpisodeCellViewModelProtocol {
	
	private let episode: Episode
	
	var titleEpiside: String {
		return episode.nameEpisode
	}
	
	var numberEpisode: String {
		return episode.numberEpisode
	}
	
	var imageEpiside: URL {
		return episode.imagePers
	}
	
	init(episode: Episode) {
		print("init EpisodeCellViewModel")
		self.episode = episode
	}
	
}

