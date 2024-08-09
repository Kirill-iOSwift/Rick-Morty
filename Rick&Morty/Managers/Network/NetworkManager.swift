//
//  NetworkManager.swift
//  Rick&Morty

import Foundation

// MARK: - Enum Url

fileprivate enum UrlRickAndMoarty: String {
	case url = "https://rickandmortyapi.com/api/episode"
}

// MARK: - Struct

struct NetworkManager {
	
	func fetchEpisodeData(completion: @escaping ([Episode]) -> Void) {
		
		guard let url = URL(string: UrlRickAndMoarty.url.rawValue) else { return }
		
		let urlRequest = URLRequest(url: url)
		let session = URLSession(configuration: .default)
		let decoder = JSONDecoder()
		let group = DispatchGroup()
		
		var modelCharacters = [Episode]()

		let task = session.dataTask(with: urlRequest) { (data, response, error) in

			guard error == nil else {
				return }
			guard let data = data else { return }
			
			do {
				let response = try decoder.decode(RickAndMorty.self, from: data)
				
				for episode in response.results {
					group.enter()
					guard let character = episode.characters.randomElement() else { return }
					self.fetchImageData(url: character) { character in
						let model = self.createModel(episode: episode, character: character)
							modelCharacters.append(model)
						group.leave()
					}
				}
				group.notify(queue: .main) {
					completion(modelCharacters)
				}
			}
			catch {
				print(error.localizedDescription)
			}
		}
		task.resume()
	}
	
	private func fetchImageData(url: URL, completion: @escaping (RickAndMorty.Character) -> Void) {

		let urlRequest = URLRequest(url: url)
		let session = URLSession(configuration: .default)
		let decoder = JSONDecoder()
		
		let task = session.dataTask(with: urlRequest) { (data, response, error) in
			guard error == nil else {
				return }
			guard let data = data else { return }
			do {
				let response = try decoder.decode(RickAndMorty.Character.self, from: data)
				completion(response)
			}
			catch {
				print(error.localizedDescription)
			}
		}
		task.resume()
	}
	
	private func createModel(episode: RickAndMorty.Episode, character: RickAndMorty.Character) -> Episode {
		let model = Episode(

			nameEpisode: episode.name,
			imagePers: character.image,
			numberEpisode: episode.episode,
			namePers: character.name,
			statusPers: character.status,
			speciePers: character.species,
			genderPers: character.gender,
			originPers: character.origin.name
		)
		return model
	}
}
