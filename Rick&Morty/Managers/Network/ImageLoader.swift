//
//  ImageLoader.swift
//  Rick&Morty
//
//  Created by Кирилл on 27.07.2024.
//

import UIKit

extension UIImageView {
	
	private static var imageCache = NSCache<NSString, UIImage>()
	
	func setImage(from url: URL) {
		let urlString = url.absoluteString as NSString
		
		// Попробуйте получить изображение из кеша
		if let cachedImage = UIImageView.imageCache.object(forKey: urlString) {
			self.image = cachedImage
			return
		}
		
		// Загрузите изображение из сети
		getData(from: url) { data, response, error in
			guard let data = data, error == nil, let image = UIImage(data: data) else { return }
			
			// Кешируйте изображение
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

