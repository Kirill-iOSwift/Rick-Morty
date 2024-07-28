//
//  EpisodeViewCell.swift
//  Rick&Morty
//
//  Created by Кирилл on 24.07.2024.
//

import UIKit
import SwiftUI

class ItemCell: UICollectionViewCell {
	static let reuseIdentifier = "ItemCell"

	private let imageView = UIImageView()
	private let nameLabel = UILabel()
	private let episodeLabel = UILabel()
	
	var addToFavoritesAction: (() -> Void)?

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupCell()
		setupViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupCell() {
		   contentView.backgroundColor = .white
		   contentView.layer.cornerRadius = 12
		   //contentView.layer.masksToBounds = false
		   contentView.layer.shadowColor = UIColor.black.cgColor
		   contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
		   contentView.layer.shadowRadius = 4
		contentView.layer.shadowOpacity = 0.5
		   
	   }

	private func setupViews() {
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.backgroundColor = .yellow
		
		episodeLabel.text = "Episode"
		nameLabel.text = "??????"
		
		contentView.addSubview(imageView)
		
		let labelCell = TwoLabels(frame: .zero, nameLabel: nameLabel)
		labelCell.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(labelCell)
	
		let viewCell = BottomView(frame: .zero, label: episodeLabel)
		viewCell.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(viewCell)
		
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: labelCell.topAnchor),
			
			labelCell.bottomAnchor.constraint(equalTo: viewCell.topAnchor),
			labelCell.heightAnchor.constraint(equalToConstant: 50),
			labelCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			labelCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			
			viewCell.heightAnchor.constraint(equalToConstant: 50),
			viewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			viewCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			viewCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}

	@objc private func addToFavoritesTapped() {
		addToFavoritesAction?()
	}

	func configure(with item: Item) {
		nameLabel.text = item.episode
		imageView.image = UIImage(named: item.imageName)
		episodeLabel.text = item.episode
		
	}
}

struct ItemCellViewPreviews: PreviewProvider {
	struct ViewControllerContainer: UIViewControllerRepresentable {
		func makeUIViewController(context: Context) -> some UIViewController {
			UINavigationController(rootViewController: EpisodesViewController(network: NetworkManager()))
		}
		func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
	}
	static var previews: some View {
		ViewControllerContainer().edgesIgnoringSafeArea(.all)
	}
}
