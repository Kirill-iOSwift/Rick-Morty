//
//  HeaderView.swift
//  Rick&Morty

import UIKit

// MARK: - HeaderView

final class HeaderView: UIView {
	
	// MARK: Properties
	let nameCharacter: String
	let imageUrl: URL
	let imageCharacterView: UIImageView
	
	private let buttonPhoto = UIButton(type: .system)
	private let nameCharacterLabel = UILabel()
	private let infoLabel = UILabel()
	
	var bottonPhotoTapped: (() -> Void)?
	
	// MARK: Initialization
	
	init(
		frame: CGRect,
		nameCharacter: String,
		imageUrl: URL,
		imageCharacterView: UIImageView
	) {
		self.nameCharacter = nameCharacter
		self.imageUrl = imageUrl
		self.imageCharacterView = imageCharacterView
		
		super.init(frame: frame)
		setupElements()
		//		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Methods
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		setupFrame()
	}
	
	private func setupElements() {
		
		[imageCharacterView, buttonPhoto, nameCharacterLabel, infoLabel].forEach {
			//			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}
		
		imageCharacterView.contentMode = .scaleAspectFill
		imageCharacterView.clipsToBounds = true
		imageCharacterView.layer.borderColor = UIColor.black.cgColor
		imageCharacterView.layer.borderWidth = 2
		imageCharacterView.setImage(from: imageUrl)
		
		buttonPhoto.setImage(UIImage(systemName: "camera"), for: .normal)
		buttonPhoto.tintColor = .black
		buttonPhoto.imageView?.contentMode = .scaleToFill
		buttonPhoto.addTarget(self, action: #selector(tapToButtonPhoto), for: .touchUpInside)
		
		nameCharacterLabel.font = .boldSystemFont(ofSize: 26)
		nameCharacterLabel.textAlignment = .center
		nameCharacterLabel.text = nameCharacter
		
		infoLabel.text = "Information"
		infoLabel.font = .systemFont(ofSize: 22)
		infoLabel.textAlignment = .left
		
	}
	
	
	
	// MARK: Setup Constraints
	
	private func setupFrame() {
		let padding: CGFloat = 10
		let imageCharacterViewSize: CGFloat = 200
		let buttonPhotoSize: CGFloat = 30
		
		// Устанавливаем фрейм для imageCharacterView
		imageCharacterView.frame = CGRect(
			x: 80, // Отступ от левого края
			y: padding, // Отступ от верхнего края
			width: imageCharacterViewSize,
			height: imageCharacterViewSize
		)
		
		// Устанавливаем фрейм для buttonPhoto
		buttonPhoto.frame = CGRect(
			x: imageCharacterView.frame.maxX + 16, // Отступ от правого края imageCharacterView
			y: (imageCharacterView.frame.height - buttonPhotoSize) / 2, // Вертикально центрируем относительно imageCharacterView
			width: buttonPhotoSize,
			height: buttonPhotoSize
		)
		
		// Устанавливаем фрейм для nameCharacterLabel
		nameCharacterLabel.frame = CGRect(
			x: padding, // Отступ от левого края
			y: imageCharacterView.frame.maxY + 30, // Отступ от нижнего края imageCharacterView
			width: self.bounds.width, // Ширина учитывает отступы
			height: 20 // Высота метки
		)
		
		// Устанавливаем фрейм для infoLabel
		infoLabel.frame = CGRect(
			x: padding, // Отступ от левого края
			y: nameCharacterLabel.frame.maxY + 20, // Отступ от нижнего края nameCharacterLabel
			width: self.bounds.width - 2 * padding, // Ширина учитывает отступы
			height: 20 // Высота метки
		)
		imageCharacterView.layer.masksToBounds = true
		imageCharacterView.layer.cornerRadius = imageCharacterView.frame.width / 2
	}
	
	private func setupConstraints() {
		
		NSLayoutConstraint.activate([
			imageCharacterView.topAnchor.constraint(equalTo: self.topAnchor),
			imageCharacterView.heightAnchor.constraint(equalToConstant: 200),
			imageCharacterView.widthAnchor.constraint(equalToConstant: 200),
			imageCharacterView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 80),
			
			buttonPhoto.leadingAnchor.constraint(equalTo: imageCharacterView.trailingAnchor, constant: 16),
			buttonPhoto.centerYAnchor.constraint(equalTo: imageCharacterView.centerYAnchor),
			buttonPhoto.heightAnchor.constraint(equalToConstant: 30),
			buttonPhoto.widthAnchor.constraint(equalToConstant: 30),
			
			nameCharacterLabel.topAnchor.constraint(equalTo: imageCharacterView.bottomAnchor, constant: 30),
			nameCharacterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
			
			infoLabel.topAnchor.constraint(equalTo: nameCharacterLabel.bottomAnchor, constant: 20),
			infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
			
			self.bottomAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10)
		])
	}
	
	@objc private func tapToButtonPhoto() {
		bottonPhotoTapped?()
	}
}

