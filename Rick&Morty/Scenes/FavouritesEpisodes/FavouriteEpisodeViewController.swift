//
//  FavouriteEpisodeViewController.swift
//  Rick&Morty

import UIKit

final class FavouriteEpisodeViewController: UIViewController {
	
	// MARK: Enum Section
	
	enum Section: Hashable {
		case main
	}
		
	// MARK: Private properties
	
	private let titleView = UIView()
	private let titleLabel = UILabel()
	private var collectionView: UICollectionView!
	private var dataSource: UICollectionViewDiffableDataSource<Section, Episode>!
	
	// MARK: Dependency
	
	 var viewModel: EpisodesViewModelProtocol?
	
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
		view.backgroundColor = .systemGray5
		setupNAvigationTitleView()
		setupCollectionView()
		setupLayout()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		guard let viewModel = viewModel else { return }
		fetchData()
	}
	
	// MARK: - Private Meathods
	
	// MARK: Setup UI
	
	private func setupNAvigationTitleView() {
		
		titleLabel.text = "Favourites Episodes"
		titleLabel.textColor = .black
		titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
		titleLabel.sizeToFit()
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleView.translatesAutoresizingMaskIntoConstraints = false
		
		titleView.addSubview(titleLabel)
		self.view.addSubview(titleView)
		
		self.navigationItem.titleView = titleView
	}
}

// MARK: - Setup VollectionView

extension FavouriteEpisodeViewController {
	
	private func setupCollectionView() {
		addCollectionView(layout: createLayout())
		collectionView.delegate = self
	
		setupDataSource()
		fetchData()
	}
	
	private func createLayout() -> UICollectionViewLayout {
		
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1),
			heightDimension: .fractionalHeight(1)
		)
		
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		
		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1),
			heightDimension: .fractionalHeight(0.5)
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
	
	private func addCollectionView(layout: UICollectionViewLayout) {
		
		let layout = createLayout()
		
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
		collectionView.register(EpisodeCellView.self, forCellWithReuseIdentifier: EpisodeCellView.reuseIdentifier)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .systemGray6
		
		view.addSubview(collectionView)
	}
	
	private func setupDataSource() {
		dataSource = UICollectionViewDiffableDataSource<Section, Episode>(
			collectionView: collectionView
		) { (collectionView, indexPath, item) -> UICollectionViewCell? in
			
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: EpisodeCellView.reuseIdentifier,
				for: indexPath
			) as? EpisodeCellView else { return UICollectionViewCell() }
			cell.configure(with: item, swipe: false)
			cell.onFavouriteToggle = { [weak self] in
				self?.viewModel?.toggleFavorite(for: item)
				self?.fetchData()
			}
			return cell
		}
	}
	
	private func fetchData() {
		guard let viewModel = viewModel else { return }
		let items = viewModel.episodes.filter { $0.isFavourite }
		var snapshot = NSDiffableDataSourceSnapshot<Section, Episode>()
		snapshot.appendSections([.main])
		snapshot.appendItems(items)
		dataSource?.apply(snapshot, animatingDifferences: true)
	}
}

extension FavouriteEpisodeViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
		let charVC = CharacterTableViewController()
		charVC.viewModel = viewModel?.getViewModelCharacter(item: item)
		viewModel?.openCell(viewController: charVC)
	}
}

// MARK: Setup Costraints
 
private extension FavouriteEpisodeViewController {
	func setupLayout() {
		NSLayoutConstraint.activate([
			titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			titleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			titleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			titleView.heightAnchor.constraint(equalToConstant: 60),
			
			titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
			titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
			
			collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
	}
}
