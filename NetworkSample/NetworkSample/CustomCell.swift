//
//  CustomCell.swift
//  NetworkSample
//
//  Created by Caio Vinicius Pinho Vasconcelos on 22/05/23.
//

import UIKit
import Kingfisher

final class CustomCell: UITableViewCell {

    // MARK: - Properties

    static var identifier: String {
        String(describing: self)
    }

    lazy var icon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()

    lazy var name: UILabel = UILabel()
    lazy var species: UILabel = UILabel()

    // MARK: - Override

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }

    // MARK: - Methods

    func setup(icon: String, name: String, species: String) {
        self.icon.kf.setImage(with: URL(string: icon))
        self.name.text = name
        self.species.text = species
    }

    // MARK: - Private Methods

    private func commonSetup() {
        selectionStyle = .none
        setupViewHierarchy()
        setupConstraints()
    }

    private func setupViewHierarchy() {
        contentView.addSubview(icon)
        contentView.addSubview(name)
        contentView.addSubview(species)
    }

    private func setupConstraints() {
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 32),
            icon.heightAnchor.constraint(equalToConstant: 32)
        ])

        name.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            name.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 16),
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            name.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])

        species.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            species.leftAnchor.constraint(equalTo: name.leftAnchor),
            species.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            species.rightAnchor.constraint(equalTo: name.rightAnchor),
            species.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
