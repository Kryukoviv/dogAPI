//
//  Provider.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 08.04.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import Realm
import Foundation

final class Interactor {
	private let networkManager: NetworkManager
	private let storage: StorageManager
	private let favouritesStorage: FavouriteStorage
	
	init(
		networkManager: NetworkManager,
		storage: StorageManager,
		favouritesStorage: FavouriteStorage
	){
		self.networkManager = networkManager
		self.storage = storage
		self.favouritesStorage = favouritesStorage
	}
	
	func breedAllList(
		completion: @escaping (Result<[Dog], Error>) -> Void
	) {
		let dogsFromStorage = storage.loadBreedList()
		if dogsFromStorage.isNotEmpty {
			completion(.success(dogsFromStorage))
		} else {
			networkManager.breedAllList(completion: { result in
				switch result {
				case .success(let dogs):
					self.storage.saveBreedsList(dogs: dogs)
					completion(.success(dogs))

				case .failure(let error):
					assertionFailure(error.localizedDescription)
					completion(.failure(error))
				}
			})
		}
	}
	
	func imageURLsFor(
		breed: String,
		subbreed: String?,
		completion: @escaping (Result<[URL], Error>) -> Void
	) {
		let dogImageURLs = storage.imageURLsFor(breed: breed, subbreed: subbreed)
		if dogImageURLs.isNotEmpty {
			completion(.success(dogImageURLs))
		} else {
			let breedInURL: String
			if let subbreed = subbreed, subbreed.isNotEmpty {
				breedInURL = "\(breed)/\(subbreed)"
			} else {
				breedInURL = breed
			}

			networkManager.downloadPictureURL(breedInURL: breedInURL, completion: { [weak self] result in
				switch result {
				case .success(let networkDTO):
					let dogImageURLs = networkDTO.message.compactMap { URL(string: $0) }
					self?.storage.save(imageURLs: dogImageURLs, breed: breed, subbreed: subbreed)
					completion(.success(dogImageURLs))

				case .failure(let error):
					assertionFailure(error.localizedDescription)
					completion(.failure(error))
				}
			})
		}
	}
	
	func downloadPicture(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
		if let image = storage.loadImage(downloadURL: url.absoluteString) {
			completion(.success(image))
		} else {
			networkManager.downloadPicture(url: url, completion: { result in
				switch result {
				case .success(let data):
					guard let image = UIImage(data: data) else {
						assertionFailure("?")
						completion(.failure(NSError(domain: "", code: 123, userInfo: nil)))
						return
					}

					self.storage.saveImage(image: image, downloadURL: url.absoluteString)
					completion(.success(image))

				case .failure(let error):
					assertionFailure(error.localizedDescription)
					completion(.failure(error))
				}
			})
		}
	}
	
	func loadFavourites() -> [String] {
		favouritesStorage.favourites ?? []
	}
	
	func saveFavourites(_ favourites: [String]) {
		favouritesStorage.favourites = favourites
	}
		
	func cleanRequests() {
		networkManager.cleanRequests()
	}
}

protocol FavouriteStorage: AnyObject {
	var favourites: [String]? { get set }
}

extension UserDefaults: FavouriteStorage {
	static let favouritesKey = "favourites"
	
	var favourites: [String]? {
		get {
			array(forKey: Self.favouritesKey) as? [String]
		}
		set {
			setValue(newValue, forKey: Self.favouritesKey)
		}
	}
}
