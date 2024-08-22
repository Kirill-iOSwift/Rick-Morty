//
//  FavouriteManager.swift
//  Rick&Morty

import Foundation

final class FavoritesManager {
	
	static let singleton = FavoritesManager()
	private let favoritesKey = "favoritesKey"
	
	init() { }
	
	func saveFavorites(episodes: [Episode]) {
		DispatchQueue.global(qos: .background).async {
			if let encodedData = try? JSONEncoder().encode(episodes) {
				UserDefaults.standard.set(encodedData, forKey: self.favoritesKey)
			}
		}
	}
	
	func loadFavorites(completion: @escaping ([Episode]) -> Void) {
		DispatchQueue.global(qos: .background).async {
			guard let data = UserDefaults.standard.data(forKey: self.favoritesKey),
				  let decodedEpisodes = try? JSONDecoder().decode([Episode].self, from: data) else {
				DispatchQueue.main.async {
					completion([])
				}
				return
			}
			DispatchQueue.main.async {
				completion(decodedEpisodes)
			}
		}
	}
}

final class FavouriteFileMAnager {
	
	private let fileName = "favorites.json"
	private let decoder = JSONDecoder()
	private let encoder = JSONEncoder()
	
	// Путь к файлу в директории Documents
	private var fileURL: URL {
		guard let documentsDirectory = FileManager.default.urls(
			for: .documentDirectory,
			in: .userDomainMask
		).first else { return URL(fileURLWithPath: "") }
		
		return documentsDirectory.appendingPathComponent(fileName)
	}
	
	func save(episode: Episode) {
		do {
			let data = try encoder.encode(episode)
			try data.write(to: fileURL)
		}
		catch {
			print(error.localizedDescription)
		}
	}
	
	func load() -> [Episode] {
		do {
			let data = try Data(contentsOf: fileURL)
			return try decoder.decode([Episode].self, from: data)
		}
		catch {
			return []
		}
	}
	
	func add() {
		
	}
	
	func delete() {
		
	}
	
}

/*
 import Foundation

 final class FavoritesManager {

	 static let singleton = FavoritesManager()
	 private let fileName = "favorites.json"
	 
	 // Путь к файлу в директории Documents
	 private var fileURL: URL? {
		 let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
		 return documentsDirectory?.appendingPathComponent(fileName)
	 }

	 private init() { }

	 func saveFavorites(episodes: [Episode]) {
		 DispatchQueue.global(qos: .background).async { [weak self] in
			 guard let fileURL = self?.fileURL else { return }
			 do {
				 let encodedData = try JSONEncoder().encode(episodes)
				 try encodedData.write(to: fileURL, options: .atomicWrite)
			 } catch {
				 print("Error saving favorites: \(error.localizedDescription)")
			 }
		 }
	 }

	 func loadFavorites(completion: @escaping ([Episode]) -> Void) {
		 DispatchQueue.global(qos: .background).async { [weak self] in
			 guard let fileURL = self?.fileURL else {
				 DispatchQueue.main.async {
					 completion([])
				 }
				 return
			 }
			 do {
				 let data = try Data(contentsOf: fileURL)
				 let decodedEpisodes = try JSONDecoder().decode([Episode].self, from: data)
				 DispatchQueue.main.async {
					 completion(decodedEpisodes)
				 }
			 } catch {
				 print("Error loading favorites: \(error.localizedDescription)")
				 DispatchQueue.main.async {
					 completion([])
				 }
			 }
		 }
	 }

	 func removeEpisode(_ episode: Episode) {
		 DispatchQueue.global(qos: .background).async { [weak self] in
			 guard let fileURL = self?.fileURL else { return }
			 do {
				 // Загрузить текущие избранные эпизоды
				 var episodes = [Episode]()
				 if let data = try? Data(contentsOf: fileURL) {
					 episodes = try JSONDecoder().decode([Episode].self, from: data)
				 }
				 
				 // Удалить эпизод
				 episodes.removeAll { $0.id == episode.id }
				 
				 // Сохранить обновленный список
				 let encodedData = try JSONEncoder().encode(episodes)
				 try encodedData.write(to: fileURL, options: .atomicWrite)
			 } catch {
				 print("Error removing episode: \(error.localizedDescription)")
			 }
		 }
	 }
 }

 
 */
