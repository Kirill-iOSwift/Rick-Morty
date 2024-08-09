//
//  NavigationTopView.swift
//  Rick&Morty

import UIKit

// MARK: -NavigationTopView

final class NavigationTopView: UIView {
	
	// MARK: Properties
	
	private let image = UIImageView()
	private let buttot = UIButton(type: .system)
	
	private let goBack: () -> ()
	
	init(frame: CGRect, goBack: @escaping () -> ()) {
		self.goBack = goBack
		super.init(frame: frame)
		setupElement()
		setupConstraints()
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
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}
	}
	
	// MARK: Setup Constraints
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			buttot.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			buttot.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
			buttot.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
			buttot.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
			
			image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			image.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
			image.widthAnchor.constraint(equalToConstant: 50),
			image.heightAnchor.constraint(equalToConstant: 50),
		])
	}
}
