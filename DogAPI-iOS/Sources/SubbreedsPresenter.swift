//
//  SubbreedsPresenter.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 01.03.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

final class SubbreedsPresenter {
	private let coordinator: BreedsCoordinator
	weak var view: SubbreedsViewController?
	var dog: Dog
	
	init(
		dog: Dog,
		coordinator: BreedsCoordinator
	) {
		self.dog = dog
		self.coordinator = coordinator
	}
	
	func viewDidLoad() {
		view?.set(title: "\(dog.breed.capitalized)'s sub-breeds")
	}
}

extension SubbreedsPresenter {
	func didTapCell(at indexPath: IndexPath) {
		coordinator.didTapCellForSubbreedsScreen(for: dog.breed, selectedSubbreed: dog.subbreeds[indexPath.row])
	}
	
}
