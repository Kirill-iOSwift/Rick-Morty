//
//  Network.swift
//  Rick&Morty

import Foundation

protocol NetworkManagerProtocol: AnyObject {
	func fetchEpisodes(completion: @escaping (Result<[Item], Error>) -> Void)
	//func fetchCharacterImageURL(characterURL: String, completion: @escaping (Result<URL, Error>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
	//static let shared = NetworkManager()
	
	//private init() {}
	
	func fetchEpisodes(completion: @escaping (Result<[Item], Error>) -> Void) {
		let url = URL(string: "https://rickandmortyapi.com/api/episode")!
		
		URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				DispatchQueue.main.async {
					completion(.failure(error))
				}
				return
			}
			
			guard let data = data else {
				let error = NSError(domain: "dataNilError", code: -100001, userInfo: nil)
				DispatchQueue.main.async {
					completion(.failure(error))
				}
				return
			}
			
			do {
				let episodes = try JSONDecoder().decode(RickAndMortyResponse.self, from: data)
				
				let group = DispatchGroup()
				var items = [Item]()
				var errors = [Error]()
				
				for episode in episodes.results {
					guard let characterURL = episode.characters.randomElement() else {
						continue
					}
					
					group.enter()
					self.fetchCharacterImageURL(characterURL: characterURL) { result in
						switch result {
						case .success(let imageURL):
							let model = Item(
								episode: episode.episode,
								imageName: imageURL,
								name: episode.name
							)
							items.append(model)
						case .failure(let error):
							errors.append(error)
						}
						
						group.leave()
					}
				}
				
				group.notify(queue: .main) {
					if errors.isEmpty {
						completion(.success(items))
					} else {
						let combinedError = NSError(domain: "fetchingError", code: -100004, userInfo: [NSLocalizedDescriptionKey: "One or more errors occurred while fetching character images."])
						completion(.failure(combinedError))
					}
				}
			} catch {
				DispatchQueue.main.async {
					completion(.failure(error))
				}
			}
		}.resume()
	}
	
	func fetchCharacterImageURL(characterURL: String, completion: @escaping (Result<URL, Error>) -> Void) {
		guard let url = URL(string: characterURL) else {
			let error = NSError(domain: "invalidURLError", code: -100002, userInfo: nil)
			completion(.failure(error))
			return
		}
		
		URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			guard let data = data else {
				let error = NSError(domain: "dataNilError", code: -100001, userInfo: nil)
				completion(.failure(error))
				return
			}
			
			do {
				let character = try JSONDecoder().decode(RickAndMortyResponse.Character.self, from: data)
				if let imageURL = URL(string: character.image) {
					completion(.success(imageURL))
				} else {
					let error = NSError(domain: "invalidImageURLError", code: -100003, userInfo: nil)
					completion(.failure(error))
				}
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}
}
