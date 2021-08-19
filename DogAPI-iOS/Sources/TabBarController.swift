//
//  TabBarController.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 07.02.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let assembly = BreedsAssembly()
		let breedsNavVC = assembly.makeBreedsNavigationController()
		let presenter = FavoritesPresenter(
			interactor: Interactor(
				networkManager: .shared,
				storage: StorageManager(),
				favouritesStorage: UserDefaults.standard
			),
			coordinator: BreedsCoordinator(navigationController: breedsNavVC, assembly: assembly)
		)
		let favoritesVC = FavoritesViewController(presenter: presenter)
		presenter.view = favoritesVC

		breedsNavVC.tabBarItem = UITabBarItem(title: "Breeds", image: UIImage.init(systemName: "list.bullet") , tag: 0)
		favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage.init(systemName: "suit.heart"), tag: 1)

		viewControllers = [breedsNavVC, favoritesVC]
	}

}

