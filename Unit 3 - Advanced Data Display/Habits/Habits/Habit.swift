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
