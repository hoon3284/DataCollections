//
//  UserCount.swift
//  Habits
//
//  Created by wickedRun on 2021/10/23.
//

import Foundation

struct UserCount {
    let user: User
    let count: Int
}

extension UserCount: Codable { }

extension UserCount: Hashable {
    // 기본 구현으로 Hashable을 구현했다가 아래처럼 바꾼 이유는.
    // user와 count를 같아야지만 같은 UserCount로 인식되지만
    // 아래처럼 user로만 hash 함수와 == 함수를 구현해주면 user만 같으면 같은 UserCount로 인식된다.
    func hash(into hasher: inout Hasher) {
        hasher.combine(user)
    }
    
    static func == (_ lhs: UserCount, _ rhs: UserCount) -> Bool {
        return lhs.user == rhs.user
    }
}
