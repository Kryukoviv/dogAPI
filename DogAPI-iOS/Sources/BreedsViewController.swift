//
//  BreedsViewController.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 07.02.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

final class BreedsViewController: UIViewController {

	private let presenter: BreedsPresenter
	private let reuseIdentifier = String(reflecting: UITableViewCell.self)

	private lazy var dogsListTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.dataSource = self
		tableView.delegate = self
		return tableView
	}()
	
	init(presenter: BreedsPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Breeds"
		view.backgroundColor = .white
		navigationController?.navigationBar.prefersLargeTitles = true

		view.addSubview(dogsListTableView)
		dogsListTableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			dogsListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			dogsListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			dogsListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			dogsListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])

		dogsListTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

		presenter.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.largeTitleDisplayMode = .never
	}
	
	func showData() {
		dogsListTableView.reloadData()
	}
	
	func showAlert(message: String) {
		let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		present(alert, animated: UIView.areAnimationsEnabled)
	}
	
}

extension BreedsViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.dogs.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
		let textForBold = presenter.dogs[indexPath.row].breed
		let textForNormal = presenter.dogs[indexPath.row].subbreedsCount ?? ""
		cell.textLabel?.attributedText =
		NSMutableAttributedString()
			.bold(textForBold, sizeFont: 17)
			.normal(textForNormal, sizeFont: 13)
		cell.accessoryType = presenter.dogs[indexPath.row].isInfoButtonHidden ? .disclosureIndicator : .detailButton
		return cell
	}
	
}

private extension Dog {

	var subbreedsCount: String? {
		guard subbreeds.isEmpty == false else { return nil }
		return "(subbreeds: \(subbreeds.count))"
	}
	
	var isInfoButtonHidden: Bool {
		!subbreeds.isEmpty
	}

}

extension BreedsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.didTapCell(at: indexPath)
		tableView.deselectRow(at: indexPath, animated: UIView.areAnimationsEnabled)
	}
}


