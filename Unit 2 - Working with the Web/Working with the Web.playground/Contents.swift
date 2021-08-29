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
var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
urlComponents.queryItems = [
    "api_key": "DEMO_KEY",
    "date": "2013-07-16"
].map { URLQueryItem(name: $0.key, value: $0.value) }

let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
    if let data = data, let string = String(data: data, encoding: .utf8) {
        print(string)
    }
    PlaygroundPage.current.finishExecution()
}
task.resume()
