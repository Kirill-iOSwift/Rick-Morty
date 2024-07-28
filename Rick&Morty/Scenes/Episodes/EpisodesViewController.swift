//
//  EpisodesViewController.swift
//  Rick&Morty


import UIKit
import SwiftUI
import Combine


final class EpisodesViewController: UIViewController {
	
	enum Section {
		case main
	}
	
	var collectionView: UICollectionView!
	var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
	
	//var items: [Item] = []
	
	let searchBar = UISearchBar()
	let logoImageView = UIImageView()
	
	weak var viewModel: EpisodesViewModelProtocol?
	
	init(viewModel: EpisodesViewModelProtocol) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private let buttonSort = UIButton(type: .system)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setLogotype()
		setSearchBar()
		setButtunSort()
		setupCollectionView()
		setupDataSource()
		
		viewModel?.downLoad { [weak self] result in
			self?.fetchData(items: result)
		}
		
		//fetchEpisodes()
	}
	
//	private func fetchEpisodes() {
//		NetworkManager.shared.fetchEpisodes { [weak self] result in
//			switch result {
//				case .success(let episodes):
//					self?.items = episodes
//					self?.fetchData()
//				case .failure(let error):
//					print("Error fetching episodes: \(error)")
//			}
//		}
//	}
	
	private func setButtunSort() {
		
		buttonSort.setTitle("Advanced filters", for: .normal)
		buttonSort.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
		buttonSort.titleLabel?.font = .systemFont(ofSize: 20)
		buttonSort.tintColor = .blue
		buttonSort.layer.cornerRadius = 5
		buttonSort.layer.shadowColor = UIColor.black.cgColor
		buttonSort.layer.shadowRadius = 4
		buttonSort.layer.shadowOpacity = 2
		buttonSort.layer.shadowOffset = CGSize(width: 0, height: 4)
		buttonSort.translatesAutoresizingMaskIntoConstraints = false
		
		buttonSort.addTarget(self, action: #selector(tap), for: .touchUpInside)
		
		view.addSubview(buttonSort)
		
		NSLayoutConstraint.activate([
			buttonSort.heightAnchor.constraint(equalToConstant: 60),
			buttonSort.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
			buttonSort.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			buttonSort.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
			
		])
	}
	
	@objc private func tap() {
		
	}
	
	private func setLogotype() {
		view.addSubview(logoImageView)
		logoImageView.translatesAutoresizingMaskIntoConstraints = false
		logoImageView.image = UIImage(named: "logo")
		
		NSLayoutConstraint.activate([
			
			logoImageView.heightAnchor.constraint(equalToConstant: 100),
			logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
		])
	}
	
	private func setSearchBar() {
		searchBar.placeholder = "Search items"
		searchBar.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(searchBar)
		
		NSLayoutConstraint.activate([
			searchBar.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
			searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
		])
	}
}

// MARK: - CollectionView Setup

extension EpisodesViewController {
	
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
	
	func setupCollectionView() {
		
		let layout = createLayout()
		
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
		collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
		collectionView.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(collectionView)
		
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: buttonSort.bottomAnchor, constant: 10),
			collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
			collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
		])
	}
	
	func setupDataSource() {
		dataSource = UICollectionViewDiffableDataSource<Section, Item>(
			collectionView: collectionView
		) { (collectionView, indexPath, item) -> UICollectionViewCell? in
			
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: ItemCell.reuseIdentifier,
				for: indexPath
			) as? ItemCell else { return UICollectionViewCell() }
			cell.configure(with: item)
			
//			cell.addToFavoritesAction = {
//				FavoritesManager.shared.add(item: item)
//			}
			return cell
		}
	}
	
	func fetchData(items: [Item]) {
		// Получение данных с сервера и обновление коллекции
		// Пример:
		// self.items = fetchedItems
		
	
		
		var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
		snapshot.appendSections([.main])
		snapshot.appendItems(items)
		dataSource.apply(snapshot, animatingDifferences: true)
	}
}

// MARK: - Preview
//
//struct ContentViewPreviews: PreviewProvider {
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
