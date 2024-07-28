//
//  Model.swift
//  Rick&Morty
//
//  Created by Кирилл on 14.07.2024.
//

import Foundation

// MARK: - Welcome1
struct RickAndMortyResponse: Decodable {
	let info: Info
	let results: [Resultat]
}

// MARK: - Info
struct Info: Decodable {
	let count: Int
	let pages: Int
	let next: String
	let prev: String?
}

// MARK: - Result
struct Resultat: Decodable {
	let id: Int
	let name: String
	let airDate: String
	let episode: String
	let characters: [String]
	let url: String
	let created: String
}
