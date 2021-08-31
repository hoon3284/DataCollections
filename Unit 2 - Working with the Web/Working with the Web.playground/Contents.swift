import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//let url = URL(string: "https://www.apple.com")!
//print(url.scheme!)
//print(url.host!)
//print(url.query ?? "nil")

//let url = URL(string: "https://www.apple.com")!
//let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//    if let data = data ,let string = String(data: data, encoding: .utf8) {
//        print(data as NSData)   // truncated bytes property 출력 예시 : { length = 66594, byte = 0x0a090a0a... 0a090a0a }
//        print(string)       // html로 출력
//    }
//    PlaygroundPage.current.finishExecution()
//}
//task.resume()

//let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")!
//let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//    if let data = data, let string = String(data: data, encoding: .utf8) {
//        print(string)
//    }
//    PlaygroundPage.current.finishExecution()
//}
//task.resume()

// URLComponents: URLComponents that will help you parse, read, or create all the parts of a URL in a safe, accurate way.
// URLComponents is especially useful when creating queries for URL instances.
//var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
//urlComponents.queryItems = [
//    "api_key": "DEMO_KEY",
//    "date": "2013-07-16"
//].map { URLQueryItem(name: $0.key, value: $0.value) }
//
//let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
//    if let data = data, let string = String(data: data, encoding: .utf8) {
//        print(string)
//    }
//    PlaygroundPage.current.finishExecution()
//}
//task.resume()


// JSON
struct PhotoInfo: Codable {
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    
    // CodingKey : JSON의 키값과 만든 데이터타입의 변수이름이 다를 경우 매핑해주는 protocol
    // 아래처럼 CodingKeys를 만들면 매핑이 된다.
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
    }
}

//var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
//urlComponents.queryItems = [
//    "api_key": "DEMO_KEY",
//    "date": "2017-02-13"
//].map { URLQueryItem(name: $0.key, value: $0.value) }
//
//let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
//    let jsonDecoder = JSONDecoder()
//    if let data = data,/* let photoDictionary = try? jsonDecoder.decode([String: String].self, from: data), */let photoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data) {
////        print(photoDictionary)
////        위에 PhotoInfo Structure를 만들었고 Codable을 채택했으니 jsonDecoder로 해당 타입으로 decode될 수 있다.
////        기본적으로 decode해서 목적 타입에서 없는 변수(키값)은 무시된다.
//        print(photoInfo)
//    }
//    PlaygroundPage.current.finishExecution()
//}
//task.resume()

// 함수로 옮김
// 이 방법으로는 못한다.
//func fetchPhotoInfo() -> PhotoInfo {
//    var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
//    urlComponents.queryItems = [
//        "api_key": "DEMO_KEY"
//    ].map { URLQueryItem(name: $0.key, value: $0.value) }
//
//    let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
//        let jsonDecoder = JSONDecoder()
//        if let data = data, let photoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data) {
//            print(photoInfo)
//        }
//        PlaygroundPage.current.finishExecution()
//    }
//    task.resume()
//
//    return
//}

//func performLongRunningOperation(completion: @escaping (String, Int, Data) -> Void) {
//    // Code that performs a long running operation that creates `result: String`, `code: Int`, data: Data` variables
//    completion(result, code, data)
//}

//func fetchPhotoInfo(completion: @escaping (PhotoInfo) -> Void) {
//    var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
//    urlComponents.queryItems = [
//        "api_key": "DEMO_KEY"
//    ].map { URLQueryItem(name: $0.key, value: $0.value) }
//
//    let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
//        let jsonDecoder = JSONDecoder()
//        if let data = data, let photoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data) {
//            // 데이터를 받아왔을 때 처리를 내가 넘긴 closure로 처리한다.
//            completion(photoInfo)
//        }
//        PlaygroundPage.current.finishExecution()
//    }
//
//    task.resume()
//}
//
//fetchPhotoInfo { (photoInfo) in
//    print(photoInfo)
//    print(photoInfo.url)
//}


// 위에 코드는 데이터를 받아올 때 오류가 나면 어디서 무슨 오류가 나는지 알지 못한다.
// 그래서 Result<Success, Failure>를 사용한 코드.
func fetchPhotoInfo(completion: @escaping (Result<PhotoInfo, Error>) -> Void) {
    var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
    urlComponents.queryItems = [
        "api_key": "DEMO_KEY"
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
        }
    }
    task.resume()
}

fetchPhotoInfo { (result) in
    switch result {
    case .success(let photoInfo):
        print("Successfully fetched PhotoInfo: \(photoInfo.title)")
        print(photoInfo)
    case .failure(let error):
        print("Fetch PhotoInfo Failed with Error: \(error)")
    }
    PlaygroundPage.current.finishExecution()
}
