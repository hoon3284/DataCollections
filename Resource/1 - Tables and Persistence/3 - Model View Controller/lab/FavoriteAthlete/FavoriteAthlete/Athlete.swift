//
//  Athlete.swift
//  FavoriteAthlete
//
//  Created by wickedRun on 2021/08/11.
//

import Foundation

struct Athlete: CustomStringConvertible {
    let name: String
    let age: Int
    let league: String
    let team: String
    
    var description: String {
        return "\(name) is \(age) years old and play for the \(team) in the \(league)."
    }
}
