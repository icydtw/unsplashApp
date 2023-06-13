//
//  ImageCollectionCell.swift
//  unsplashApp
//
//  Created by Илья Тимченко on 12.06.2023.
//

import UIKit

typealias LikeHandler = () -> Void
typealias DisLikeHandler = () -> Void

final class ImageCollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var isLiked: Bool = false
    
    var likeHandler: LikeHandler?
    
    var dislikeHandler: DisLikeHandler?

    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "plug")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "heart.fill")
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.addSubview(image)
        contentView.addSubview(likeButton)
        contentView.layer.cornerRadius = 16
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            likeButton.heightAnchor.constraint(equalToConstant: 35),
            likeButton.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    @objc
    private func likeTapped() {
        if isLiked == false {
            isLiked = true
            likeHandler?()
        } else {
            isLiked = false
            dislikeHandler?()
        }
    }
    
}
