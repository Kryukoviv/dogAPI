//
//  ImageScreenPresenter.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 30.04.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

class ImageScreenPresenter {
	private let interactor: Interactor
	weak var view: ImageScreenViewController?
	
	init(
		interactor: Interactor
	){
		self.interactor = interactor
	}
	
	
	func didTapFavoritesButton(downloadURL: String) -> [String] {
		let favourites = interactor.loadFavourites()
		var copyFavourites = Set(favourites)
		if favourites.contains(downloadURL) {
			copyFavourites.remove(downloadURL)
		} else {
			copyFavourites.insert(downloadURL)
		}
		let newArray = Array(copyFavourites)
		interactor.saveFavourites(newArray)
		return newArray
	}
	
	func viewWillAppear() -> [String] {
		let favourites = interactor.loadFavourites()
		return favourites
	}
}
