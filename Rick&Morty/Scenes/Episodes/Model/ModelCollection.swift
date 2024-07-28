//
//  ModelCollection.swift
//  Rick&Morty
//
//  Created by Кирилл on 24.07.2024.
//

import Foundation

struct Item: Hashable {
	let id = UUID()
	let episode: String
	let imageName: String
	let name: String
}

class FavoritesManager {
	static let shared = FavoritesManager()
	private(set) var items: [Item] = []

	func add(item: Item) {
		items.append(item)
		NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
	}

	func remove(item: Item) {
		items.removeAll { $0.id == item.id }
		NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
	}
}

extension Notification.Name {
	static let favoritesUpdated = Notification.Name("favoritesUpdated")
}
