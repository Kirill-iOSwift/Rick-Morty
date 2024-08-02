//
//  Error.swift

import Foundation

// MARK: - Error

//TODO: Применить через Result

enum NetworkError: Error {
	
	case invalidURL
	case networkError(Error)
	case noData
	case decodingError(Error)
	case invalidImageURL
	
	var localizedDescription: String {
		switch self {
			case .invalidURL:
				return "The provided character URL is invalid."
			case .networkError(let error):
				return error.localizedDescription
			case .noData:
				return "No data was received from the server."
			case .decodingError(let error):
				return "Failed to decode the character data: \(error.localizedDescription)"
			case .invalidImageURL:
				return "The image URL is invalid."
		}
	}
}
