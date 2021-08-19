//
//  BreedsPresenter.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 16.02.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

final class BreedsPresenter {

	weak var view: BreedsViewController?
	var dogs: [Dog] = []

	init(
		interactor: Interactor,
		coordinator: BreedsCoordinator
	) {
		self.coordinator = coordinator
		self.interactor = interactor
	}

	private let interactor: Interactor
	private let coordinator: BreedsCoordinator
}

extension BreedsPresenter {
	func viewDidLoad() {
		interactor.breedAllList { [weak self] result in
			guard let self = self else {
				return
			}

			switch result {
			case .success(let dogs):
				self.dogs = dogs.sorted()
				DispatchQueue.main.async {
					self.view?.showData()
				}
				
			case .failure(let error):
				self.view?.showAlert(message: error.localizedDescription)
			}
		}
	}

	func didTapCell(at indexPath: IndexPath) {
		coordinator.didTapCellForBreedsScreen(for: dogs[indexPath.row])
	}
}


