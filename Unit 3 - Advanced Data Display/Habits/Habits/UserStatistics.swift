//
//  UserStatistics.swift
//  Habits
//
//  Created by wickedRun on 2021/10/25.
//

import Foundation

struct UserStatistics {
    let user: User
    let habitCounts: [HabitCount]
}

extension UserStatistics: Codable { }
