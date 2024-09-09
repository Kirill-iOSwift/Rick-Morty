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
		rotationPortal()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupFrame()
	}
	
	// MARK: SetupUI
	
	private func setupFrame() {
		
		self.view.addSubview(logoImageView)
		self.view.addSubview(portalImageView)
		
		let logoIndent: CGFloat = 30
		
		logoImageView.frame = CGRect(
			x: logoIndent,
			y: view.safeAreaInsets.top + (logoIndent * 2),
			width: view.frame.width - (logoIndent * 2),
			height: 100
		)
		
		let portalSize: CGFloat = 300
		
		portalImageView.frame = CGRect(
			x: (view.frame.width - portalSize) / 2,
			y: (view.frame.height - portalSize) / 2,
			width: portalSize,
			height: portalSize
		)
		
		portalImageView.image = UIImage(named: "portal")
		logoImageView.image = UIImage(named: "logo")
		logoImageView.contentMode = .scaleAspectFill
	}
	
	// MARK: Animation 
	
	private func rotationPortal() {
		
		let rotation = CABasicAnimation(keyPath: "transform.rotation")
		rotation.toValue = Double.pi * 2
		rotation.duration = 0.5
		rotation.repeatCount = .infinity
		portalImageView.layer.add(rotation, forKey: "rotationAnimation")
	}
}
