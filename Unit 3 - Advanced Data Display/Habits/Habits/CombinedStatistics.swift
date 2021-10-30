//
//  CombinedStatistics.swift
//  Habits
//
//  Created by wickedRun on 2021/10/28.
//

import Foundation

struct CombinedStatistics {
    let userStatistics: [UserStatistics]
    let habitStatistics: [HabitStatistics]
}

extension CombinedStatistics: Codable { }
