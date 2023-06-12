//
//  Model.swift
//  unsplashApp
//
//  Created by Илья Тимченко on 12.06.2023.
//

import CoreData
import UIKit

struct PhotoURLS: Codable {
    let full: String?
    let small: String?
}

struct User: Codable {
    let name: String?
    let location: String?
}

struct Photo: Codable {
    let user: User?
    let urls: PhotoURLS?
    let created_at: String?
}

protocol ModelProtocol {
    func getPhotos(completion: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void)
    func like(photo: Photo) -> Bool
    func dislike(photo: Photo) -> Bool
    func getLikedPhoto() -> [Photo]
}

final class Model: ModelProtocol {
    
    let urlString = "https://api.unsplash.com/"
    
    let accessKey = "LUFz7Gq43MPt3wtmlzhixhbEAneHlJK4Cv1xKaHpvtg"
    
    var page = 0
    
    func getPhotos(completion: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void) {
        page += 1
        guard var urlComponents = URLComponents(string: urlString + "photos") else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)
        var result: [Photo] = []
        let _ = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                result = try decoder.decode([Photo].self, from: data)
                completion(result)
            } catch {
                print("ERROR \(#function) \(error)")
                onError(error)
            }
        }).resume()
    }
    
    func like(photo: Photo) -> Bool {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persisnetContainer.viewContext else {
            print("ERROR")
            return false
        }
        let newLikedPhoto = LikedImages(context: context)
        newLikedPhoto.createdAt = photo.created_at
        newLikedPhoto.location = photo.user?.location
        newLikedPhoto.urlFull = photo.urls?.full
        newLikedPhoto.urlSmall = photo.urls?.small
        newLikedPhoto.userName = photo.user?.name
        do {
            try context.save()
        } catch {
            return false
        }
        return true
    }
    
    func dislike(photo: Photo) -> Bool {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persisnetContainer.viewContext else {
            print("ERROR")
            return false
        }
        let request = NSFetchRequest<LikedImages>(entityName: "LikedImages")
        request.predicate = NSPredicate(format: "urlFull == %@", photo.urls?.full ?? "")
        do {
            let photoToDelete = try context.fetch(request).first
            context.delete(photoToDelete ?? LikedImages())
            try context.save()
        } catch {
            return false
        }
        return true
    }
    
    func getLikedPhoto() -> [Photo] {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persisnetContainer.viewContext else {
            print("ERROR")
            return []
        }
        let request = NSFetchRequest<LikedImages>(entityName: "LikedImages")
        var result: [Photo] = []
        do {
            let likedPhotos =  try context.fetch(request)
            for photo in likedPhotos {
                let photoURLS = PhotoURLS(full: photo.urlFull, small: photo.urlSmall)
                let user = User(name: photo.userName, location: photo.location)
                let photoToAdd = Photo(user: user, urls: photoURLS, created_at: photo.createdAt)
                result.append(photoToAdd)
            }
            return result
        } catch {
            return []
        }
    }
    
}
