//
//  Error.swift

import Foundation

// MARK: - Error

enum NetworkError: Error {
	
	case invalidURL
	case networkError(Error)
	case noData
	case decodingError(Error)
	case invalidImageURL
	
	var localizedDescription: String {
		switch self {
			case .invalidURL:
				return "URL is invalid."
			case .networkError(let error):
				return error.localizedDescription
			case .noData:
				return "No data"
			case .decodingError(let error):
				return "Failed to decode: \(error.localizedDescription)"
			case .invalidImageURL:
				return "The image URL is invalid."
		}
	}
}
