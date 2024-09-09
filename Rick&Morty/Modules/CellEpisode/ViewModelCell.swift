//
//  ViewModelCollectionCell.swift
//  Rick&Morty

import Foundation

protocol ViewModelCollectionCellProtocol {
	var titleEpisode: String { get }
	var numberEpisode: String { get }
	var isFavourite: Bool { get }
	var imageEpisode: URL { get }
}

struct ViewModelCollectionCell: ViewModelCollectionCellProtocol {
	
	private let episode: Episode
	
	var titleEpisode: String {
		episode.nameEpisode
	}
	
	var numberEpisode: String {
		episode.numberEpisode
	}
	
	var isFavourite: Bool {
		episode.isFavourite
	}
	
	var imageEpisode: URL {
		episode.imagePers
	}
	
	init(episode: Episode) {
		self.episode = episode
	}
}
