//
//  ImageLoader.swift
//  Rick&Morty


import UIKit

// MARK: - Extension UIImageView For Dowload Pictures

extension UIImageView {
	
	// MARK: Cache
	
	private static var imageCache = NSCache<NSString, UIImage>()
	
	// MARK: Methods
	
	func setImage(from url: URL) {
		
		let urlString = url.absoluteString as NSString
		if let cachedImage = UIImageView.imageCache.object(forKey: urlString) {
			self.image = cachedImage
			return
		}
		
		getData(from: url) { data, response, error in
			
			guard let data = data, error == nil, let image = UIImage(data: data) else { return }
			UIImageView.imageCache.setObject(image, forKey: urlString)
			DispatchQueue.main.async {
				self.image = image
			}
		}
	}
	
	private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
		URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
	}
}
