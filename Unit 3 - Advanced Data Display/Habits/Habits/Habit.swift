//
//  Habit.swift
//  Habits
//
//  Created by wickedRun on 2021/10/19.
//

import Foundation

struct Habit {
    let name: String
    let category: Category
    let info: String
}

extension Habit: Codable { }

extension Habit: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    // Hashable은 Equatable도 채택하고 있으므로 Equatable도 따로 선언해주지 않고 이 메소드를 구현해주면된다.
    static func == (lhs: Habit, rhs: Habit) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Habit: Comparable {
    // sorting 하기 위해 꼭 필요한 protocol
    static func < (lhs: Habit, rhs: Habit) -> Bool {
        return lhs.name < rhs.name
    }
}
