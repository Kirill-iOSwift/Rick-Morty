//
//  EpisodesViewController.swift
//  Rick&Morty

import UIKit

final class EpisodesViewController: UIViewController {

	// MARK: Private properties
	
	private let searchBar = UISearchBar()
	private let logoImageView = UIImageView()
	private let buttonSort = UIButton(type: .system)
	private var collectionView: UICollectionView!
	
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
		viewModel?.fetchData()
		setupConstraints()
	}
	
	// MARK: - Private Meathods
	
	// MARK: Setup UI
	
	private func setupElements() {
		
		buttonSort.customizeSortdButton()
		logoImageView.image = UIImage(named: "logo")
		setupSearchBar()
		buttonSort.addTarget(self, action: #selector(sortItems), for: .touchUpInside)
		
		[logoImageView, searchBar, buttonSort].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview($0)
		}
	}
	
	@objc func sortItems() {
		//TODO: Сделать сортировку
	}
}

// MARK: - Setup SearchBar

extension EpisodesViewController: UISearchBarDelegate {
	
	func setupSearchBar() {
		searchBar.placeholder = "Search number series"
		searchBar.delegate = self
		searchBar.showsCancelButton = true
		
		if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
			searchTextField.keyboardType = .numberPad
			searchTextField.returnKeyType = .done
			searchTextField.delegate = self
			
		}
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		tapGesture.cancelsTouchesInView = false
		view.addGestureRecognizer(tapGesture)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}

extension EpisodesViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
}

// MARK: - Setup CollectionView

extension EpisodesViewController: UICollectionViewDelegate {
	
	func setupCollectionView() {
		addCollectionView(layout: createLayout())
		collectionView.delegate = self
		viewModel?.collectionDataSourse(collectionView: collectionView)
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
			EpisodeViewCell.self, forCellWithReuseIdentifier: EpisodeViewCell.reuseIdentifier)
		
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(collectionView)
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let charVC = CharacterTableViewController()
		charVC.viewModel = viewModel?.getViewModelCharacter(indexPath: indexPath)
		viewModel?.openCell(viewController: charVC)
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
