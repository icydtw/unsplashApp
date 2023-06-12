//
//  ViewModel.swift
//  unsplashApp
//
//  Created by Илья Тимченко on 12.06.2023.
//

import Foundation

typealias Binding<T> = (T) -> Void

protocol ViewModelProtocol {
    var isLiked: Binding<IndexPath>? { get set }
    var isDisliked: Binding<IndexPath>? { get set }
    func getPhotos(completion: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void)
    func like(photo: Photo, index: IndexPath)
    func dislike(photo: Photo, index: IndexPath)
}

final class ViewModel: ViewModelProtocol {
    
    var model: ModelProtocol?
    
    var isLiked: Binding<IndexPath>?
    
    var isDisliked: Binding<IndexPath>?
    
    func getPhotos(completion: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void) {
        model?.getPhotos(completion: { photos in
            completion(photos)
        }, onError: { error in
            onError(error)
        })
    }
    
    func like(photo: Photo, index: IndexPath) {
        let result = model?.like(photo: photo) ?? false
        if result {
            isLiked?(index)
        }
    }
    
    func dislike(photo: Photo, index: IndexPath) {
        let result = model?.dislike(photo: photo) ?? false
        if result {
            isDisliked?(index)
        }
    }
    
}
