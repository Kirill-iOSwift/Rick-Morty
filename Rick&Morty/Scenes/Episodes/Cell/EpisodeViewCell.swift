//
//  EpisodeViewCell.swift
//  Rick&Morty

import UIKit

// MARK: - EpisideView Cell

final class EpisodeViewCell: UICollectionViewCell {
	
	// MARK: Properties
	
	static let reuseIdentifier = "ItemCell"
	
	private var originalCenter: CGPoint = .zero
	var deleteAction: (() -> Void)?
	
	private var imageView = UIImageView()
	private let nameLabel = UILabel()
	private let episodeLabel = UILabel()
	private var image = UIImageView()
	private var like = false
	
	var onFavouriteToggle: (() -> Void)?
	var onDelete: (() -> Void)?
	
	
	private lazy var labelCell = NameLabel(frame: .zero, nameLabel: nameLabel)
	private lazy var viewCell = BottomView(frame: .zero, label: episodeLabel, button: button, image: image)
	
	var button = UIButton(type: .system)
	
	// MARK: Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupCell()
		setupViews()
		setupConstraints()
		setupGestureRecognizers()
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
	
	func configure(with item: Episode) {
		let color: UIColor = item.isFavourite ? .red : .lightGray
		button.tintColor = color
		nameLabel.text = item.nameEpisode
		episodeLabel.text = item.numberEpisode
		imageView.setImage(from: item.imagePers)
	}
	
// MARK: - Gesture Recognaizer
	
	private func setupGestureRecognizers() {
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeLeftCellForDelete(_:)))
		panGesture.delegate = self
		self.addGestureRecognizer(panGesture)
	}
	
	@objc private func swipeLeftCellForDelete(_ gesture: UIPanGestureRecognizer) {
		let translation = gesture.translation(in: self)
		
		switch gesture.state {
			case .began:
				originalCenter = self.center
				
			case .changed:
				if translation.x < 0 {
					self.center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
				}
				
			case .ended, .cancelled:
				let threshold: CGFloat = 0.5
				if self.center.x < originalCenter.x * (1 - threshold) {
					UIView.animate(withDuration: 0.3) {
						self.center = CGPoint(x: -self.frame.size.width, y: self.originalCenter.y)
					} completion: { _ in
						self.onDelete?()
					}
				} else {
					UIView.animate(withDuration: 0.3) {
						self.center = self.originalCenter
					}
				}
				
			default:
				break
		}
	}
}

extension EpisodeViewCell: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		if gestureRecognizer is UIPanGestureRecognizer {
			return true
		}
		return false
	}
}
