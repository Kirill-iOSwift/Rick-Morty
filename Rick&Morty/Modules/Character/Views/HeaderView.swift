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
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Methods
	
	override func layoutSubviews() {
		super.layoutSubviews()
		imageCharacterView.layer.masksToBounds = true
		imageCharacterView.layer.cornerRadius = imageCharacterView.frame.width / 2
	}
	
	private func setupElements() {
		
		[imageCharacterView, buttonPhoto, nameCharacterLabel, infoLabel].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
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

