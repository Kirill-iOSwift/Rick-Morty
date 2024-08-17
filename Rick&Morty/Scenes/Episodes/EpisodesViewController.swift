//
//  EpisodesViewController.swift
//  Rick&Morty

import UIKit

final class EpisodesViewController: UIViewController {
	
	// MARK: - enum DDS
	
	enum Section: Hashable {
		case main
	}
	
	// MARK: Private properties
	
	private let searchBar = UISearchBar()
	private let logoImageView = UIImageView()
	private let buttonSort = UIButton(type: .system)
	private var collectionView: UICollectionView!
	private var dataSource: UICollectionViewDiffableDataSource<Section, Episode>?
	
	
	// MARK: Dependency
	
	weak var viewModel: EpisodesViewModelProtocol?
	
	// MARK: Initialization
	
	init(viewModel: EpisodesViewModelProtocol) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setupElements()
		setupCollectionView()
		binding()
		setupConstraints()
	}
	
	// MARK: - Private Meathods
	
	// MARK: Setup UI
	
	func binding() {
		DispatchQueue.main.async { [weak self] in
			self?.viewModel?.updateUI = {
				self?.updateSnapshot()
			}
		}
	}
	
	private func setupElements() {
		setupMenuSort()
		logoImageView.image = UIImage(named: "logo")
		setupSearchBar()
		
		[logoImageView, searchBar, buttonSort].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview($0)
		}
	}
	
	func setupMenuSort() {
		buttonSort.customizeSortdButton()
		let actionSortName = UIAction(title: "Название") { _ in
			self.viewModel?.sortName()
		}
		
		let actionSortSeason = UIAction(title: "Сезон") { _ in
			self.viewModel?.sortSeason()
		}
		
		let menu = UIMenu(title: "Сортировка", children: [actionSortName, actionSortSeason])
		
		buttonSort.menu = menu
		buttonSort.showsMenuAsPrimaryAction = true
	}
}

// MARK: - Setup SearchBar

extension EpisodesViewController: UISearchBarDelegate {
	
	func setupSearchBar() {
		searchBar.placeholder = "Search number series"
		searchBar.delegate = self
		searchBar.keyboardType = .numberPad
		searchBar.inputAccessoryView = createAccessoryView()
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		viewModel?.filterEpisodes(by: searchText)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
	private func createAccessoryView() -> UIView {
		let toolbar = UIToolbar()
		toolbar.sizeToFit()
		toolbar.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1)
		let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
		doneButton.tintColor = .black
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		toolbar.setItems([flexibleSpace, doneButton], animated: false)
		return toolbar
	}
	
	@objc private func doneButtonTapped() {
		searchBar.resignFirstResponder()
	}
}

// MARK: - Setup CollectionView

extension EpisodesViewController: UICollectionViewDelegate {
	
	func setupCollectionView() {
		addCollectionView(layout: createLayout())
		collectionView.delegate = self
		configureDataSourse(collectionView: collectionView)
		updateSnapshot()
	}
	
	func createLayout() -> UICollectionViewLayout {
		
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1),
			heightDimension: .fractionalHeight(1)
		)
		
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1),
			heightDimension: .fractionalHeight(0.7)
		)
		let group = NSCollectionLayoutGroup.vertical(
			layoutSize: groupSize,
			subitems: [item]
		)
		
		let section = NSCollectionLayoutSection(group: group)
		section.interGroupSpacing = 30
		section.contentInsets = NSDirectionalEdgeInsets(
			top: 10,
			leading: 20,
			bottom: 10,
			trailing: 20
		)
		
		let layout = UICollectionViewCompositionalLayout(section: section)
		return layout
	}
	
	func addCollectionView(layout: UICollectionViewLayout) {
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
		collectionView.register(
			EpisodeCellView.self, forCellWithReuseIdentifier: EpisodeCellView.reuseIdentifier)
		
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(collectionView)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		if searchBar.isFirstResponder {
			return  // Не обрабатываем касания, если клавиатура видима
		}
		
		guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
		let charVC = CharacterTableViewController()
		charVC.viewModel = viewModel?.getViewModelCharacter(item: item)
		viewModel?.openCell(viewController: charVC)
	}
}

// MARK: - Setup DDS

extension EpisodesViewController {
	
	private func configureDataSourse(collectionView: UICollectionView) {
		dataSource = UICollectionViewDiffableDataSource<Section, Episode>(collectionView: collectionView) {
			(collectionView, indexPath, item) -> UICollectionViewCell? in
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: EpisodeCellView.reuseIdentifier,
				for: indexPath
			) as? EpisodeCellView else { return UICollectionViewCell() }
			
			cell.configure(with: item, swipe: true)
			
			cell.onFavouriteToggle = { [weak self] in
				self?.viewModel?.toggleFavorite(for: item)
			}
			cell.onDelete = { [weak self] in
				self?.delete(item: item)
			}
			
			return cell
		}
	}
	
	private func updateSnapshot() {
		guard let viewModel = viewModel else { return }
		var snapshot = NSDiffableDataSourceSnapshot<Section, Episode>()
		snapshot.appendSections([.main])
		snapshot.appendItems(viewModel.episodes)
		self.dataSource?.apply(snapshot, animatingDifferences: true)
	}
	
	private func delete(item: Episode) {
		viewModel?.removeEpisode(item: item)
		updateSnapshot()
	}
}


// MARK: - Setup Constraints

private extension EpisodesViewController {
	func setupConstraints() {
		
		NSLayoutConstraint.activate([
			logoImageView.heightAnchor.constraint(equalToConstant: 100),
			logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			
			searchBar.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
			searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
			
			buttonSort.heightAnchor.constraint(equalToConstant: 60),
			buttonSort.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
			buttonSort.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			buttonSort.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			collectionView.topAnchor.constraint(equalTo: buttonSort.bottomAnchor, constant: 10),
			collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
	}
}
