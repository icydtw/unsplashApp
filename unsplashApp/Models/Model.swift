//
//  Model.swift
//  unsplashApp
//
//  Created by Илья Тимченко on 12.06.2023.
//

import Foundation

struct PhotoURLS: Codable {
    let full: String?
    let small: String?
}

struct User: Codable {
    let name: String?
}

struct Photo: Codable {
    let user: User?
    let urls: PhotoURLS?
}

protocol ModelProtocol {
    func getPhotos(completion: @escaping ([Photo]) -> Void)
}

final class Model: ModelProtocol {
    
    let urlString = "https://api.unsplash.com/"
    
    let accessKey = "LUFz7Gq43MPt3wtmlzhixhbEAneHlJK4Cv1xKaHpvtg"
    
    var page = 0
    
    func getPhotos(completion: @escaping ([Photo]) -> Void) {
        page = 1
        guard var urlComponents = URLComponents(string: urlString + "photos") else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "page", value: "\(page)")
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
            }
        }).resume()
    }
    
}
