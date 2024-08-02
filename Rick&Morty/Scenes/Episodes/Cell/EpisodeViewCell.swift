//
//  EpisodeViewCell.swift
//  Rick&Morty

import UIKit

// MARK: - EpisideView Cell

final class EpisideViewCell: UICollectionViewCell {
	
	// MARK: Properties
	
	static let reuseIdentifier = "ItemCell"
	
	private var imageView = UIImageView()
	private let nameLabel = UILabel()
	private let episodeLabel = UILabel()
	private var image = UIImageView()
	
	var button = UIButton(type: .system)
	var like = false
	
	// MARK: Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupCell()
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Methods
	
	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
		nameLabel.text = nil
		episodeLabel.text = nil
	}

	private func setupCell() {
		contentView.backgroundColor = .white
		contentView.layer.cornerRadius = 12
		contentView.layer.shadowColor = UIColor.black.cgColor
		contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
		contentView.layer.shadowRadius = 4
		contentView.layer.shadowOpacity = 0.5
	}
		
	private func setupViews() {
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		contentView.addSubview(imageView)
		
		let labelCell = NameLabel(frame: .zero, nameLabel: nameLabel)
		labelCell.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(labelCell)
		
		image.image = UIImage(systemName: "play.tv")
		
		button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
		button.imageView?.contentMode = .scaleToFill
		
		button.tintColor = .lightGray
		button.addTarget(self, action: #selector(tap), for: .touchUpInside)
		
		let viewCell = BottomView(frame: .zero, label: episodeLabel, button: button, image: image)
		viewCell.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(viewCell)
		
		// MARK: Setup Constraints
		
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
	
	@objc private func tap() {
		button.tintColor = like ? .red : .lightGray
		like.toggle()
		
	}
	
	// MARK: Configure
	
	func configure(with item: EpisodeTest){
		nameLabel.text = item.nameEpisode
		episodeLabel.text = item.numberEpisode
		imageView.setImage(from: item.imagePers)
	}
}

