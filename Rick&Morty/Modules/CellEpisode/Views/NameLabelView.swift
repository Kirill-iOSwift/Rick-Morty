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
//		setupConstraints()
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
		
		// Вычисляем максимальную ширину для лейбла
		let maxLabelWidth = bounds.width - 30 // Учитываем отступы
		
		// Прежде чем рассчитать высоту, нужно установить максимальную ширину лейбла
		let textSize = nameLabel.sizeThatFits(CGSize(width: maxLabelWidth, height: CGFloat.greatestFiniteMagnitude))
		
		// Устанавливаем фрейм для лейбла
		nameLabel.frame = CGRect(
			x: 15,
			y: (bounds.height - textSize.height) / 2,
			width: maxLabelWidth,
			height: textSize.height
		)
	}
}
