//
//  NSMutableAttributedString+Extensions.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 04.03.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {

	func bold(_ value: String, sizeFont: CGFloat) -> NSMutableAttributedString {
		let attributes:[NSAttributedString.Key : Any] = [
			.font : UIFont.boldSystemFont(ofSize: sizeFont)
		]
		
		append(NSAttributedString(string: value, attributes:attributes))
		return self
	}
	
	func normal(_ value:String, sizeFont: CGFloat) -> NSMutableAttributedString {
		let attributes:[NSAttributedString.Key : Any] = [
			.font : UIFont.systemFont(ofSize: sizeFont),
		]
		
		append(NSAttributedString(string: value, attributes:attributes))
		return self
	}
}
