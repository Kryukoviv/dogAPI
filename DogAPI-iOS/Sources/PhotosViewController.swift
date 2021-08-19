//
//  PhotosViewController.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 01.03.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

final class PhotosViewController: UIViewController {

	private let presenter: PhotosPresenter
	private lazy var collectionView: UICollectionView = {
		let collectionViewFlowLayout = UICollectionViewFlowLayout()

		return UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
	}()
	
	init(presenter: PhotosPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		view.addSubview(collectionView)

		collectionView.dataSource = self
		collectionView.delegate = self

		collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
		collectionView.backgroundColor = .white
		collectionView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		presenter.viewDidLoad()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		presenter.viewDidDisappear()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.largeTitleDisplayMode = .always
	}
}

extension PhotosViewController: UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		1
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: ImageCell.reuseIdentifier,
			for: indexPath
		) as? ImageCell else {
			assertionFailure("?")
			return UICollectionViewCell()
		}

		return cell
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		presenter.cellsCount
	}
}

extension PhotosViewController: UICollectionViewDelegate {

	func collectionView(
		_ collectionView: UICollectionView,
		willDisplay cell: UICollectionViewCell,
		forItemAt indexPath: IndexPath
	) {
		guard let imageCell = cell as? ImageCell else {
			assertionFailure("?")
			return
		}

		presenter.getImageData(indexPath: indexPath, cell: imageCell)
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: UIView.areAnimationsEnabled)

		guard let imageCell = collectionView.cellForItem(at: indexPath) as? ImageCell else {
			assertionFailure("?")
			return
		}

		guard let image = imageCell.image else {
			return
		}

		presenter.didTapItem(image: image, indexPath: indexPath)
	}
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {

	private static let minimumLineSpacing: CGFloat = 8.0

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		let columns: CGFloat = 4
		let totalHorizontalSpasing = (columns - 1) * Self.minimumLineSpacing

		let itemWidth = (collectionView.bounds.width - totalHorizontalSpasing) / columns
		let itemSize = CGSize(width: itemWidth, height: itemWidth)

		return itemSize
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumLineSpacingForSectionAt section: Int
	) -> CGFloat {
		Self.minimumLineSpacing
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		UIEdgeInsets(
			top: Self.minimumLineSpacing,
			left: Self.minimumLineSpacing,
			bottom: Self.minimumLineSpacing,
			right: Self.minimumLineSpacing
		)
	}
}

extension PhotosViewController {

	func reloadData() {
		collectionView.reloadData()
	}

	func set(title: String) {
		self.title = title
	}

	func showAlert(message: String) {
		let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		present(alert, animated: UIView.areAnimationsEnabled)
	}
}
