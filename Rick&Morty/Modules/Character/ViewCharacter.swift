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
//		setupContraints()
		tableDataSourse(tableView: tableView)
	}
	
	// MARK: Methods
	
	private func tableDataSourse(tableView: UITableView) {
		configureDataSourse(tableView: tableView)
		updateSnapshot()
	}
	
	private func setupElements() {
		
		[topView, tableView].forEach {
//			$0.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview($0)
		}
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.delegate = self
		tableView.backgroundColor = .white
		tableView.isScrollEnabled = false
		

	}
	
	private func setupHeader() {
		guard let pers = viewModel?.character else { return }
		
		let header = HeaderView(
			frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300),
			nameCharacter: pers.namePers,
			imageUrl: pers.imagePers,
			imageCharacterView: imageCharacter
		)
		
		header.bottonPhotoTapped = { [weak self] in
			self?.showAler()
		}
		
		tableView.tableHeaderView = header
		tableView.layoutIfNeeded()
	}
	
	// MARK: - Alert Controller
	
	private func showAler() {
		
//		showBlurEffect()
				
		let alert = UIAlertController(
			title: "Загрузите изображение",
			message: nil,
			preferredStyle: .actionSheet
		)
		
		let camera = UIAlertAction(title: "Камера", style: .default) { _ in
//			self.showAlertAccess(
//				title: "Разрешить доступ к камере",
//				message: "Это необходимо, чтобы сканировать штрих-коды, номер карты и использовать другие возможности"
//			)
			self.showPicker(camera: true)
		}
		
		let galery = UIAlertAction(title: "Галерея", style: .default) { _ in
//			self.showAlertAccess(
//				title: "Разрешить доступ к \"Фото\"",
//				message: "Это необходимо для добавления ваших фотографий"
//			)
			self.showPicker(camera: false)
		}
		let cancel = UIAlertAction(title: "Отменить", style: .cancel) { _ in
			
		}
		
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
	
	// MARK: Blur

	let blurEffectView = UIVisualEffectView()
	private func animateImageAndShowAlert() {
		
	}
	
	private func showBlurEffect() {
		let blurEffect = UIBlurEffect(style: .dark)
		blurEffectView.effect = blurEffect
		blurEffectView.frame = view.bounds

		view.addSubview(blurEffectView)
		view.insertSubview(imageCharacter, aboveSubview: blurEffectView)
	}
	
	private func dismissBlurEffectAndReturnImage() {
		
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupHeader()
		setupFrames()
	}
	
// MARK: - Setup Constraints
	
	private func setupFrames() {
		let safeAreaInsets = view.safeAreaInsets
		
		// Установка фрейма для topView
		let topViewHeight: CGFloat = 70
		let topViewWidth = view.bounds.width - (safeAreaInsets.left + safeAreaInsets.right)
		
		topView.frame = CGRect(
			x: safeAreaInsets.left,
			y: safeAreaInsets.top,
			width: topViewWidth,
			height: topViewHeight
		)
		
		// Установка фрейма для tableView
		tableView.frame = CGRect(
			x: safeAreaInsets.left,
			y: topView.frame.maxY,
			width: topViewWidth,
			height: view.bounds.height - topView.frame.maxY - safeAreaInsets.bottom
		)
	}

//	
//	private func setupContraints() {
//		NSLayoutConstraint.activate([
//			
//			topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//			topView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
//			topView.heightAnchor.constraint(equalToConstant: 70),
//			
//			tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
//			tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//			tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//		])
//	}
	
	private func returnToPreviousScreen() {
		viewModel?.returnToPreviousScreen()
	}
	
	deinit {
		print("deinit VC")
	}
}
// MARK: - Tableview DataSource / Delegate

extension CharacterTableViewController: UITableViewDelegate {
//	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//		setupHeader()
//	}
	
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

//import SwiftUI
//struct ViewControllerProvider: PreviewProvider {
//	static var previews: some View {
//		ContainerView().edgesIgnoringSafeArea(.all)
//	}
//	struct ContainerView: UIViewControllerRepresentable {
//		func makeUIViewController(context: Context) -> some UIViewController {
//			return CharacterTableViewController()
//		}
//		func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
//	}
//}

