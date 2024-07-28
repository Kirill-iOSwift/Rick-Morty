//
//  EpisodeViewCell.swift
//  Rick&Morty

import UIKit
import SwiftUI

final class ItemCell: UICollectionViewCell {
	static let reuseIdentifier = "ItemCell"

	private var imageView = UIImageView()
	private let nameLabel = UILabel()
	private let episodeLabel = UILabel()
	
//	var addToFavoritesAction: (() -> Void)?

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
	
	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
		nameLabel.text = nil
		episodeLabel.text = nil
	}

	private func setupViews() {
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		episodeLabel.text = "Episode"
		nameLabel.text = "??????"
		
		contentView.addSubview(imageView)
		
		let labelCell = NameLabel(frame: .zero, nameLabel: nameLabel)
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

//	@objc private func addToFavoritesTapped() {
//		addToFavoritesAction?()
//	}
	func configure(with item: Item) {
			nameLabel.text = item.name
			episodeLabel.text = item.episode
			if let imageURL = item.imageName {
				imageView.setImage(from: imageURL)
				//imageView.loadImage(from: imageURL)
			} else {
				imageView.image = nil
			}
		}
}

//struct ItemCellViewPreviews: PreviewProvider {
//	struct ViewControllerContainer: UIViewControllerRepresentable {
//		func makeUIViewController(context: Context) -> some UIViewController {
//			UINavigationController(rootViewController: EpisodesViewController())
//		}
//		func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
//	}
//	static var previews: some View {
//		ViewControllerContainer().edgesIgnoringSafeArea(.all)
//	}
//}

