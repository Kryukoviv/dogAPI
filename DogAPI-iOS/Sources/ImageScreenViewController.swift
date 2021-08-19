//
//  ImageScreen.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 26.03.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

final class ImageScreenViewController: UIViewController {

	private let image: UIImage
	private let downloadURL: String
	private lazy var imageView = UIImageView()
	private lazy var favoriteButton = UIButton()
	private let presenter: ImageScreenPresenter
	
	init(
		image: UIImage,
		downloadURL: String,
		presenter: ImageScreenPresenter
	) {
		self.image = image
		self.downloadURL = downloadURL
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func didTapFavoritesButton(sender: UIButton!) {
		favoriteButton.isSelected = presenter.didTapFavoritesButton(downloadURL: downloadURL).contains(self.downloadURL)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .black

		view.addSubview(imageView)
		view.addSubview(favoriteButton)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		favoriteButton.translatesAutoresizingMaskIntoConstraints = false

		favoriteButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
		favoriteButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .selected)
		favoriteButton.tintColor = .red
		favoriteButton.addTarget(self, action: #selector(didTapFavoritesButton), for: .touchUpInside)

		imageView.image = image
		imageView.contentMode = .scaleAspectFit

		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			
			favoriteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
			favoriteButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
			favoriteButton.widthAnchor.constraint(equalToConstant: 50),
			favoriteButton.heightAnchor.constraint(equalToConstant: 50)
		])
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	
		favoriteButton.isSelected = presenter.viewWillAppear().contains(self.downloadURL)
	}
}
