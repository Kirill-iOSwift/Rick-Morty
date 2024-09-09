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
	
	func fetchEpisodeData(completion: @escaping (Result<[Episode], NetworkError>) -> Void) {

		guard let url = URL(string: UrlRickAndMoarty.url.rawValue) else {
			completion(.failure(.invalidURL))
			return
		}
		
		let urlRequest = URLRequest(url: url)
		let session = URLSession(configuration: .default)
		let decoder = JSONDecoder()
		let group = DispatchGroup()
		var modelCharacters = [Episode]()
		let locker = NSLock()
		
		let task = session.dataTask(with: urlRequest) { (data, response, error) in
			if let error = error {
				completion(.failure(.networkError(error)))
				return
			}
			
			guard let data = data else {
				completion(.failure(.noData))
				return
			}
			
			do {
				let response = try decoder.decode(RickAndMorty.self, from: data)
				
				for episode in response.results {
					group.enter()
					guard let characterURL = episode.characters.randomElement() else {
						group.leave()
						continue
					}
					
					self.fetchImageData(url: characterURL) { result in
						switch result {
						case .success(let character):
								let model = self.createModel(episode: episode, character: character)
								locker.lock()
								modelCharacters.append(model)
								locker.unlock()
						case .failure(let error):
								print(error.localizedDescription)
						}
						group.leave()
					}
				}
				
				group.notify(queue: .global()) {
					completion(.success(modelCharacters))
				}
			} catch {
				completion(.failure(.decodingError(error)))
			}
		}
		task.resume()
	}
	
	private func fetchImageData(url: URL, completion: @escaping (Result<RickAndMorty.Character, NetworkError>) -> Void) {

		let urlRequest = URLRequest(url: url)
		let session = URLSession(configuration: .default)
		let decoder = JSONDecoder()
		
		let task = session.dataTask(with: urlRequest) { (data, response, error) in
			guard error == nil else {
				completion(.failure(.invalidImageURL))
				return
			}
			guard let data = data else { 
				completion(.failure(.noData))
				return }
			
			do {
				let response = try decoder.decode(RickAndMorty.Character.self, from: data)
				completion(.success(response))
			}
			catch {
				completion(.failure(.networkError(error)))
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
