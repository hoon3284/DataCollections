//
//  APIService.swift
//  Habits
//
//  Created by wickedRun on 2021/10/19.
//

import Foundation

struct HabitRequest: APIRequest {
    typealias Response = [String: Habit]
    
    var habitName: String?
    
    var path: String { "/habits" }
}

struct UserRequest: APIRequest {
    typealias Response = [String: User]
    
    var path: String { "/users" }
}
