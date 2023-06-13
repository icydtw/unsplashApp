//
//  ImagesTableCell.swift
//  unsplashApp
//
//  Created by Илья Тимченко on 13.06.2023.
//

import UIKit

final class ImagesTableCell: UITableViewCell {
    
    // MARK: - Properties
    
    let photoView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let authorName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Functions
    
    /// Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupProperties()
        setupCellViewController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Appearance customisation
    private func setupCellViewController() {
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            photoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 40),
            photoView.widthAnchor.constraint(equalToConstant: 40),
            authorName.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 16),
            authorName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    /// Properties settings
    private func setupProperties() {
        contentView.addSubview(photoView)
        contentView.addSubview(authorName)
    }
    
}
