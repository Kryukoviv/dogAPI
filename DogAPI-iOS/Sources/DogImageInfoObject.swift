//
//  DogImageInfoObject.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 08.04.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import RealmSwift

final class DogImageInfoObject: Object {

	@objc dynamic private(set) var link: String = ""
	@objc dynamic private(set) var breed: String = ""
	@objc dynamic private(set) var subbreed: String?

	override static func primaryKey() -> String? {
		return "link"
	}
}

extension DogImageInfoObject {

	convenience init(
		link: String,
		breed: String,
		subbreed: String?
	) {
		self.init()
		self.link = link
		self.breed = breed
		self.subbreed = subbreed
	}
}
