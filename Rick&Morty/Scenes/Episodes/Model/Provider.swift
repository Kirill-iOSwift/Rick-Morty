//
//  Provider.swift

import Foundation

final class RickAndMortyProvider {
	
	private let queue = DispatchQueue(label: "episode", attributes: .concurrent)
	private var array: [Episode] = []

	var value: [Episode] {
		get {
			queue.sync {
				return array
			}
		}
		set {
			queue.async(flags: .barrier) {
				self.array = newValue
			}
		}
	}
}
