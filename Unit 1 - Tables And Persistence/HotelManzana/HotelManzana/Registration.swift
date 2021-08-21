//
//  Registration.swift
//  HotelManzana
//
//  Created by wickedRun on 2021/08/22.
//

import Foundation

struct Registration {
    var firstName: String
    var lastName: String
    var emailAddress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var wifi: Bool
    var roomType: RoomType
}

struct RoomType: Equatable {
    static var all: [RoomType] {
        return [
            RoomType(id: 0, name: "Two Queens", shortName: "2Q", price: 179),
            RoomType(id: 1, name: "One King", shortName: "K", price: 209),
            RoomType(id: 2, name: "Penthouse suite", shortName: "PHS", price: 309)
        ]
    }
    
    var id: Int
    var name: String
    var shortName: String
    var price: Int
    
    static func == (_ lhs: RoomType, _ rhs: RoomType) -> Bool {
        return lhs.id == rhs.id
    }
}
