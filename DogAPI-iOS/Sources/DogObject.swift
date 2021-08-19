//
//  DogObject.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 08.04.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import RealmSwift

final class DogObject: Object {
	
	@objc dynamic private(set) var breed: String = ""

	let subbreeds = List<String>()
	
	override static func primaryKey() -> String? {
		"breed"
	}
}

extension DogObject {

	convenience init(dto: Dog) {
		self.init()
		self.breed = dto.breed
		self.subbreeds.append(objectsIn: dto.subbreeds)
	}

	var dog: Dog {
		Dog(breed: breed, subbreeds: subbreeds.map { $0 })
	}
}
