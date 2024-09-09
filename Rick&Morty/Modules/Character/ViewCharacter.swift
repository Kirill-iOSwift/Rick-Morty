//
//  CharacterTableViewController.swift

import UIKit

final class CharacterTableViewController: UIViewController {
	
	// MARK: Properties
	
	private let imageCharacter = UIImageView()
	private let tableView = UITableView(frame: .zero, style: .insetGrouped)
	private var dataSource: UITableViewDiffableDataSource<Sections, Сharacteristics>?
	private lazy var topView = NavigationTopView(frame: .zero, goBack: { [weak self] in
		self?.returnToPreviousScreen()
	})
	
	var viewModel: (any CharacterTableViewModelProtocol)?
	var picker: ImagePickerProtocol?
	
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
			imageUrl: pers.imagePers,
			imageCharacterView: imageCharacter
		)
		
		header.bottonPhotoTapped = { [weak self] in
			self?.showAler()
		}
		return header
	}
	
	// MARK: - Alert Controller
	
	private func showAler() {

		let alert = UIAlertController(
			title: "Загрузите изображение",
			message: nil,
			preferredStyle: .actionSheet
		)
		
		let camera = UIAlertAction(title: "Камера", style: .default) { _ in
			self.showPicker(camera: true)
		}
		
		let galery = UIAlertAction(title: "Галерея", style: .default) { _ in
			self.showPicker(camera: false)
		}
		
		let cancel = UIAlertAction(title: "Отменить", style: .cancel)
		
		alert.addAction(camera)
		alert.addAction(galery)
		alert.addAction(cancel)
		
		self.present(alert, animated: true)
	}
	
	func showPicker(camera: Bool) {
		picker = ImagePicker(parentViewController: self)
		if camera {
			picker?.showImagePicker(sourceType: .camera, filter: nil) { [weak self] image in
				self?.imageCharacter.image = image
			}
		} else {
			picker?.showImagePicker(sourceType: nil, filter: .images) { [weak self] image in
				self?.imageCharacter.image = image
			}
		}
	}
	
	private func showAlertAccess(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let resolve = UIAlertAction(title: "Разрешить", style: .default)
		let cancel = UIAlertAction(title: "Отменить", style: .cancel)
		
		alert.addAction(resolve)
		alert.addAction(cancel)
		
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
	
	private func returnToPreviousScreen() {
		viewModel?.returnToPreviousScreen()
	}
}
// MARK: - Tableview DataSource / Delegate

extension CharacterTableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		setupHeader()
	}
	
	private func configureDataSourse(tableView: UITableView) {
		
		dataSource = UITableViewDiffableDataSource<Sections, Сharacteristics>(tableView: tableView) {
			(tableView, indexPath, item) -> UITableViewCell? in
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
			var content = cell.defaultContentConfiguration()
			content.secondaryTextProperties.font = .boldSystemFont(ofSize: 20)
			
			if let configuraion = self.viewModel?.getConfiguration(for: item) {
				content.text = configuraion.text
				content.secondaryText = configuraion.secondaryText
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

