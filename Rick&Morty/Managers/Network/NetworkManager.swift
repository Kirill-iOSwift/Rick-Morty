//
//  Network.swift
//  Rick&Morty

// MARK: - Network Manager

import Foundation

// MARK: - Enum Url

fileprivate enum UrlRickAndMoarty: String {
	case url = "https://rickandmortyapi.com/api/episode"
}

// MARK: - Protocol

protocol NetworkManagerProtocol: AnyObject {
	func fetchEpisodeData(completion: @escaping ([Episode]) -> Void)
}

// MARK: - Class

final class NetworkManager: NetworkManagerProtocol {
	
	func fetchEpisodeData(completion: @escaping ([Episode]) -> Void) {
		guard let url = URL(string: UrlRickAndMoarty.url.rawValue) else { return }
		let urlRequest = URLRequest(url: url)
		let session = URLSession(configuration: .default)
		let decoder = JSONDecoder()
		let lock = NSLock()
				
		var modelCharacters = [Episode]()
		
		let task = session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
			guard error == nil else {
				return }
			guard let data = data else { return }
			do {
				let response = try decoder.decode(RickAndMorty.self, from: data)
				for episode in response.results {
					guard let character = episode.characters.randomElement() else { return }
					lock.lock()
					self?.fetchImageData(url: character) { [weak self] character in
						if let model = self?.createModel(episode: episode, character: character) {
							modelCharacters.append(model)
						}
						lock.unlock()
						
					}
				}
				completion(modelCharacters)
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
