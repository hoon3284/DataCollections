//
//  HabitStatistics.swift
//  Habits
//
//  Created by wickedRun on 2021/10/23.
//

import Foundation

struct HabitStatistics {
    let habit: Habit
    let userCounts: [UserCount]
}

extension HabitStatistics: Codable { }
