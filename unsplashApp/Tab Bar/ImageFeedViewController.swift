//
//  ImageFeedViewController.swift
//  unsplashApp
//
//  Created by Илья Тимченко on 12.06.2023.
//

import UIKit
import Kingfisher

final class ImageFeedViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: ViewModelProtocol?
    
    var photos: [Photo] = []
    
    let imageCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ImageCollectionCell.self, forCellWithReuseIdentifier: "imageCell")
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        setupView()
        getPhotos()
    }
    
    /// Appearance customisation
    private func setupView() {
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            imageCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            imageCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            imageCollection.topAnchor.constraint(equalTo: view.topAnchor),
            imageCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Properties settings
    private func setupProperties() {
        view.addSubview(imageCollection)
        imageCollection.dataSource = self
        imageCollection.delegate = self
    }
    
    /// Function that fetching photos
    private func getPhotos() {
        viewModel?.getPhotos(completion: { [weak self] result in
            self?.photos.append(contentsOf: result)
            DispatchQueue.main.async {
                self?.imageCollection.reloadData()
            }
        }, onError: { error in
            Alert.shared.displayErrorAlert(message: "Can't download images") { alert in
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        })
    }
    
}

// MARK: - Extension for UICollectionViewDataSource
extension ImageFeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCollectionCell else { return UICollectionViewCell()}
        guard let url = URL(string: photos[indexPath.row].urls?.small ?? "") else { return UICollectionViewCell()}
        cell.image.kf.setImage(with: url, placeholder: UIImage(named: "plug"))
        if indexPath.row == photos.count - 5 {
            getPhotos()
        }
        return cell
    }
    
}

// MARK: - Extension for UICollectionViewDelegate
extension ImageFeedViewController: UICollectionViewDelegate {
    
    
    
}

extension ImageFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.bounds.width / 2)-12, height: (view.bounds.width / 2)-12)
    }
    
    /// Function that returns spacing between lines in collection
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    /// Function that returns spacing between items in section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
}
