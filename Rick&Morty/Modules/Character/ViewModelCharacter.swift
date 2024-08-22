//
//  ViewModelCharacterController.swift
//  Rick&Morty

// MARK: Protocol

protocol CharacterTableViewModelProtocol: AnyObject {
	var character: Episode? { get }
	var coordinator: CoordinatorProtocol? { get set }
	
	func getSectionInfo() -> [Сharacteristics]
	func getConfiguration(for item: Сharacteristics) -> (text: String, secondaryText: String)?
}

// MARK: Class

final class CharacterTableViewModel: CharacterTableViewModelProtocol {
	
	// MARK: Properties
	
	private(set) var character: Episode?
	weak var coordinator: CoordinatorProtocol?
	
	// MARK: Init
	
	init(character: Episode) {
		self.character = character
	}
	
	// MARK: - Methods
	
	func getSectionInfo() -> [Сharacteristics] {
		guard let character = character else { return [] }
		var characteristics = [Сharacteristics]()
		characteristics = [.gender(character.genderPers),
						   .origin(character.originPers),
						   .specie(character.speciePers),
						   .status(character.statusPers)]
		return characteristics
	}
	
	func getConfiguration(for item: Сharacteristics) -> (text: String, secondaryText: String)? {
			guard let character = character else { return nil }
			
			switch item {
				case .gender:
					return ("Gender", character.genderPers)
				case .origin:
					return ("Origin", character.originPers)
				case .specie:
					return ("Specie", character.speciePers)
				case .status:
					return ("Status", character.statusPers)
			}
		}
	
	deinit {
		print("deinit VM")
	}
}

extension CharacterTableViewModelProtocol {
	func returnToPreviousScreen() {
		coordinator?.navigateBack()
	}
}
