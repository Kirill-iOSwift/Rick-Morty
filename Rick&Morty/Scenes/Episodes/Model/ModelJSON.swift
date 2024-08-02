//
//  Model.swift
//  Rick&Morty

import Foundation

// MARK: - Models JSON

// MARK: RickAndMortyResponse

struct RickAndMorty: Decodable {
	let info: Info
	var results: [Episode]
	
	// MARK: Info
	
	struct Info: Decodable {
		let count: Int
		let pages: Int
		let next: String
		let prev: String?
	}
	
	// MARK: Result
	
	struct Episode: Decodable {
		let id: Int
		let name: String
		let air_date: String
		let episode: String
		let characters: [URL]
		let url: String
		let created: String
	}
	
	// MARK: Character
	
	struct Character: Decodable {
		let id: Int
		let name, status, species, type: String
		let gender: String
		let origin: Origin
		let image: URL
		let episode: [String]
		let url: String
		let created: String
	}
	
	struct Origin: Decodable {
		let name: String
	}
}
