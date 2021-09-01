import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// data를 json형식으로 이쁘게 보여주는 extension 함수 저 밑에 option .prettyPrinted가 이쁘게 바꿔주는 듯 그 밑에는 그냥 String으로.
extension Data {
    func prettyPrintedJSONString() {
        guard
            let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
            let prettyJSONString = String(data: jsonData, encoding: .utf8) else {
            print("Failed to read JSON Object.")
            return
        }
        print(prettyJSONString)
    }
}

struct StoreItem: Codable {
    var name: String
    var artist: String
    var kind: String
    var description: String
    var artworkURL: URL

    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case kind
        case description
        case artworkURL = "artworkUrl60"
    }
    
    // CodingKeys Enum에서 description 속성이 없을 경우에 이 AdditionalKeys(추가적인 키들) 참조
    enum AdditionalKeys: CodingKey {
        case longDescription
    }
    
    // AdditionalKeys를 참조하기 위해서 init을 직접 정의.
    // 직접 정의안해도 오류는 안나지만 CodingKeys만 참조하게 된다.
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        artist = try values.decode(String.self, forKey: .artist)
        kind = try values.decode(String.self, forKey: .kind)
        artworkURL = try values.decode(URL.self, forKey: .artworkURL)
        
        // 이 부분에서 Description을 가지고 오는데 둘다(description, longDescription) 속성이 없다면 "" 빈문자열을 넣는다.
        if let description = try? values.decode(String.self, forKey: .description) {
            self.description = description
        } else {
            let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)
            description = (try? additionalValues.decode(String.self, forKey: .longDescription)) ?? ""
        }
    }
}

struct SearchResponse: Codable {
    let results: [StoreItem]
}



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

let query = [
    "term": "Apple",
    "media": "ebook",
    "attribute": "authorTerm",
    "lang": "en_us",
    "limit": "10"
]

fetchItems(matching: query) { (result) in
    switch result {
    case .success(let storeItems):
        storeItems.forEach { item in
            print("""
                Name: \(item.name)
                Artist: \(item.artist)
                Kind: \(item.kind)
                Description: \(item.description)
                Artwork URL: \(item.artworkURL)
                
                """)
        }
    case .failure(let error):
        print(error)
    }
    
    PlaygroundPage.current.finishExecution()
}

