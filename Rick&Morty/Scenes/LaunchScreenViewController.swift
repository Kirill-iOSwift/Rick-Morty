//
//  LaunchScreenViewController.swift
//  Rick&Morty

import UIKit

final class LaunchScreenViewController: UIViewController {
	
	private let logoImageView = UIImageView()
	private let portalImageView = UIImageView()
	
	var coordinator: MainCoordinator?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		setPortal()
		setLogotype()
		rotationPortal()
		
	}
	
	private func setLogotype() {
		view.addSubview(logoImageView)
		logoImageView.translatesAutoresizingMaskIntoConstraints = false
		logoImageView.image = UIImage(named: "logo")
		logoImageView.contentMode = .scaleAspectFill
		
		NSLayoutConstraint.activate([
			
			logoImageView.heightAnchor.constraint(equalToConstant: 100),
			logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
			logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  30),
			logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -30)
		])
	}
	
	private func setPortal() {
		view.addSubview(portalImageView)
		portalImageView.translatesAutoresizingMaskIntoConstraints = false
		portalImageView.image = UIImage(named: "portal")
		
		NSLayoutConstraint.activate([
			
			portalImageView.widthAnchor.constraint(equalToConstant: 300),
			portalImageView.heightAnchor.constraint(equalToConstant: 300),
			
			portalImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			portalImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
	
	private func rotationPortal() {
		let rotation = CABasicAnimation(keyPath: "transform.rotation")
//		rotation.fromValue = 0
		rotation.toValue = Double.pi * 2  // Полный оборот (360 градусов)
		rotation.duration = 1 // Продолжительность 5 секунд
		//rotation.isCumulative = true
		rotation.repeatCount = .infinity
//		NSLog("\(#function)", rotation.duration)
//		rotation.fillMode = .forwards
//		rotation.isRemovedOnCompletion = false
		portalImageView.layer.add(rotation, forKey: "rotationAnimation")
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			self.coordinator?.startNext()
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		   super.viewWillDisappear(animated)
		   
		   // Остановка анимации перед переходом на другой экран
		   portalImageView.layer.removeAnimation(forKey: "rotationAnimation")
	   }
	   
	   deinit {
		   // Дополнительная очистка, если требуется
		   print("ViewController deinitialized")
	   }
}

