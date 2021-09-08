//
//  MenuItem.swift
//  OrderApp
//
//  Created by wickedRun on 2021/09/07.
//

import Foundation

struct MenuItem: Codable {
    var id: Int
    var name: String
    var detailText: String // Description이란 변수는 NSObject에도 정의되어 있고 CustomStringConvertible 프로토콜에도 정의되어 있다.
    var price: Double
    var category: String
    var imageURL: URL

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case detailText = "description" // 대문자 인식 못해서 오류 났었음.
        case price
        case category
        case imageURL = "image_url"
    }
}
