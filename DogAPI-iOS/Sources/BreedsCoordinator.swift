//
//  BreedsCoordinator.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 17.02.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

final class BreedsCoordinator: NSObject {

	init(
		navigationController: UINavigationController,
		assembly: BreedsAssembly
	) {
		self.navigationController = navigationController
		self.assembly = assembly
	}

	private let navigationController: UINavigationController
	private let assembly: BreedsAssembly

	private var onDismissImageScreen: (() -> Void)?
}

extension BreedsCoordinator {

	func didTapCellForBreedsScreen(for dog: Dog) {
		if dog.subbreeds.isEmpty {
			showDogPhotosScreen(selectedBreed: dog.breed, selectedSubbreed: nil)
		} else {
			showSubbreedsScreen(dog: dog)
		}
	}
	
	func didTapCellForSubbreedsScreen(for selectedBreed: String, selectedSubbreed: String) {
		showDogPhotosScreen(selectedBreed: selectedBreed, selectedSubbreed: selectedSubbreed)
	}
	
	func didTapItem(
		image: UIImage,
		downloadURL: String,
		in vc: UIViewController,
		onDismissImageScreen: (() -> Void)? = nil
	) {
		self.onDismissImageScreen = onDismissImageScreen
		let imageScreen = assembly.makeImageScreen(image: image, downloadURL: downloadURL)

		imageScreen.presentationController?.delegate = self

		vc.present(imageScreen, animated: UIView.areAnimationsEnabled)
	}
}

extension BreedsCoordinator: UIAdaptivePresentationControllerDelegate {

	func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
		onDismissImageScreen?()
	}
}

private extension BreedsCoordinator {

	func showSubbreedsScreen(dog: Dog) {
		let subbreedsScreen = assembly.makeSubbreedsScreen(dog: dog, coordinator: self)
		subbreedsScreen.hidesBottomBarWhenPushed = true
		navigationController.pushViewController(subbreedsScreen, animated: UIView.areAnimationsEnabled)
	}

	
	func showDogPhotosScreen(selectedBreed: String, selectedSubbreed: String?) {
		let photosScreen = assembly.makePhotosScreen(
			selectedBreed: selectedBreed,
			selectedSubbreed: selectedSubbreed,
			coordinator: self
		)
		photosScreen.hidesBottomBarWhenPushed = true
		navigationController.pushViewController(photosScreen, animated: UIView.areAnimationsEnabled)
	}

}
