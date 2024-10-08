//
//  ModelEpisode.swift
//  Rick&Morty

import Foundation

struct Episode: Hashable, Codable {
	
	var id = UUID()
	let nameEpisode: String
	let imagePers: URL
	let numberEpisode: String
	
	let namePers: String
	let statusPers: String
	let speciePers: String
	let genderPers: String
	let originPers: String
	
	var isFavourite = false
}


