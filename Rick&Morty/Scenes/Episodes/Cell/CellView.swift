//
//  CellView.swift
//  Rick&Morty
//
//  Created by Кирилл on 24.07.2024.
//

import UIKit

class BottomView: UIView {
	
	var label: UILabel
	
	private let image = UIImageView()
	private let button = UIButton(type: .system)
	
	init(frame: CGRect, label: UILabel) {
		self.label = label
		super.init(frame: frame)
		setupView()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupView() {
		self.backgroundColor = .systemGray4
		
		image.image = UIImage(systemName: "play.tv")
		let imageButtun = UIImage(systemName: "suit.heart")
		button.setImage(imageButtun, for: .normal)
		
		[image, label, button].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			// Constraints для imageView
			image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			image.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 15),
			image.widthAnchor.constraint(equalToConstant: 30),
			image.heightAnchor.constraint(equalToConstant: 30),
			
			// Constraints для label
			label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
			
			// Constraints для button
			button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
		])
	}
}

class TwoLabels: UIView {
	
	let nameLabel: UILabel
	
	init(frame: CGRect, nameLabel: UILabel) {
		self.nameLabel = nameLabel
		super.init(frame: frame)
		setLabels()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setLabels() {
		self.backgroundColor = .white
		
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(nameLabel)
		
		NSLayoutConstraint.activate([
			nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
			nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		])
	}
}
