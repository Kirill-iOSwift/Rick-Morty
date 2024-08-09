//
//  LaunchScreenViewController.swift
//  Rick&Morty

import UIKit

// MARK: - Launch Screen ViewController

final class LaunchScreenViewController: UIViewController {
	
	// MARK: Private properties
	
	private let logoImageView = UIImageView()
	private let portalImageView = UIImageView()
	
	// MARK: Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		setupElements()
		setupLayout()
		rotationPortal()
	}

	// MARK: - Private Meathods
	
	// MARK: SetupUI
	
	private func setupElements() {
		
		[logoImageView, portalImageView].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview($0)
		}
		
		portalImageView.image = UIImage(named: "portal")
		logoImageView.image = UIImage(named: "logo")
		logoImageView.contentMode = .scaleAspectFill
	}
	
	// MARK: Animation Method
	
	private func rotationPortal() {
		
		let rotation = CABasicAnimation(keyPath: "transform.rotation")
		rotation.toValue = Double.pi * 2
		rotation.duration = 0.5
		rotation.repeatCount = .infinity
		portalImageView.layer.add(rotation, forKey: "rotationAnimation")
	}
	
	// MARK: Setup Costraints
	
	private func setupLayout() {
		
		NSLayoutConstraint.activate([
			logoImageView.heightAnchor.constraint(equalToConstant: 100),
			logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
			logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  30),
			logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -30),
			
			portalImageView.widthAnchor.constraint(equalToConstant: 300),
			portalImageView.heightAnchor.constraint(equalToConstant: 300),
			portalImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			portalImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
	
	deinit {
		print("Deinit LaunchScreen")
	}
}

