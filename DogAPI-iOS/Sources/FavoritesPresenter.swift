//
//  FavoritesPresenter.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 30.04.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

final class FavoritesPresenter {
	weak var view: FavoritesViewController?
	
	private let interactor: Interactor
	private var favorites: [String] = []
	private let coordinator: BreedsCoordinator
	
	init(
		interactor: Interactor,
		coordinator: BreedsCoordinator
	) {
		self.interactor = interactor
		self.coordinator = coordinator
	}
	
	func viewWillAppear() {
		favorites = interactor.loadFavourites()
		view?.reloadData()
	}
	
	func getImageData(indexPath: IndexPath, cell: FavoritePictureCell) {
		guard let url = URL(string: favorites[indexPath.row]) else { return }
		interactor.downloadPicture(url: url) { result in
			switch result {
			case .success(let image):
				DispatchQueue.main.async {
					cell.pictureView.image = image
				}
			case .failure(let error):
				DispatchQueue.main.async {
					self.view?.showAlert(message: error.localizedDescription)
				}
			}
		}
	}
	
	func makeTextFromURL(indexPath: IndexPath, cell: FavoritePictureCell) {
		guard let url = URL(string: favorites[indexPath.row]) else { return }
		var slice = url.pathComponents.dropLast()
		let string = slice.popLast()!
		if string.contains("-") {
			let breedArray = string.split(separator: "-")
			cell.favoritesLabel.text = "\(breedArray[0]) \(breedArray[1])"
		} else {
			cell.favoritesLabel.text = string
		}
	}
	
	func returnFavoritesCount() -> Int {
		return favorites.count
	}
	
	func didTapCell(image: UIImage, indexPath: IndexPath) {
		guard let view = view else {
			assertionFailure("?")
			return
		}

		coordinator.didTapItem(image: image, downloadURL: favorites[indexPath.row], in: view) { [weak self] in
			self?.viewWillAppear()
		}
	}
}
