//
//  PersonsCollectionViewCell.swift
//  VirusSpreadSim
//
//  Created by Aleksandr Ataev on 07.05.2023.
//

import UIKit

final class PersonsCollectionViewCell: UICollectionViewCell {

    static let reuseId = "PersonsCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Clousers
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.crop.circle")
        image.tintColor = .systemGreen
        image.layer.cornerRadius = frame.width / 2
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    //MARK: - Methods
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setCell(_ item: Bool) {
        if !item  {
            imageView.image = UIImage(systemName: "person.crop.circle")
            imageView.tintColor = .systemGreen
        } else {
            imageView.image = UIImage(systemName: "person.crop.circle")
            imageView.tintColor = .systemRed
        }
    }
}

