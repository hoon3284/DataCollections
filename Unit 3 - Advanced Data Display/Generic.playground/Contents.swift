import UIKit
import PlaygroundSupport

protocol APIRequest {
    associatedtype Response
    
    var urlRequest: URLRequest { get }
    func decodeResponse(data: Data) throws -> Response
}

// func sendRequest<Request>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) where Request: APIRequest { }
// 같은 메소드 다른 표현 방식. where절 축약
// func sendRequest<Request: APIRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) { }

func sendRequest<Request: APIRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
    let task = URLSession.shared.dataTask(with: request.urlRequest) { (data, response, error) in
        if let data = data {
            do {
                let decodedResponse = try request.decodeResponse(data: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        } else if let error = error {
            completion(.failure(error))
        }
    }
    
    task.resume()
}


struct PhotoInfo: Codable {
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
    }
}

struct PhotoInfoAPIRequest: APIRequest {
    var apiKey: String
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        return URLRequest(url: urlComponents.url!)
    }
    
    func decodeResponse(data: Data) throws -> PhotoInfo {
        let photoInfo = try JSONDecoder().decode(PhotoInfo.self, from: data)
        return photoInfo
    }
}

//PlaygroundPage.current.needsIndefiniteExecution = true
//let photoInfoRequest = PhotoInfoAPIRequest(apiKey: "DEMO_KEY")
//sendRequest(photoInfoRequest) { (result) in
//    switch result {
//    case .success(let photoInfo):
//        print(photoInfo)
//    case .failure(let error):
//        print(error)
//    }
//    PlaygroundPage.current.finishExecution()
//}

struct ImageAPIRequest: APIRequest {
    enum ResponseError: Error {
        case invalidImageData
    }
    
    let url: URL
    
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }
    
    func decodeResponse(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw ResponseError.invalidImageData
        }
        
        return image
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true
let photoInfoRequest = PhotoInfoAPIRequest(apiKey: "DEMO_KEY")
sendRequest(photoInfoRequest) { (result) in
    switch result {
    case .success(let photoInfo):
        print(photoInfo)
        let imageRequest = ImageAPIRequest(url: photoInfo.url)
        sendRequest(imageRequest) { (imageResult) in
            switch imageResult {
            case .success(let image):
                image
            case .failure(let error):
                print(error)
            }
            PlaygroundPage.current.finishExecution()
        }
    case .failure(let error):
        print(error)
        PlaygroundPage.current.finishExecution()
    }
}
