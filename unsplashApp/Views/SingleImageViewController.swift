//
//  SingleImageViewController.swift
//  unsplashApp
//
//  Created by Илья Тимченко on 13.06.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - Properties
    
    var isLiked = false
    
    var indexOfPhoto: IndexPath?
    
    var photo: Photo?
    
    var viewModel: ViewModelProtocol?
    
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "plug")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .black
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let informationView: UIView = {
        let infoView = UIView()
        infoView.backgroundColor = .white.withAlphaComponent(0.3)
        infoView.layer.cornerRadius = 16
        infoView.translatesAutoresizingMaskIntoConstraints = false
        return infoView
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "backward")
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let authorName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let createdDate: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var downloadCount: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var loadLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Loading..."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            informationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8),
            informationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            informationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            informationView.heightAnchor.constraint(equalToConstant: 91),
            authorName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            authorName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.heightAnchor.constraint(equalToConstant: 20),
            createdDate.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 8),
            createdDate.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: 8),
            locationLabel.topAnchor.constraint(equalTo: createdDate.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: 8),
            downloadCount.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            downloadCount.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: informationView.trailingAnchor, constant: -8),
            likeButton.centerYAnchor.constraint(equalTo: informationView.centerYAnchor),
            loadLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupProperties() {
        loadImage()
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(image)
        view.addSubview(informationView)
        view.addSubview(authorName)
        view.addSubview(backButton)
        view.addSubview(loadLabel)
        informationView.addSubview(createdDate)
        informationView.addSubview(locationLabel)
        informationView.addSubview(downloadCount)
        informationView.addSubview(likeButton)
        if isLiked {
            likeButton.setImage(UIImage(named: "heart.fill.red"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "heart.fill"), for: .normal)
        }
        authorName.text = photo?.user?.name
        createdDate.text = convertDate(dateString: photo?.created_at! ?? "1970-01-01T12:00:00Z")
        locationLabel.text = photo?.user?.location
        informationView.isHidden = true
        getTotalAmountOfDownloads()
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let horizontalScale = visibleRectSize.width / imageSize.width
        let verticalScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(horizontalScale, verticalScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func convertDate(dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMMM yyyy"
            let formattedDate = outputFormatter.string(from: date)
            return formattedDate
        }
        return ""
    }
    
    private func loadImage() {
        let url = URL(string: photo?.urls?.full ?? "")
        image.kf.setImage(with: url) { result in
            self.scrollView.minimumZoomScale = self.view.frame.size.width / (self.image.image?.size.width ?? 0)
            self.scrollView.maximumZoomScale = 3
            self.rescaleAndCenterImageInScrollView(image: self.image.image ?? UIImage())
            self.loadLabel.isHidden = true
            self.informationView.isHidden = false
        }
    }
    
    private func centerImage() {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
    
    private func getTotalAmountOfDownloads() {
        viewModel?.getTotalAmountOfDownloads(photoID: photo?.id ?? "", completion: { downloads in
            DispatchQueue.main.async {
                self.downloadCount.text = "\(downloads) downloads"
            }
        }, onError: { error in
            
        })
    }
    
    @objc
    private func backButtonTapped() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        dismiss(animated: true)
    }
    
    @objc
    private func likeTapped() {
        if let index = indexOfPhoto,
           let photo = photo {
            if isLiked == false {
                isLiked = true
                viewModel?.like(photo: photo, index: index)
                likeButton.setImage(UIImage(named: "heart.fill.red"), for: .normal)
            } else {
                isLiked = false
                viewModel?.dislike(photo: photo, index: index)
                likeButton.setImage(UIImage(named: "heart.fill"), for: .normal)
            }
        }
    }
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { image }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
    
}
