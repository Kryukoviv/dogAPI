//
//  FavoritesViewController.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 07.02.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

final class FavoritesViewController: UIViewController {
	
	private let reuseIdentifier = String(reflecting: FavoritePictureCell.self)
	private let presenter: FavoritesPresenter
	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.dataSource = self
		tableView.delegate = self
		return tableView
	}()
	
	init(
		presenter: FavoritesPresenter
	){
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .white
		
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.tableFooterView = UIView()
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
		
		tableView.register(FavoritePictureCell.self, forCellReuseIdentifier: reuseIdentifier)
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		presenter.viewWillAppear()
	}
	
	func showAlert(message: String) {
		let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		present(alert, animated: UIView.areAnimationsEnabled)
	}
	
	func reloadData() {
		tableView.reloadData()
	}
}


extension FavoritesViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.returnFavoritesCount()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	
		guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? FavoritePictureCell else {
			assertionFailure("?")
			
			return UITableViewCell()
		}
		presenter.getImageData(indexPath: indexPath, cell: cell)
		presenter.makeTextFromURL(indexPath: indexPath, cell: cell)
		return cell
	}
	
}

extension FavoritesViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: UIView.areAnimationsEnabled)
		guard let image = (tableView.cellForRow(at: indexPath) as? FavoritePictureCell)?.pictureView.image else { return }
		presenter.didTapCell(image: image, indexPath: indexPath)
	}
}

