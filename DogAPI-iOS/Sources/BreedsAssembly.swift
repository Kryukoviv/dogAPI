//
//  BreedsAssembly.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 17.02.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

final class BreedsAssembly {

	func makeBreedsNavigationController() -> UINavigationController {
		let navigationVC = UINavigationController()
		let coordinator = BreedsCoordinator(
			navigationController: navigationVC,
			assembly: self
		)
		let presenter = BreedsPresenter(
			interactor: Interactor(
				networkManager: NetworkManager.shared,
				storage: StorageManager(),
				favouritesStorage: UserDefaults.standard
			),
			coordinator: coordinator
		)
		let vc = BreedsViewController(presenter: presenter)
		navigationVC.viewControllers = [vc]

		presenter.view = vc
		return navigationVC
	}
	
	func makeSubbreedsScreen(dog: Dog, coordinator: BreedsCoordinator) -> UIViewController {
		let presenter = SubbreedsPresenter(dog: dog, coordinator: coordinator)

		let view = SubbreedsViewController(presenter: presenter)
		presenter.view = view

		return view
	}

	func makePhotosScreen(
		selectedBreed: String,
		selectedSubbreed: String?,
		coordinator: BreedsCoordinator
	) -> UIViewController {
		let presenter = PhotosPresenter(
			selectedBreed: selectedBreed,
			selectedSubbreed: selectedSubbreed,
			interactor: Interactor(
				networkManager: NetworkManager.shared,
				storage: StorageManager(),
				favouritesStorage: UserDefaults.standard
			),
			coordinator: coordinator
		)

		let view = PhotosViewController(presenter: presenter)
		presenter.view = view

		return view
	}

	func makeImageScreen(image: UIImage, downloadURL: String) -> UIViewController {
		ImageScreenViewController(image: image, downloadURL: downloadURL, presenter: ImageScreenPresenter(interactor: Interactor(networkManager: .shared, storage: StorageManager(), favouritesStorage: UserDefaults.standard)))
	}
}
