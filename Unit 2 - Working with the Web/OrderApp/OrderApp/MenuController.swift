//
//  MenuController.swift
//  OrderApp
//
//  Created by wickedRun on 2021/09/07.
//

import UIKit

class MenuController {
    static let shared = MenuController()
    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
        }
    }
    let baseURL = URL(string: "http://localhost:8080/")!
    
    // /categories는 쿼리가 없기때문에 completion만 매개변수로 가진다.
    func fetchCategories(completion: @escaping (Result<[String], Error>) -> Void) {
        let categoriesURL = baseURL.appendingPathComponent("categories")
        
        let task = URLSession.shared.dataTask(with: categoriesURL) { (data, response, error) in
            print(response ?? "none")
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let categoriesResponse = try jsonDecoder.decode(CategoriesResponse.self, from: data)
                    completion(.success(categoriesResponse.categories))
                } catch {
                    // decode 오류
                    completion(.failure(error))
                }
            } else if let error = error {
                // URLSession 오류
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // /menu는 카테고리가 필요하므로 매개변수는 카테고리와 completion.
    func fetchMenuItems(forCategory categoryName: String, completion: @escaping (Result<[MenuItem], Error>) ->  Void) {
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components.url!
        let task = URLSession.shared.dataTask(with: menuURL) { (data, response, error) in
            print(response ?? "none")
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let menuResponse = try jsonDecoder.decode(MenuResponse.self, from: data)
                    completion(.success(menuResponse.items))
                } catch {
                    // decode 오류
                    completion(.failure(error))
                }
            } else if let error = error {
                // urlSession 오류
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    typealias MinutesToPrepare = Int
    // The POST to /order (post 방식은 데이터를 body에 실어보냄.)
    func submitOrder(forMenuIDs menuIDs: [Int], completion: @escaping (Result<MinutesToPrepare, Error>) -> Void) {
        let orderURL = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = ["menuIds": menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let orderResponse = try jsonDecoder.decode(OrderResponse.self, from: data)
                    completion(.success(orderResponse.prepTime))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // Result<>로 처리하지 않는 이유는 이미지를 못가져왔더라도 경고까지 해줄 필요는 없다.
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                // 애플에서 제공한 서버 프로그램이 image를 못불러오는 에러가 있다.
                // 브라우저에서 접속시 아래 json이 화면에 뜸.
                // {"error":true,"reason":"The menu item with ID 112345.png does not exist."}
                //completion(nil)
                
                // 이미지들을 Assets.xcassets에 넣고 UIImage(named:)로 처리하겠음.
                print("error 발생")
                let newUrl = String(url.relativeString.suffix(5))
                completion(UIImage(named: newUrl))
            }
        }
        task.resume()
    }
}
