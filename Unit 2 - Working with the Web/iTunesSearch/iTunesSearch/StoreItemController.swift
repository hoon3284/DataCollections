//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by wickedRun on 2021/09/04.
//

import UIKit

class StoreItemController {
    func fetchItems(matching query: [String: String], completion: @escaping (Result<[StoreItem], Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")!
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }

        let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let searchResponse = try jsonDecoder.decode(SearchResponse.self, from: data)
                    completion(.success(searchResponse.results))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func fetchImages(imageUrl: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // 아래 로그가 자꾸 떠서 https로 설정해주었음
        // Connection 5: unable to determine interface type without an established connection
        // 이런 비슷한 로그들이 떴음.
        // 그래도 뜬다. 왜 뜨는지 잘 모르겠음.
        var urlComponents = URLComponents(url: imageUrl, resolvingAgainstBaseURL: true)
        urlComponents?.scheme = "https"
        let task = URLSession.shared.dataTask(with: urlComponents!.url!) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(error!))
            }
        }
        
        task.resume()
    }
}
