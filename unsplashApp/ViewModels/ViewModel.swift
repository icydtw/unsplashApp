//
//  ViewModel.swift
//  unsplashApp
//
//  Created by Илья Тимченко on 12.06.2023.
//

import Foundation

protocol ViewModelProtocol {
    func getPhotos(completion: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void)
}

final class ViewModel: ViewModelProtocol {
    
    var model: ModelProtocol?
    
    func getPhotos(completion: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void) {
        model?.getPhotos(completion: { photos in
            completion(photos)
        }, onError: { error in
            onError(error)
        })
    }
    
}
