//
//  HapticsMorseCodePlayer.swift
//  MorseCodeHaptics
//
//  Created by wickedRun on 2021/09/26.
//

import Foundation
import CoreHaptics

class HapticsMorseCodePlayer: MorseCodePlayer {
    
    let hapticsEngine: CHHapticEngine
    
    init() throws {
        hapticsEngine = try CHHapticEngine()
        try hapticsEngine.start()
    }
    
    func play(message: MorseCodeMessage) throws {
        let events = hapticEvents(for: message)
        let pattern = try CHHapticPattern(events: events, parameters: [])
        let player = try hapticsEngine.makePlayer(with: pattern)
        try player.start(atTime: 0)
    }

    func hapticEvents(for message: MorseCodeMessage) -> [CHHapticEvent] {
        var events: [CHHapticEvent] = []
        var startTime: TimeInterval = 0.4
        message.playbackEvents.forEach { playbackEvent in
            switch playbackEvent {
            case .on(let duration):
                events.append(CHHapticEvent(eventType: .hapticContinuous, parameters: [], relativeTime: startTime, duration: duration))
                startTime += duration
            case .off(let duration):
                startTime += duration
            }
        }
        return events
    }
    
}
