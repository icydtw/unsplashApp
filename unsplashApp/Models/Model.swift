//
//  Model.swift
//  unsplashApp
//
//  Created by Илья Тимченко on 12.06.2023.
//

import CoreData
import UIKit

// MARK: - Structs

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

struct Welcome: Codable {
    let total, totalPages: Int?
    let results: [Photo]?

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Protocols

protocol ModelProtocol {
    func getPhotos(page: Int, completion: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void)
    func like(photo: Photo) -> Bool
    func dislike(photo: Photo) -> Bool
    func getLikedPhoto() -> [Photo]
    func search(searchString: String, completion: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void)
}

// MARK: - MODEL
final class Model: ModelProtocol {
    
    //  MARK: - Properties
    
    let urlString = "https://api.unsplash.com/"
    
    let accessKey = "LUFz7Gq43MPt3wtmlzhixhbEAneHlJK4Cv1xKaHpvtg"
    
    //var page = 0
    
    // MARK: - Functions
    
    /// A function that retrieves photos from a remote server
    func getPhotos(page: Int, completion: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void) {
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
    
    /// Function to add a photo to the database as a favoured photo
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
    
    /// Function to remove a photo from the database (unliked)
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
    
    /// A function that receives the favoured photo
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
    
    func search(searchString: String, completion: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void) {
        guard var urlComponents = URLComponents(string: urlString + "search/photos") else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "query", value: searchString)
        ]
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)
        var result: [Photo] = []
        let _ = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                result = try decoder.decode(Welcome.self, from: data).results ?? []
                completion(result)
            } catch {
                print("ERROR \(#function) \(error)")
                onError(error)
            }
        }).resume()
    }
    
}
