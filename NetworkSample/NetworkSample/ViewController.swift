//
//  ViewController.swift
//  NetworkSample
//
//  Created by Caio Vinicius Pinho Vasconcelos on 21/05/23.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .grouped)
        return tableView
    }()

    var page: Int = 1
    @MainActor var dataSource: [RickMortyCharacterList.Result] = []

    let rickMortyRepository: RickMortysRepositoryProtocol = RickMortyRepository()

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getData()
    }

    // MARK: - Private Methods

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func getData() {
        Task(priority: .background) { [weak self] in
            let result = await self?.rickMortyRepository.getCharactersList(page: self?.page ?? 1)
            switch result {
            case .success(let success):
                await MainActor.run {
                    self?.dataSource = success.results
                    self?.tableView.reloadData()
                }
            case .failure(let failure):
                print(failure.customMessage)
            case .none:
                break
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {

}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier) as? CustomCell else {
            return UITableViewCell()
        }

        let source = dataSource[indexPath.row]
        cell.setup(icon: source.image,
                   name: source.name,
                   species: source.species.rawValue)

        return cell
    }
}
