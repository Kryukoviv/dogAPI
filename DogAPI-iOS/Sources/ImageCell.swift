//
//  ImageCell.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 23.03.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

final class ImageCell: UICollectionViewCell {

	private let activityIndicator: UIActivityIndicatorView
	private let imageView: UIImageView
	private var originalImage: UIImage?
	
	override init(frame: CGRect) {
		imageView = UIImageView()
		activityIndicator = UIActivityIndicatorView(style: .medium)
		super.init(frame: frame)
		
		setupView()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.imageView.image = nil
	}
}

extension ImageCell {

	static let reuseIdentifier = String(reflecting: ImageCell.self)

	var image: UIImage? {
		get {
			originalImage
		}
		set {
			originalImage = newValue

			if newValue == nil {
				activityIndicator.startAnimating()
			} else {
				activityIndicator.stopAnimating()
			}

			guard let newImage = self.originalImage else {
				return
			}

			let imageViewSize = self.imageView.frame.size
			let newImageSize = newImage.size

			var newResizedImageSize = newImageSize.proportionallySized(baseOn: imageViewSize)
			newResizedImageSize.width = max(imageViewSize.width, newResizedImageSize.width)
			newResizedImageSize.height = max(imageViewSize.height, newResizedImageSize.height)

			let newResizedImage = newImage.redraw(to: newResizedImageSize)

			self.imageView.image = newResizedImage
		}
	}
}

private extension ImageCell {

	func setupView() {
		contentView.backgroundColor = UIColor.black

		for view in [imageView, activityIndicator] {
			contentView.addSubview(view)
			view.translatesAutoresizingMaskIntoConstraints = false
		}

		imageView.contentMode = .scaleAspectFill

		contentView.layer.borderColor = UIColor.black.cgColor
		contentView.layer.borderWidth = 1
		contentView.layer.cornerRadius = 4
		contentView.clipsToBounds = true

		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

			activityIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			activityIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			activityIndicator.topAnchor.constraint(equalTo: contentView.topAnchor),
			activityIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
}

private extension CGSize {

	func proportionallySized(baseOn targetSize: CGSize) -> CGSize {
		var newSize = self

		if height > targetSize.height {
			let newWidth = (width * targetSize.height) / height
			newSize = CGSize(width: newWidth, height: targetSize.height)
		}

		if newSize.width > targetSize.width {
			let newHeight = (height * targetSize.width) / width
			newSize = CGSize(width: targetSize.width, height: newHeight)
		}

		return newSize
	}
}

private extension UIImage {

	func redraw(to newSize: CGSize) -> UIImage {
		return UIGraphicsImageRenderer(size: newSize).image { _ in
			let rect = CGRect(origin: .zero, size: newSize)
			draw(in: rect)
		}
	}
}
