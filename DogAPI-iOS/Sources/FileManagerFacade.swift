//
//  FileManagerFacade.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 04.03.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

enum FileManagerFacade {}

extension FileManagerFacade {
	
	static func save(image: UIImage, downloadURL: String) {
		guard let imageData = image.pngData() else {
			assertionFailure()
			return
		}
		
		guard let imageURL = URL(string: downloadURL) else {
			assertionFailure()
			return
		}
		
		guard let imageFileURL = getImageFileLocation(for: imageURL) else {
			assertionFailure()
			return
		}
		
		createFileIfNeeded(fileURL: imageFileURL)
		
		do {
			try imageData.write(to: imageFileURL, options: .atomic)
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}
	
	static func getSavedImage(for downloadURL: String) -> UIImage? {
		guard let imageURL = URL(string: downloadURL) else {
			assertionFailure()
			return nil
		}
		guard let imageFileURL = getImageFileLocation(for: imageURL) else {
			assertionFailure()
			return nil
		}
		
		return UIImage(contentsOfFile: imageFileURL.path)
	}
}

private extension FileManagerFacade {
	
	static var fileManager: FileManager {
		return .default
	}

	static var appDirectory: URL? {
		let applicationDirectory: URL
		do {
			applicationDirectory = try fileManager.url(
				for: .applicationSupportDirectory,
				in: .userDomainMask,
				appropriateFor: nil,
				create: true
			)
		} catch {
			assertionFailure(error.localizedDescription)
			return nil
		}
		
		if !fileManager.fileExists(atPath: applicationDirectory.path) {
			assertionFailure()
		}
		
		return applicationDirectory.standardizedFileURL
	}
	
	static func getImageFileLocation(for imageURL: URL) -> URL? {
		guard let appDirectory = appDirectory else {
			assertionFailure()
			return nil
		}
		
		return appDirectory
			.appendingPathComponent(imageURL.path, isDirectory: false)
			.standardizedFileURL
	}
	
	static func createFileIfNeeded(fileURL: URL) {
		if !fileURL.isFileURL {
			assertionFailure()
		}
		
		let filePath = fileURL.path
		
		guard !fileManager.fileExists(atPath: filePath) else { return }
		
		let fileContentFolder = fileURL.deletingLastPathComponent()
		
		if !fileManager.fileExists(atPath: fileContentFolder.path) {
			do {
				try fileManager.createDirectory(
					at: fileContentFolder,
					withIntermediateDirectories: true,
					attributes: nil
				)
			} catch {
				assertionFailure(error.localizedDescription)
			}
		}
		
		let fileCreated = fileManager.createFile(
			atPath: filePath,
			contents: nil,
			attributes: nil
		)
		
		if !fileCreated {
			assertionFailure()
		}
	}
}
