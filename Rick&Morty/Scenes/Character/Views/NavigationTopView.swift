//
//  NavigationTopView.swift
//  Rick&Morty

import UIKit

final class NavigationTopView: UIView {
	let image = UIImageView()
	var buttot: UIButton
	
	init(frame: CGRect, buttot: UIButton) {
		self.buttot = buttot
		super.init(frame: frame)
		setupElement()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupElement() {
		
		self.backgroundColor = .white
		
		buttot.setTitle("← GO BACK", for: .normal)
		buttot.setTitleColor(.black, for: .normal)
		buttot.titleLabel?.font = .boldSystemFont(ofSize: 17)
		
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
	
	func setupConstraints() {
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
	
	deinit {
		print("deinit NavView")
	}
}
