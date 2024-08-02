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
	func fetchEpisodeData(completion: @escaping ([EpisodeTest]) -> Void)
}

// MARK: - Class

final class NetworkManager: NetworkManagerProtocol {
	
	func fetchEpisodeData(completion: @escaping ([EpisodeTest]) -> Void) {
		guard let url = URL(string: UrlRickAndMoarty.url.rawValue) else { return }
		let urlRequest = URLRequest(url: url)
		let session = URLSession(configuration: .default)
		let decoder = JSONDecoder()
		let lock = NSLock()
				
		var modelCharacters = [EpisodeTest]()
		
		let task = session.dataTask(with: urlRequest) { (data, response, error) in
			guard error == nil else {
				return }
			guard let data = data else { return }
			do {
				let response = try decoder.decode(RickAndMorty.self, from: data)
				for episode in response.results {
					guard let character = episode.characters.randomElement() else { return }
					lock.lock()
					self.fetchImageData(url: character) { character in
						let model = self.createModel(episode: episode, character: character)
						modelCharacters.append(model)
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
	
	func fetchImageData(url: URL, completion: @escaping (RickAndMorty.Character) -> Void) {
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
	
	func createModel(episode: RickAndMorty.Episode, character: RickAndMorty.Character) -> EpisodeTest {
		let model = EpisodeTest(
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
