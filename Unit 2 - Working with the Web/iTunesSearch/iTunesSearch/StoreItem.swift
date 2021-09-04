//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by wickedRun on 2021/09/04.
//

import Foundation

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
        case artworkURL = "artworkUrl100"
    }
    
    enum AdditionalKeys: CodingKey {
        case longDescription
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        artist = try values.decode(String.self, forKey: .artist)
        kind = try values.decode(String.self, forKey: .kind)
        artworkURL = try values.decode(URL.self, forKey: .artworkURL)
        
        if let description = try? values.decode(String.self, forKey: CodingKeys.description) {
            self.description = description
        } else {
            let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)
            description = (try? additionalValues.decode(String.self, forKey: .longDescription)) ?? ""
        }
    }
}

struct SearchResponse: Codable {
    var results: [StoreItem]
}


