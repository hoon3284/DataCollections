//
//  LoggedHabit.swift
//  Habits
//
//  Created by wickedRun on 2021/10/26.
//

import Foundation

struct LoggedHabit {
    let userID: String
    let habitName: String
    let timestamp: Date
}

extension LoggedHabit: Codable { }
