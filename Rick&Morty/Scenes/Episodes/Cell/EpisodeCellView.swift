//
//  EpisodeViewCell.swift
//  Rick&Morty

import UIKit

// MARK: - EpisideView Cell

final class EpisodeCellView: UICollectionViewCell {
	
	// MARK: Properties
	
	static let reuseIdentifier = "ItemCell"
	
	private var originalCenter: CGPoint = .zero
	
	private var imageView = UIImageView()
	private let nameLabel = UILabel()
	private let episodeLabel = UILabel()
	private var image = UIImageView()
	private var like: Bool = false
	
	var onFavouriteToggle: (() -> Void)?
	var onDelete: (() -> Void)?
	
	private var swipeOn: Bool = true
	
	private lazy var labelCell = NameLabel(frame: .zero, nameLabel: nameLabel)
	private lazy var viewCell = BottomView(frame: .zero, label: episodeLabel, button: button, image: image)
	
	var button = UIButton(type: .system)
	
	// MARK: Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupCell()
		setupViews()
		setupConstraints()
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
		contentView.layer.cornerRadius = 20
		contentView.layer.shadowColor = UIColor.black.cgColor
		contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
		contentView.layer.shadowRadius = 4
		contentView.layer.shadowOpacity = 0.5
	}
	
	private func setupViews() {
		
		[imageView, labelCell, viewCell].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview($0)
		}
		image.image = UIImage(systemName: "play.tv")
		
		button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
		button.addTarget(self, action: #selector(tap), for: .touchUpInside)
	}
	
	// MARK: Setup Constraints
	
	private func setupConstraints() {
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
		UIView.animate(withDuration: 0.1, animations: {
			self.button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
		}) { _ in
			UIView.animate(withDuration: 0.1) {
				self.button.transform = .identity
			}
		}
		onFavouriteToggle?()
	}
	
	// MARK: Configure
	
	func configure(with item: Episode, swipe: Bool) {
		let color: UIColor = item.isFavourite ? .red : .lightGray
		button.tintColor = color
		nameLabel.text = item.nameEpisode
		episodeLabel.text = item.numberEpisode
		imageView.setImage(from: item.imagePers)
		swipeOn = swipe
		
		if swipeOn {
			setupGestureRecognizers()
		}
	}
	
	// MARK: - Gesture Recognaizer
	
	private func setupGestureRecognizers() {
		let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(hendleSwipeLeft(_:)))
		leftSwipe.direction = .left
		self.addGestureRecognizer(leftSwipe)
	}
	
	@objc private func hendleSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
		if gesture.direction == .left {
			UIView.animate(withDuration: 0.3) {
				self.frame.origin.x = -(self.frame.width * 2)
			} completion: { _ in
				self.onDelete?()
			}
		}
	}
}
