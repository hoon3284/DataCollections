//
//  Color.swift
//  Habits
//
//  Created by wickedRun on 2021/10/19.
//

import Foundation

struct Color {
    let hue: Double
    let saturation: Double
    let brightness: Double
}

extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case hue = "h"
        case saturation = "s"
        case brightness = "b"
    }
}
