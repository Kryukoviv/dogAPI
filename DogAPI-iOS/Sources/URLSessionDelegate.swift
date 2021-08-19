//
//  URLSessionDelegate.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 18.03.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import Foundation

final class URLSessionDelegate : NSObject, URLSessionTaskDelegate {
	
	func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
		let taskDescription: String
		switch task.taskDescription {
		case DogAPI.breedsListAllTaskDescription:
			taskDescription = "Получение списка всех пород собак"
		case DogAPI.breedImagesTaskDescription:
			taskDescription = "Получение ссылок на все изображения для породы"
		case DogAPI.subBreedImagesTaskDescription:
			taskDescription = "Получение ссылок на все изображения для подпороды"
		case DogAPI.downloadImageTaskDescription:
			taskDescription = "Загрузка картинки"
		case DogAPI.downloadDogImagesURLTaskDescription:
			taskDescription = "Получение ссылки на все изображения для выбранной породы собаки"
		default:
			taskDescription = "Неизвестный session task"
		}
		
		print("Задача \"\(taskDescription)\" заняла:")
		
		let taskDuration = metrics.taskInterval.duration
		let taskDurationString: String
		if taskDuration >= 1 {
			taskDurationString = "\(taskDuration) секунд"
		} else {
			taskDurationString = "\(taskDuration * 1000) миллисекунд"
		}
		print("\(t(1))\(taskDurationString) (metrics.taskInterval.duration)")
		
		let responseTimes: [TimeInterval] = metrics.transactionMetrics.compactMap {
			guard let startDate = $0.fetchStartDate,
				  let endDate = $0.responseEndDate
			else { return nil }
			
			print("")
			let resourceFetchTypeString = "(resourceFetchType: \($0.resourceFetchType.debugDescription))"
			print("\(t(1))Запрос \($0.request.url!) \(resourceFetchTypeString) занял:")
			
			let responseTimeInSeconds = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
			let timeString: String
			if responseTimeInSeconds >= 1 {
				timeString = "\(responseTimeInSeconds) секунд"
			} else {
				timeString = "\(responseTimeInSeconds * 1000) миллисекунд"
			}
			print("\(t(2))\(timeString) (от fetchStartDate до responseEndDate)")
			
			return responseTimeInSeconds
		}
		
		print("")
		print("\(t(1))Все вопросы заняли:")
		let responseTimesSumInSeconds = responseTimes.sum
		let responseTimesString: String
		if responseTimesSumInSeconds >= 1 {
			responseTimesString = "\(responseTimesSumInSeconds) секунд"
		} else {
			responseTimesString = "\(responseTimesSumInSeconds * 1000) миллисекунд"
		}
		print("\(t(2))\(responseTimesString) (от fetchStartDate до responseEndDate)")
		
		print("\n")
	}
}

private func t(_ n: UInt) -> String {
	return String(Array(repeating: "\t", count: Int(n)))
}

extension URLSessionTaskMetrics.ResourceFetchType: CustomDebugStringConvertible {
	
	public var debugDescription: String {
		switch self {
		case .unknown:
			return "Unknown"
		case .networkLoad:
			return "Network load"
		case .serverPush:
			return "Server push"
		case .localCache:
			return "Local cache"
		@unknown default:
			return "Unkwnon default"
		}
	}
}

private extension Array where Element == TimeInterval {
	
	var sum: TimeInterval {
		return reduce(0, +)
	}
}
