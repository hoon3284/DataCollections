//
//  PhotoInfoController.swift
//  SpacePhoto
//
//  Created by wickedRun on 2021/09/02.
//

import UIKit

class PhotoInfoController {
    
    func fetchPhotoInfo(completion: @escaping (Result<PhotoInfo, Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        urlComponents.queryItems = [
            "api_key": "DEMO_KEY",
//            "date": "2021-02-23"    // video 확인을 위해서 media_type이 video인 날을 추가했다.
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                do {
                    let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
                    completion(.success(photoInfo))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // HTTP로 받아오는 법은 info.plist의 App Transport Security Settings 키값 참조.
        // 하지만 가능하다면 HTTPS를 사용해야 한다.
        // 그래서 programmatically하게 url을 바꾸는 방법은 아래 방법.
        // 이 프로젝트에서는 NASA APOD API는 https를 지원하므로 단순하게 url을 업데이트할 수 있다.
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.scheme = "https"
        
        let task = URLSession.shared.dataTask(with: urlComponents!.url!) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(PhotoInfoError.imageDataMissing))
            }
        }
        
        task.resume()
    }
    
    enum PhotoInfoError: Error, LocalizedError {
        case imageDataMissing
    }
}
