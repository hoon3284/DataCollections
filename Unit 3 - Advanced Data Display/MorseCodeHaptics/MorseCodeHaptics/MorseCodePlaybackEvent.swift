//
//  MorseCodePlaybackEvent.swift
//  MorseCodeHaptics
//
//  Created by wickedRun on 2021/09/25.
//

import Foundation

enum MorseCodePlaybackEvent {
    case on(TimeInterval)
    case off(TimeInterval)
    
    var duration: TimeInterval {
        switch self {
        case .on(let duration):
            return duration
        case .off(let duration):
            return duration
        }
    }
}

let sosEvents: [MorseCodePlaybackEvent] = [
    // S
    .on(1), .off(1), .on(1), .off(1), .on(1), .off(3),
    // O
    .on(3), .off(1), .on(3), .off(1), .on(3), .off(1),
    // S
    .on(1), .off(1), .on(1), .off(1), .on(1), .off(3)
]
