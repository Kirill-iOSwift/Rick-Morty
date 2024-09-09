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
	
	weak var viewModel: ViewModelEpisodeProtocol?
	
	// MARK: Initialization
	
	init(viewModel: ViewModelEpisodeProtocol) {
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
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupFrame()
	}
		
	// MARK: Setup UI
	
	func binding() {
			viewModel?.updateUI = {
				DispatchQueue.main.async { [weak self] in
				self?.updateSnapshot()
			}
		}
	}
	
	private func setupElements() {
		setupMenuSort()
		logoImageView.image = UIImage(named: "logo")
		setupSearchBar()
		
		[logoImageView, searchBar, buttonSort].forEach {
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
		let doneButton = UIBarButtonItem(
			title: "Done",
			style: .done,
			target: self,
			action: #selector(doneButtonTapped)
		)
		doneButton.tintColor = .black
		let flexibleSpace = UIBarButtonItem(
			barButtonSystemItem: .flexibleSpace,
			target: nil,
			action: nil
		)
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
			EpisodeCellView.self, forCellWithReuseIdentifier: EpisodeCellView.cellIdentifier
		)
		self.view.addSubview(collectionView)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		if searchBar.isFirstResponder {
			return
		}
		
		guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
		viewModel?.createCharcterVC(episode: item)
	}
}

// MARK: - Setup DDS

extension EpisodesViewController {
	
	private func configureDataSourse(collectionView: UICollectionView) {
		dataSource = UICollectionViewDiffableDataSource<Section, Episode>(collectionView: collectionView) { 
			(collectionView, indexPath, item) -> UICollectionViewCell? in
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: EpisodeCellView.cellIdentifier,
				for: indexPath
			) as? EpisodeCellView else { return UICollectionViewCell() }
			guard let viewModel = self.viewModel else { return cell }
			
			let modelCell = viewModel.createViewModelCell(episode: item)
			cell.configurator(with: modelCell, inFavourite: false)
			cell.onFavouriteToggle = { [weak self] in
				self?.viewModel?.isFavouriteToggle(for: item)
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


// MARK: - Setup Frame

private extension EpisodesViewController {
	
	func setupFrame() {
		
		let intend: CGFloat = 10
		
		let logoHeight: CGFloat = 100
		let logoTop = view.safeAreaInsets.top
		let logoLeading: CGFloat = 30
		let logoTrailing: CGFloat = 30
		
		let logoWidth = view.frame.width - logoLeading - logoTrailing
		
		logoImageView.frame = CGRect(
			x: logoLeading,
			y: logoTop,
			width: logoWidth,
			height: logoHeight
		)
		
		let searchBarTop = logoImageView.frame.maxY + intend
		let searchBarLeading: CGFloat = intend
		let searchBarTrailing: CGFloat = intend
		
		let searchBarWidth = view.frame.width - searchBarLeading - searchBarTrailing
		
		searchBar.frame = CGRect(
			x: searchBarLeading,
			y: searchBarTop,
			width: searchBarWidth,
			height: searchBar.intrinsicContentSize.height
		)
		
		let buttonSortHeight: CGFloat = 60
		let buttonSortTop = searchBar.frame.maxY + intend
		let buttonSortLeading: CGFloat = 20
		let buttonSortTrailing: CGFloat = 20
		
		let buttonSortWidth = view.frame.width - buttonSortLeading - buttonSortTrailing
		
		buttonSort.frame = CGRect(
			x: buttonSortLeading,
			y: buttonSortTop,
			width: buttonSortWidth,
			height: buttonSortHeight
		)
		
		let collectionViewTop = buttonSort.frame.maxY + intend
		let collectionViewBottom = view.safeAreaInsets.bottom
		let collectionViewLeading = view.safeAreaInsets.left
		let collectionViewTrailing = view.safeAreaInsets.right
		
		let collectionViewHeight = view.frame.height - collectionViewTop - collectionViewBottom
		let collectionViewWidth = view.frame.width - collectionViewLeading - collectionViewTrailing
		
		collectionView.frame = CGRect(
			x: collectionViewLeading,
			y: collectionViewTop,
			width: collectionViewWidth,
			height: collectionViewHeight
		)
	}
}
