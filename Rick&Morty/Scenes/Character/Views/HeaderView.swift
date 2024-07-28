//
//  HeaderView.swift
//  Rick&Morty
//
//  Created by Кирилл on 02.08.2024.
//

import UIKit
import SwiftUI

final class HeaderView: UIView {
	
	let imageCharacterView: UIImageView
	var buttonPhoto: UIButton
	let nameCharacterLabel: UILabel
	let infoLabel: UILabel
	
	init(
		frame: CGRect,
		imageCharacterView: UIImageView,
		buttonPhoto: UIButton,
		nameCharacterLabel: UILabel,
		infoLabel: UILabel
	) {
		self.imageCharacterView = imageCharacterView
		self.buttonPhoto = buttonPhoto
		self.nameCharacterLabel = nameCharacterLabel
		self.infoLabel = infoLabel
		super.init(frame: frame)
		setupElements()
		setupConstraints()
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupElements() {
		
		imageCharacterView.contentMode = .scaleAspectFit
		imageCharacterView.clipsToBounds = true
		imageCharacterView.layer.borderColor = UIColor.white.cgColor
		imageCharacterView.layer.borderWidth = 1
		imageCharacterView.image = UIImage(named: "logotype")
		
		buttonPhoto = UIButton(type: .system)
		buttonPhoto.setImage(UIImage(systemName: "camera"), for: .normal)
		buttonPhoto.tintColor = .black
		buttonPhoto.imageView?.contentMode = .scaleToFill
		
		nameCharacterLabel.font = .boldSystemFont(ofSize: 26)
		nameCharacterLabel.textAlignment = .center
		nameCharacterLabel.text = "Name Character"
		
		infoLabel.text = "Information"
		infoLabel.font = .systemFont(ofSize: 22)
		infoLabel.textAlignment = .left
		
		[imageCharacterView, buttonPhoto, nameCharacterLabel, infoLabel].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}
	}
	
	func setupConstraints() {
		
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
	
	override func layoutSubviews() {
		super.layoutSubviews()
		imageCharacterView.layer.masksToBounds = true
		imageCharacterView.layer.cornerRadius = imageCharacterView.frame.width / 2
		
	}
	
	deinit {
		print("deinit Header")
	}
}

struct HeaderViewPreviews: PreviewProvider {
	struct ViewControllerContainer: UIViewControllerRepresentable {
		func makeUIViewController(context: Context) -> some UIViewController {
			UINavigationController(rootViewController: CharacterTableViewController())
		}
		func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
	}
	static var previews: some View {
		ViewControllerContainer().edgesIgnoringSafeArea(.all)
	}
}

