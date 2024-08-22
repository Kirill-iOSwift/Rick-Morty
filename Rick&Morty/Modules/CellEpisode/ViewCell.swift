//
//  EpisodeViewCell.swift
//  Rick&Morty

import UIKit

// MARK: - EpisideView Cell

final class EpisodeCellView: UICollectionViewCell {
	
	// MARK: Properties
	
	static let cellIdentifier = "ItemCell"
	
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
			contentView.addSubview($0)
		}
		image.image = UIImage(systemName: "play.tv")
		
		button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
		button.addTarget(self, action: #selector(likeButtonPress), for: .touchUpInside)
	}
	
	// MARK: Setup Frame
	
	override func layoutSubviews() {
		super.layoutSubviews()
		setupFrame()
	}
	
	private func setupFrame() {
		let _: CGFloat = 15
		let labelHeight: CGFloat = 50
		let viewCellHeight: CGFloat = 50
		
		// Установка фрейма для imageView
		imageView.frame = CGRect(
			x: 0,
			y: 0,
			width: bounds.width,
			height: bounds.height - labelHeight - viewCellHeight
		)
		
		// Установка фрейма для labelCell
		labelCell.frame = CGRect(
			x: 0,
			y: imageView.frame.maxY,
			width: bounds.width,
			height: labelHeight
		)
		
		// Установка фрейма для viewCell
		viewCell.frame = CGRect(
			x: 0,
			y: labelCell.frame.maxY,
			width: bounds.width,
			height: viewCellHeight
		)
		
	}
	
	@objc private func likeButtonPress() {
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
	
	func configurator(with model: ViewModelCollectionCellProtocol, swipe: Bool) {
		let color: UIColor = model.isFavourite ? .red : .lightGray
		button.tintColor = color
		nameLabel.text = model.titleEpisode
		episodeLabel.text = model.numberEpisode
		imageView.setImage(from: model.imageEpisode)
		swipeOn = swipe
		
		if swipeOn {
			setupGestureRecognizers()
		}
	}
}

// MARK: - Gesture Recognaizer

private extension EpisodeCellView {
	
	func setupGestureRecognizers() {
		let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(hendleSwipeLeft(_:)))
		leftSwipe.direction = .left
		self.addGestureRecognizer(leftSwipe)
	}
	
	@objc func hendleSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
		if gesture.direction == .left {
			UIView.animate(withDuration: 0.3) {
				self.frame.origin.x = -(self.frame.width * 2)
			} completion: { _ in
				self.onDelete?()
			}
		}
	}
}

