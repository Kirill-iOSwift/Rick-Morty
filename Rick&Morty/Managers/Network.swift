//
//  TeatNetwork.swift
//  Rick&Morty
//
//  Created by Кирилл on 26.07.2024.
//

import Foundation



class NetworkManager {
	static let shared = NetworkManager()
	
	private init() {}
	
	func fetchEpisodes(completion: @escaping (Result<[Item], Error>) -> Void) {
		
		var items = [Item]()
		
		let url = URL(string: "https://rickandmortyapi.com/api/episode")!
		
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
				let episodes = try JSONDecoder().decode(RickAndMortyResponse.self, from: data)
				
				let group = DispatchGroup()
				
				for index in 0..<episodes.results.count {
					group.enter()
					self.fetchCharacterImageURL(
						characterURL: episodes.results[index].characters.randomElement() ?? "") { result in
						switch result {
						case .success(let imageURL):
								let model = Item(
									episode: episodes.results[index].episode,
									imageName: imageURL,
									name: episodes.results[index].name
								)
								items.append(model)
						case .failure(let error):
							print("Error fetching image URL: \(error)")
						}
							
						group.leave()
					}
					
				}
				
				group.notify(queue: .main) {
					completion(.success(items))
				}
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}
	
	private func fetchCharacterImageURL(characterURL: String, completion: @escaping (Result<URL, Error>) -> Void) {
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
				let character = try JSONDecoder().decode(Character.self, from: data)
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

