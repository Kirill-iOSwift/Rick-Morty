//
//  CharacterTableViewModel.swift
//  Rick&Morty

import UIKit

// MARK: enum DDS

enum Sections {
		case main
	}
	
enum Сharacteristics: Hashable {
		case gender(String)
		case status(String)
		case specie(String)
		case origin(String)
}

// MARK: Protocol

protocol CharacterTableViewModelProtocol: AnyObject {
	var character: Episode? { get }
	var coordinator: CoordinatorProtocol? { get set }
	
	func goBack()
	func getSectionInfo() -> [Сharacteristics]
}

// MARK: Class

final class CharacterTableViewModel: CharacterTableViewModelProtocol {
	
	// MARK: Properties
	
	private(set) var character: Episode?
	var coordinator: CoordinatorProtocol?
	
	// MARK: Init
	
	init(character: Episode) {
		self.character = character
	}
	
	// MARK: - Methods
	
	func goBack() {
		coordinator?.navigateBack()
	}
	
	func getSectionInfo() -> [Сharacteristics] {
		guard let character = character else { return [] }
		var characteristics = [Сharacteristics]()
		characteristics = [.gender(character.genderPers),
						   .origin(character.originPers),
						   .specie(character.speciePers),
						   .status(character.statusPers)]
		return characteristics
	}
}





