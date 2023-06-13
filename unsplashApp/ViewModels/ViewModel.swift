//
//  ViewModel.swift
//  unsplashApp
//
//  Created by Илья Тимченко on 12.06.2023.
//

import Foundation

typealias Binding<T> = (T) -> Void

// MARK: - Protocol
protocol ViewModelProtocol {
    var isLiked: Binding<IndexPath>? { get set }
    var isDisliked: Binding<IndexPath>? { get set }
    func getPhotos(page: Int, completion: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void)
    func like(photo: Photo, index: IndexPath)
    func dislike(photo: Photo, index: IndexPath)
    func getLikedPhoto() -> [Photo]
    func search(searchString: String, completion: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void)
    func getTotalAmountOfDownloads(photoID: String, completion: @escaping (Int) -> Void, onError: @escaping (Error) -> Void)
}

// MARK: - VIEW-MODEL
final class ViewModel: ViewModelProtocol {
    
    //  MARK: - Properties
    
    var model: ModelProtocol?
    
    var isLiked: Binding<IndexPath>?
    
    var isDisliked: Binding<IndexPath>?
    
    // MARK: - Functions
    
    /// A function that retrieves photos from a remote server
    func getPhotos(page: Int, completion: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void) {
        model?.getPhotos(page: page, completion: { photos in
            completion(photos)
        }, onError: { error in
            onError(error)
        })
    }
    
    /// Function to add a photo to the database as a favoured photo
    func like(photo: Photo, index: IndexPath) {
        let result = model?.like(photo: photo) ?? false
        if result {
            let notification = Notification(name: Notification.Name("liked"))
            NotificationCenter.default.post(notification)
            isLiked?(index)
        }
    }
    
    /// Function to remove a photo from the database (unliked)
    func dislike(photo: Photo, index: IndexPath) {
        let result = model?.dislike(photo: photo) ?? false
        if result {
            let notification = Notification(name: Notification.Name("disliked"))
            NotificationCenter.default.post(notification)
            isDisliked?(index)
        }
    }
    
    /// A function that receives the favoured photo
    func getLikedPhoto() -> [Photo] {
        guard let result = model?.getLikedPhoto() else { return [] }
        return result
    }
    
    /// A function that makes a query for a search word
    func search(searchString: String, completion: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void) {
        model?.search(searchString: searchString, completion: { photos in
            completion(photos)
        }, onError: { error in
            onError(error)
        })
    }
    
    /// Function returning the number of downloads
    func getTotalAmountOfDownloads(photoID: String, completion: @escaping (Int) -> Void, onError: @escaping (Error) -> Void) {
        model?.getTotalAmountOfDownloads(photoID: photoID, completion: { downloads in
            completion(downloads)
        }, onError: { error in
            onError(error)
        })
    }
    
}
