//
//  FavouritesViewController.swift
//  unsplashApp
//
//  Created by Илья Тимченко on 12.06.2023.
//

import UIKit
import Kingfisher

final class FavouritesViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: ViewModelProtocol?
    
    var likedPhoto: [Photo] = []
    
    let imagesTable: UITableView = {
        let table = UITableView()
        table.register(ImagesTableCell.self, forCellReuseIdentifier: "favCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        setupView()
    }
    
    /// Appearance customisation
    private func setupView() {
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            imagesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagesTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imagesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupProperties() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: Notification.Name("liked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: Notification.Name("disliked"), object: nil)
        getLikedPhotos()
        view.addSubview(imagesTable)
        imagesTable.dataSource = self
        imagesTable.delegate = self
    }
    
    private func getLikedPhotos() {
        likedPhoto = viewModel?.getLikedPhoto() ?? []
    }
    
    @objc
    private func updateView() {
        likedPhoto = viewModel?.getLikedPhoto() ?? []
        imagesTable.reloadData()
    }
    
}

extension FavouritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedPhoto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCell") as? ImagesTableCell else {
            return UITableViewCell()
        }
        guard let url = URL(string: likedPhoto[indexPath.row].urls?.small ?? "") else { return UITableViewCell()}
        cell.authorName.text = likedPhoto[indexPath.row].user?.name
        cell.photoView.kf.setImage(with: url)
        return cell
    }
}

extension FavouritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = likedPhoto[indexPath.row]
        let singleImageVC = SingleImageViewController()
        singleImageVC.modalPresentationStyle = .fullScreen
        singleImageVC.photo = photo
        singleImageVC.viewModel = viewModel
        singleImageVC.indexOfPhoto = indexPath
        guard let url = URL(string: likedPhoto[indexPath.row].urls?.small ?? "") else { return }
        if !likedPhoto.filter({$0.urls?.small == url.absoluteString}).isEmpty {
            singleImageVC.isLiked = true
        }
        present(singleImageVC, animated: true)
    }
    
}
