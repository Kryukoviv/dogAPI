//
//  SubbreedViewController.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 26.02.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

final class SubbreedsViewController: UIViewController {
	
	private let presenter: SubbreedsPresenter
	private let reuseIdentifier = String(reflecting: UITableViewCell.self)
	private lazy var subbreedsTableView: UITableView = {
		let subbreedsTableView = UITableView(frame: .zero, style: .plain)
		subbreedsTableView.dataSource = self
		subbreedsTableView.delegate = self
		subbreedsTableView.tableFooterView = UIView()
		return subbreedsTableView
	}()
	
	init(presenter: SubbreedsPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		view.addSubview(subbreedsTableView)
		subbreedsTableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			subbreedsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			subbreedsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			subbreedsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			subbreedsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])

		subbreedsTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
		presenter.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.largeTitleDisplayMode = .never
	}
	
	func set(title: String) {
		self.title = title
	}
}

extension SubbreedsViewController: UITableViewDataSource {

	func tableView(_ subbbreedsTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.dog.subbreeds.count
	}
	
	func tableView(_ subbbreedsTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = subbreedsTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
		cell.textLabel?.text = presenter.dog.subbreeds[indexPath.row]
		cell.accessoryType = .detailButton
		return cell
	}
	
}

extension SubbreedsViewController: UITableViewDelegate {
	func tableView(_ subbbreedsTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.presenter.didTapCell(at: indexPath)
		subbbreedsTableView.deselectRow(at: indexPath, animated: UIView.areAnimationsEnabled)
	}
}
