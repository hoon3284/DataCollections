//
//  PhotoInfo.swift
//  SpacePhoto
//
//  Created by wickedRun on 2021/09/02.
//

import Foundation

struct PhotoInfo: Codable {
    var title: String
    var description: String
    var mediaType: String
    var url: URL
    var copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
        case mediaType = "media_type"
    }
}
