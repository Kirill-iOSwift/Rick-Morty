//
//  BottomView.swift
//  Rick&Morty

import UIKit

final class BottomView: UIView {
	
	// MARK: Properties
	
	var label: UILabel
	var button: UIButton
	var image: UIImageView
	
	// MARK: Initialization
	
	init(frame: CGRect, label: UILabel, button: UIButton, image: UIImageView) {
		self.label = label
		self.button = button
		self.image = image
		super.init(frame: frame)
		setupSubview()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Setup Subvuews
	
	private func setupSubview() {
		self.backgroundColor = .systemGray6

		image.tintColor = .black
		label.font = .systemFont(ofSize: 22)

		[image, label, button].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}
	}
	
	// MARK: Setup Constraints
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			image.centerYAnchor.constraint(equalTo: centerYAnchor),
			image.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 15),
			image.widthAnchor.constraint(equalToConstant: 30),
			image.heightAnchor.constraint(equalToConstant: 30),
			
			label.centerYAnchor.constraint(equalTo: centerYAnchor),
			label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
			
			button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
			button.topAnchor.constraint(equalTo: topAnchor),
			button.bottomAnchor.constraint(equalTo: bottomAnchor),
			button.widthAnchor.constraint(equalToConstant: 50)
		])
	}
}

