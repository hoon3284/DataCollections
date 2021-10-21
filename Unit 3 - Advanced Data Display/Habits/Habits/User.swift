//
//  User.swift
//  Habits
//
//  Created by wickedRun on 2021/10/21.
//

import Foundation

struct User {
    let id: String
    let name: String
    let color: Color?
    let bio: String?
}

extension User: Codable { }

extension User: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (_ lhs: User, _ rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

extension User: Comparable {
    static func < (_ lhs: User, _ rhs: User) -> Bool {
        return lhs.name < rhs.name
    }
}
