//
//  PhotosPresenter.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 01.03.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

final class PhotosPresenter {
	weak var view: PhotosViewController?

	private var dogsImageURLs: [URL] = []
	
	init(
		selectedBreed: String,
		selectedSubbreed: String?,
		interactor: Interactor,
		coordinator: BreedsCoordinator
	) {
		self.selectedBreed = selectedBreed
		self.selectedSubbreed = selectedSubbreed
		self.interactor = interactor
		self.coordinator = coordinator
	}
	
	private let selectedBreed: String
	private let selectedSubbreed: String?
	private let interactor: Interactor
	private let coordinator: BreedsCoordinator
}

extension PhotosPresenter {

	var cellsCount: Int {
		dogsImageURLs.count
	}
	
	func viewDidLoad() {
		let title: String
		if let selectedSubbreed = selectedSubbreed,
		   selectedSubbreed.isNotEmptyWithoutWhiteSpacesAndNewlines {
			
			title = "\(selectedSubbreed.capitalized) \(selectedBreed)"
		} else {
			title = selectedBreed.capitalized
		}
		view?.set(title: title)
		interactor.imageURLsFor(
			breed: selectedBreed,
			subbreed: selectedSubbreed
		) { [weak self] result in
			guard let self = self else {
				return
			}

			switch result {
			case .success(let urls) :
				self.dogsImageURLs = urls

				DispatchQueue.main.async {
					self.view?.reloadData()
				}
			case .failure(let error):
				DispatchQueue.main.async {
					self.view?.showAlert(message: error.localizedDescription)
				}
			}
		}
	}
	
	func viewDidDisappear() {
		interactor.cleanRequests()
	}
	
	func didTapItem(image: UIImage, indexPath: IndexPath) {
		guard let view = view else {
			assertionFailure("?")
			return
		}

		coordinator.didTapItem(
			image: image,
			downloadURL: dogsImageURLs[indexPath.row].absoluteString,
			in: view
		)
	}
	
	func getImageData(indexPath: IndexPath, cell: ImageCell) {
		interactor.downloadPicture(url: dogsImageURLs[indexPath.row]) { result in
			switch result {
			case .success(let image):
				DispatchQueue.main.async {
					cell.image = image
				}
			case .failure(let error):
				DispatchQueue.main.async {
					self.view?.showAlert(message: error.localizedDescription)
				}
			}
		}
	}
}

private extension String {
	
	var isNotEmptyWithoutWhiteSpacesAndNewlines: Bool {
		return self.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty
	}
}

extension Collection {
	
	var isNotEmpty: Bool {
		return !isEmpty
	}
}
