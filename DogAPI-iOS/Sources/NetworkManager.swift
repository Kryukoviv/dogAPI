//
//  NetworkProvider.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 16.03.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

final class NetworkManager: NSObject, URLSessionTaskDelegate {
	
	enum Error: Swift.Error {
		case noData
		case networkError(Swift.Error)
		case unknown
	}

	static let shared: NetworkManager = {
		let queue = OperationQueue()
		let configuration = URLSessionConfiguration.default
		configuration.urlCache = URLCache(memoryCapacity: 1 * 1024 * 1024, diskCapacity: 10 * 1024 * 1024, diskPath: "cache/images")
		configuration.timeoutIntervalForRequest = 10
		configuration.timeoutIntervalForResource = 60
		configuration.waitsForConnectivity = true
		let delegate = URLSessionDelegate()
		let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: queue)
		let networkManager = NetworkManager(session: session, configuration: configuration, delegate: delegate)
		return networkManager
	}()
	
	private init(
		session: URLSession,
		configuration: URLSessionConfiguration,
		delegate: URLSessionDelegate
	) {
		self.session = session
		self.configuration = configuration
		self.delegate = delegate
	}
	
	private let session: URLSession
	private let configuration: URLSessionConfiguration
	private let delegate: URLSessionDelegate

	private var dataTask: [URLSessionDataTask] = []
}

extension NetworkManager {
	func breedAllList(completion: @escaping (Result<[Dog], Error>) -> ()) {
		let url = DogAPI.breedsListAllURL
		let breedListAllDataTask = session.dataTask(with: url, completionHandler: { data, _, error in
			if let error = error {
				completion(.failure(.networkError(error)))
				return
			}
			
			guard let data = data else {
				completion(.failure(.noData))
				return
			}
			let dogs = self.didReceive(data: data)
			completion(.success(dogs))
		})
		breedListAllDataTask.taskDescription = DogAPI.breedsListAllTaskDescription
		dataTask.append(breedListAllDataTask)
		breedListAllDataTask.resume()
	}
	
	func downloadPictureURL(breedInURL: String, completion: @escaping (Result<DogsImageNetworkDTO, Error>) -> ()) {
		guard let url = DogAPI.breedImagesURL(breedInURL: breedInURL) else {
			completion(.failure(.unknown))
			return
		}

		let pictureURLDataTask = session.dataTask(with: url, completionHandler: { data, _, error in
			if let error = error {
				completion(.failure(.networkError(error)))
				return
			}

			guard let data = data else {
				completion(.failure(.noData))
				return
			}

			do {
				let dogsImageDTO = try JSONDecoder().decode(DogsImageNetworkDTO.self, from: data)
				completion(.success(dogsImageDTO))
			} catch {
				completion(.failure(.networkError(error)))
			}
		})
		pictureURLDataTask.taskDescription = DogAPI.downloadDogImagesURLTaskDescription
		dataTask.append(pictureURLDataTask)
		pictureURLDataTask.resume()
	}
	
	func downloadPicture(url: URL, completion: @escaping (Result<Data, Error>) -> ()) {
		let pictureDownloadDataTask = session.dataTask(with: url, completionHandler: { data, _, error in
			if let error = error {
				completion(.failure(.networkError(error)))
				return
			}

			if let data = data {
				completion(.success(data))
			} else {
				completion(.failure(.unknown))
			}
		})
		pictureDownloadDataTask.taskDescription = DogAPI.downloadImageTaskDescription
		dataTask.append(pictureDownloadDataTask)
		pictureDownloadDataTask.resume()
	}
	
	func cleanRequests() {
		for task in dataTask {
			task.cancel()
		}
		dataTask.removeAll()
	}
}

private extension NetworkManager {
	func didReceive(data: Data) -> [Dog] {
		var dogs = [Dog]()
		do {
			let dogsDTO = try JSONDecoder().decode(DogsNetworkDTO.self, from: data)
			for (breed, subbreeds) in dogsDTO.message {
				let dog = Dog(breed: breed, subbreeds: subbreeds)
				dogs.append(dog)
			}
			dogs.sort(by: <)
		} catch {
			assertionFailure(error.localizedDescription)
		}
		return dogs
	}
}
