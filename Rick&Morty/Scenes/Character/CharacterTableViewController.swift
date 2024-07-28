//
//  CharacterTableViewController.swift

import UIKit
import SwiftUI



final class CharacterTableViewController: UIViewController {
	
	var item: EpisodeTest?
	
	let tableView = UITableView(frame: .zero, style: .insetGrouped)
		
	private let imageCharacterView = UIImageView()
	private let buttonPhoto = UIButton()
	private let nameCharacterLabel = UILabel()
	private let infoLabel = UILabel()
	private let backButton = UIButton(type: .system)
	
	private let titles = ["Gender", "Status", "Specie", "Oridin"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		backButton.setTitle("Back", for: .normal)
		backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
		setupTable()
		setupTopView()
		
	}
	
	func setupTopView() {
		
		let topView = NavigationTopView(frame: .zero, buttot: backButton)
		topView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(topView)
		
		NSLayoutConstraint.activate([
			
			topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			topView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
			topView.heightAnchor.constraint(equalToConstant: 70),
			
			tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
		
	}
	
	@objc func back() {
		print("!!!!")
		navigationController?.popViewController(animated: true)
	}
	
	func setupTable() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(tableView)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.dataSource = self
		tableView.delegate = self
		tableView.backgroundColor = .white
		tableView.isScrollEnabled = false
		
//		NSLayoutConstraint.activate([
//			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//			tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//			tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//		])
	}
	
	func setHeader() -> UIView {
		
		let header = HeaderView(
			frame: .zero,
			imageCharacterView: imageCharacterView,
			buttonPhoto: buttonPhoto,
			nameCharacterLabel: nameCharacterLabel,
			infoLabel: infoLabel
		)
		return header
	}
	
	deinit {
		print("deinit CharacterTable")
	}
	
}
    // MARK: - Table view data source

extension CharacterTableViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		setHeader()
		
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		titles.count
    }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		var content = cell.defaultContentConfiguration()
		cell.selectionStyle = .none
		content.text = titles[indexPath.row]
		content.secondaryText = item?.genderPers
		cell.contentConfiguration = content
		
		
		return cell
	}
}

// MARK: - Preview

struct CharacterViewPreviews: PreviewProvider {
	struct ViewControllerContainer: UIViewControllerRepresentable {
		func makeUIViewController(context: Context) -> some UIViewController {
			UINavigationController(rootViewController: CharacterTableViewController())
		}
		func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
	}
	static var previews: some View {
		ViewControllerContainer().edgesIgnoringSafeArea(.all)
	}
}
