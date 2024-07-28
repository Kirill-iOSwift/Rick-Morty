//
//  Model.swift
//  Rick&Morty

import Foundation

// MARK: - Welcome
struct RickAndMortyResponse: Decodable {
	let info: Info
	var results: [Resultat]
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
	let air_date: String
	let episode: String
	let characters: [String]
	let url: String
	let created: String
	var imageURL: URL?
}

struct Character: Decodable {
	let id: Int
	let name, status, species, type: String
	let gender: String
//	let origin, location: [String]
	let image: String
	let episode: [String]
	let url: String
	let created: String
}
