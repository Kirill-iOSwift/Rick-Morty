//
//  UIButton.swift
//  Rick&Morty
//
//  Created by Кирилл on 30.07.2024.
//

import UIKit

// MARK: - Extesion Custom Button

extension UIButton {
	func customizeSortdButton() {
		self.setTitle("Advanced filters", for: .normal)
		self.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
		self.titleLabel?.font = .systemFont(ofSize: 20)
		self.tintColor = .blue
		self.layer.cornerRadius = 5
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowRadius = 4
		self.layer.shadowOpacity = 2
		self.layer.shadowOffset = CGSize(width: 0, height: 4)
	}
}
