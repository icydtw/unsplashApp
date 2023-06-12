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
    func getPhotos(completion: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void)
    func like(photo: Photo, index: IndexPath)
    func dislike(photo: Photo, index: IndexPath)
    func getLikedPhoto() -> [Photo]
}

// MARK: - VIEW-MODEL
final class ViewModel: ViewModelProtocol {
    
    //  MARK: - Properties
    
    var model: ModelProtocol?
    
    var isLiked: Binding<IndexPath>?
    
    var isDisliked: Binding<IndexPath>?
    
    // MARK: - Functions
    
    /// A function that retrieves photos from a remote server
    func getPhotos(completion: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void) {
        model?.getPhotos(completion: { photos in
            completion(photos)
        }, onError: { error in
            onError(error)
        })
    }
    
    /// Function to add a photo to the database as a favoured photo
    func like(photo: Photo, index: IndexPath) {
        let result = model?.like(photo: photo) ?? false
        if result {
            isLiked?(index)
        }
    }
    
    /// Function to remove a photo from the database (unliked)
    func dislike(photo: Photo, index: IndexPath) {
        let result = model?.dislike(photo: photo) ?? false
        if result {
            isDisliked?(index)
        }
    }
    
    /// A function that receives the favoured photo
    func getLikedPhoto() -> [Photo] {
        guard let result = model?.getLikedPhoto() else { return [] }
        return result
    }
    
}
