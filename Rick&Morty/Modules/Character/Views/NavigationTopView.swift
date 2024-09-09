//
//  NavigationTopView.swift
//  Rick&Morty

import UIKit

// MARK: NavigationTopView

final class NavigationTopView: UIView {
	
	// MARK: Properties
	
	private let image = UIImageView()
	private let buttot = UIButton(type: .system)
	
	private let goBack: () -> ()
	
	init(frame: CGRect, goBack: @escaping () -> ()) {
		self.goBack = goBack
		super.init(frame: frame)
		setupElement()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Setup SubViews
	
	private func setupElement() {
		
		self.backgroundColor = .white
		let action = UIAction { [weak self] _ in
			self?.goBack()
		}
		
		buttot.setTitle("← GO BACK", for: .normal)
		buttot.setTitleColor(.black, for: .normal)
		buttot.titleLabel?.font = .boldSystemFont(ofSize: 17)
		buttot.addAction(action, for: .touchUpInside)
		
		image.image = UIImage(named: "logotype")
		image.layer.cornerRadius = 10
		image.contentMode = .scaleAspectFit
		image.clipsToBounds = true
		image.layer.borderColor = UIColor.white.cgColor
		image.layer.borderWidth = 1
		
		[image, buttot].forEach {
			addSubview($0)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		setupFrame()
	}
	
	// MARK: Setup Frame
	
	private func setupFrame() {
		buttot.frame = CGRect(
			x: 10,
			y: (self.bounds.height - 50) / 2,
			width: 100,
			height: 50
		)
		image.frame = CGRect(
			x: self.bounds.width - 60,
			y: (self.bounds.height - 50) / 2,
			width: 50,
			height: 50
		)
	}
}

