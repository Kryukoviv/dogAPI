//
//  PicturesStorage.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 08.04.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import Foundation
import RealmSwift

final class StorageManager {
	func saveBreedsList(dogs: [Dog]) {
		let realm: Realm
		do {
			realm = try Realm()
		} catch {
			assertionFailure(error.localizedDescription)
			return
		}

		let realmObjects = dogs.map { DogObject(dto: $0) }

		do {
			try realm.write {
				realm.add(realmObjects, update: .modified)
			}
		} catch {
			assertionFailure(error.localizedDescription)
			return
		}
	}
	
	func loadBreedList() -> [Dog] {
		let realm: Realm
		do {
			realm = try Realm()
		} catch {
			assertionFailure(error.localizedDescription)
			return []
		}

		return realm
			.objects(DogObject.self)
			.map { $0.dog }
	}

	func imageURLsFor(breed: String, subbreed: String?) -> [URL] {
		let realm: Realm
		do {
			realm = try Realm()
		} catch {
			assertionFailure(error.localizedDescription)
			return []
		}

		return realm
			.objects(DogImageInfoObject.self)
			.filter { $0.breed == breed && $0.subbreed == subbreed }
			.compactMap { URL(string: $0.link) }
	}

	func save(imageURLs: [URL], breed: String, subbreed: String?) {
		let realm: Realm
		do {
			realm = try Realm()
		} catch {
			assertionFailure(error.localizedDescription)
			return
		}

		let realmObjects = imageURLs.map {
			DogImageInfoObject(
				link: $0.absoluteString,
				breed: breed,
				subbreed: subbreed
			)
		}

		do {
			try realm.write {
				realm.add(realmObjects, update: .modified)
			}
		} catch {
			assertionFailure(error.localizedDescription)
			return
		}
	}
	
	func saveImage(image: UIImage, downloadURL: String) {
		FileManagerFacade.save(image: image, downloadURL: downloadURL)
	}
	
	func loadImage(downloadURL: String) -> UIImage? {
		FileManagerFacade.getSavedImage(for: downloadURL)
	}
	
}
