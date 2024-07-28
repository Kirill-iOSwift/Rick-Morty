//
//  CellView.swift
//  Rick&Morty

import UIKit

final class BottomView: UIView {
	
	var label: UILabel
	var button: UIButton
	var image: UIImageView
	
	init(frame: CGRect, label: UILabel, button: UIButton, image: UIImageView) {
		self.label = label
		self.button = button
		self.image = image
		super.init(frame: frame)
		setupView()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupView() {
		self.backgroundColor = .systemGray6
		image.tintColor = .black
		label.font = .systemFont(ofSize: 22)
		self.layer.cornerRadius = 20
		
		button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
[image, label, button].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			image.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 15),
			image.widthAnchor.constraint(equalToConstant: 30),
			image.heightAnchor.constraint(equalToConstant: 30),
			
			label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
			
			button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
		])
	}
}

class NameLabel: UIView {
	
	let nameLabel: UILabel
	
	init(frame: CGRect, nameLabel: UILabel) {
		self.nameLabel = nameLabel
		super.init(frame: frame)
		setLabels()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setLabels() {
		self.backgroundColor = .white
		
		nameLabel.font = .boldSystemFont(ofSize: 22)
		
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(nameLabel)
		
		NSLayoutConstraint.activate([
			nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
			nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		])
	}
}

// MARK: - Preview

//struct CellViewPreviews: PreviewProvider {
//	struct ViewControllerContainer: UIViewControllerRepresentable {
//		func makeUIViewController(context: Context) -> some UIViewController {
//			UINavigationController(rootViewController: EpisodesViewController())
//		}
//		func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
//	}
//	static var previews: some View {
//		ViewControllerContainer().edgesIgnoringSafeArea(.all)
//	}
//}
