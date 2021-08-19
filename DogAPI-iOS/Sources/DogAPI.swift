//
//  DogAPI.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 04.03.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import Foundation

enum DogAPI {}

extension DogAPI {
	
	static let breedsListAllURL = URL(string: "\(baseURLLink)/breeds/list/all")!
	static let breedsListAllTaskDescription = "breeds list all"
	
	static func breedImagesURL(breedInURL: String) -> URL? {
		guard breedInURL.isNotEmpty else { return nil }
		
		let breedImagesURLLink = "/breed/\(breedInURL)/images"
		
		return URL(string: baseURLLink + breedImagesURLLink)
	}
	static let breedImagesTaskDescription = "breeds images"
	
	static func subBreedImagesURL(breed: String, subbreed: String) -> URL? {
		guard breed.isNotEmpty,
			  subbreed.isNotEmpty
		else { return nil }
		
		let subBreedImagesURLLink = "/breed/\(breed)/\(subbreed)/images"

		return URL(string: baseURLLink + subBreedImagesURLLink)
	}
	static let subBreedImagesTaskDescription = "sub-breeds images"
	
	static let downloadImageTaskDescription = "download image"
	
	static let downloadDogImagesURLTaskDescription = "download dog images"
}

private extension DogAPI {
	
	// https://dog.ceo/dog-api/documentation/
	static let baseURLLink = "https://dog.ceo/api"
}
