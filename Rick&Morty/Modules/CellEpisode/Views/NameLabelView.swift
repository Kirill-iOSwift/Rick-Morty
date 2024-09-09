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
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Setup Label
	
	private func setLabel() {
		self.backgroundColor = .white
		addSubview(nameLabel)
		nameLabel.font = .boldSystemFont(ofSize: 22)
	}
	
	// MARK: Setup Frame
	
	override func layoutSubviews() {
		super.layoutSubviews()
		setupFrame()
	}
	
	private func setupFrame() {
		nameLabel.numberOfLines = 0
		let maxLabelWidth = bounds.width - 30
		let textSize = nameLabel.sizeThatFits(
			CGSize(
				width: maxLabelWidth,
				height: CGFloat.greatestFiniteMagnitude
			)
		)
		
		nameLabel.frame = CGRect(
			x: 15,
			y: (bounds.height - textSize.height) / 2,
			width: maxLabelWidth,
			height: textSize.height
		)
	}
}
