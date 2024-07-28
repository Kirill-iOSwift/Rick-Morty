//
//  FavouriteEpisodeViewController.swift
//  Rick&Morty

import UIKit
import SwiftUI

class FavouriteEpisodeViewController: UIViewController {
	
	var items: [Item] = [
		Item(episode: "sdfsdfsdf", imageName: nil, name: "sdfsdfsd"),
		Item(episode: "sdfsdfsdf", imageName: nil, name: "sdfsdfsd"),
		Item(episode: "sdfsdfsdf", imageName: nil, name: "sdfsdfsd"),
		Item(episode: "sdfsdfsdf", imageName: nil, name: "sdfsdfsd")
	]
	
	let titleView = UIView()
	
	var collectionView: UICollectionView!
	var dataSource: UICollectionViewDiffableDataSource<Int, Item>!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemGray5
		
		setupTitle()
		setupCollectionView()
		setupDataSource()
		fetchData()
	}
	
	private func setupTitle() {
		let titleLabel = UILabel()
		titleLabel.text = "Favourites Episodes"
		titleLabel.textColor = .black
		titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
		titleLabel.sizeToFit()
		
		//let titleView = UIView()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleView.translatesAutoresizingMaskIntoConstraints = false
		
		titleView.addSubview(titleLabel)
		self.view.addSubview(titleView)
		//titleView.backgroundColor = #colorLiteral(red: 0.9044648409, green: 0.9204814434, blue: 0.9278460145, alpha: 1)
		
		self.navigationItem.titleView = titleView
		NSLayoutConstraint.activate([
			titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
			titleView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
			titleView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
			titleView.heightAnchor.constraint(equalToConstant: 60),
			
			titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
			titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
			
			 // Ограничение ширины
		])
		
		// Установка кастомного заголовка в навигационную панель
	}
}

extension FavouriteEpisodeViewController {
	
	func createLayout() -> UICollectionViewLayout {
		
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
	
	func setupCollectionView() {
		
		let layout = createLayout()
		
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
		collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .systemGray6
		
		view.addSubview(collectionView)
		
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor),
			collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
			collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
		])
	}
	
	func setupDataSource() {
		dataSource = UICollectionViewDiffableDataSource<Int, Item>(
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
	
	func fetchData() {
		// Получение данных с сервера и обновление коллекции
		// Пример:
		// self.items = fetchedItems
		
		
		
		var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
		snapshot.appendSections([0])
		snapshot.appendItems(items)
		dataSource?.apply(snapshot, animatingDifferences: true)
	}
}


// MARK: - Preview
struct FavouriteEpisodeViewPreviews: PreviewProvider {
	struct ViewControllerContainer: UIViewControllerRepresentable {
		func makeUIViewController(context: Context) -> some UIViewController {
			UINavigationController(rootViewController: FavouriteEpisodeViewController())
		}
		func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
	}
	static var previews: some View {
		ViewControllerContainer().edgesIgnoringSafeArea(.all)
	}
}
