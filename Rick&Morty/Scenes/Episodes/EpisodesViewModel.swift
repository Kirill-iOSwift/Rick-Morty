//
//  EpisodesViewModel.swift
//  Rick&Morty

import Foundation
import Combine

protocol EpisodesViewModelProtocol: AnyObject {
	func downLoad(complition: @escaping ([Item]) -> Void)
	var items: [Item] { get }
}

class EpisodesViewModel: EpisodesViewModelProtocol {
	
	var items = [Item]()
	
	weak var network: NetworkManagerProtocol?
	
	init(network: NetworkManagerProtocol) {
		self.network = network
	}
	
	
	func downLoad(complition: @escaping ([Item]) -> Void) {
		network?.fetchEpisodes { [weak self] result in
			switch result {
					
				case .success(let items):
					self?.items = items
					complition(items)
				case .failure(let error):
					print("Error fetching episodes: \(error)")
			}
		}
	}

}
