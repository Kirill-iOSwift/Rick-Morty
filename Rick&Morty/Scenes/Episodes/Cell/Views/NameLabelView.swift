//
//  NameLabelView.swift
//  Rick&Morty

import UIKit

final class NameLabel: UIView {
	
	// MARK: Properties
	
	let nameLabel: UILabel
	
	// MARK: Initialization
	
	init(frame: CGRect, nameLabel: UILabel) {
		self.nameLabel = nameLabel
		super.init(frame: frame)
		setLabel()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Setup Label
	
	private func setLabel() {
		self.backgroundColor = .white
		nameLabel.font = .boldSystemFont(ofSize: 22)
		nameLabel.numberOfLines = 0
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(nameLabel)
	}
	
	// MARK: Setup Constraints
	
	private func setupConstraints() {
		
		NSLayoutConstraint.activate([
			nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
			nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
			nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		])
	}
}
