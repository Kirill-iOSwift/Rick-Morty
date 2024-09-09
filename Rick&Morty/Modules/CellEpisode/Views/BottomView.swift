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
			addSubview($0)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		setupFrame()
	}
	
	// MARK: Setup Frame
	
	private func setupFrame() {
		image.frame = CGRect(
			x: 15,
			y: (frame.height - 30) / 2,
			width: 30,
			height: 30
		)
		
		label.frame = CGRect(
			x: image.frame.maxX + 20,
			y: 0,
			width: frame.width - image.frame.maxX - 20 - button.frame.width - 15,
			height: frame.height
		)
		
		button.frame = CGRect(
			x: frame.width - 50 - 15,
			y: 0,
			width: 50,
			height: frame.height
		)
		
	}
}

