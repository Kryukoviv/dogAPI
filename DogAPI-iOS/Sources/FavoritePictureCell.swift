//
//  FavoritePictureCell.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 30.04.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

final class FavoritePictureCell: UITableViewCell {
	
	let pictureView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()
	
	let favoritesLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .title2)
		label.textAlignment = .center
		return label
	}()
	
	let favoritesStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.distribution = .fill
		stackView.spacing = 8
		return stackView
	}()
	
	override init(
		style: UITableViewCell.CellStyle,
		reuseIdentifier: String?
	){
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		setupViews()
		makeConstraints()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViews() {
		contentView.addSubview(favoritesStackView)
		for view in [pictureView, favoritesLabel] {
			favoritesStackView.addArrangedSubview(view)
		}
	}
	
	private func makeConstraints() {
		
		favoritesStackView.translatesAutoresizingMaskIntoConstraints = false
		pictureView.translatesAutoresizingMaskIntoConstraints = false
		favoritesLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			favoritesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			favoritesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			favoritesStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
			favoritesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

			pictureView.heightAnchor.constraint(equalToConstant: 150),
		])
		favoritesLabel.setContentCompressionResistancePriority(.required, for: .vertical)
	}
}
