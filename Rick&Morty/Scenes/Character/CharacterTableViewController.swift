//
//  CharacterTableViewController.swift

import UIKit

final class CharacterTableViewController: UIViewController {
	
	// MARK: Properties
	
	private let imageCharacter = UIImageView()
	private let tableView = UITableView(frame: .zero, style: .insetGrouped)
	private var dataSource: UITableViewDiffableDataSource<Sections, Сharacteristics>?
	private lazy var topView = NavigationTopView(frame: .zero, goBack: { [weak self] in
		self?.back()
	})
	
	var viewModel: CharacterTableViewModelProtocol?
	
	// MARK: Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		setupElements()
		setupContraints()
		tableDataSourse(tableView: tableView)
	}

	// MARK: Methods
	
	private func tableDataSourse(tableView: UITableView) {
		configureDataSourse(tableView: tableView)
		updateSnapshot()
	}
	
	private func setupElements() {
		
		[topView, tableView].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview($0)
		}
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.delegate = self
		tableView.backgroundColor = .white
		tableView.isScrollEnabled = false
	}
	
	private func setupHeader() -> UIView? {
		guard let pers = viewModel?.character else { return nil }
		let header = HeaderView(
			frame: .zero,
			nameCharacter: pers.namePers,
			imageUrl: pers.imagePers, imageCharacterView: imageCharacter
		)
		header.bottonPhotoTapped = { [weak self] in
			self?.showAler()
		}
		return header
	}
	
	private func showAler() {
		let alert = UIAlertController(
			title: "Загрузите изображение",
			message: nil,
			preferredStyle: .actionSheet
		)

		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		self.present(alert, animated: true)
	}
	
	private func setupContraints() {
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
	
	private func back() {
		viewModel?.goBack()
	}
}
// MARK: - Tableview DataSource / Delegate

extension CharacterTableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		setupHeader()
	}
	
	private func configureDataSourse(tableView: UITableView) {
		guard let character = viewModel?.character else { return }
		
		dataSource = UITableViewDiffableDataSource<Sections, Сharacteristics>(tableView: tableView) {
			(tableView, indexPath, item) -> UITableViewCell? in
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
			var content = cell.defaultContentConfiguration()
			content.secondaryTextProperties.font = .boldSystemFont(ofSize: 20)
			switch item {
				case .gender:
					content.text = "Gender"
					content.secondaryText = character.genderPers
				case .origin:
					content.text = "Origin"
					content.secondaryText = character.statusPers
				case .specie:
					content.text = "Specie"
					content.secondaryText = character.speciePers
				case .status:
					content.text = "Status"
					content.secondaryText = character.originPers
			}
			
			cell.contentConfiguration = content
			return cell
		}
	}
	
	private func updateSnapshot() {
		guard let info = viewModel?.getSectionInfo() else { return }
		var snapshot = NSDiffableDataSourceSnapshot<Sections, Сharacteristics>()
		snapshot.appendSections([.main])
		
		snapshot.appendItems(info)
		dataSource?.apply(snapshot, animatingDifferences: true)
	}
}
