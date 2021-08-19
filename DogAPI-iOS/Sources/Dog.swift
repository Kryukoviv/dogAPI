//
//  Dog.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 24.02.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//


struct Dog: Comparable {
	static func < (lhs: Dog, rhs: Dog) -> Bool {
		lhs.breed < rhs.breed
	}
	
	let breed: String
	
	let subbreeds: [String]
}
