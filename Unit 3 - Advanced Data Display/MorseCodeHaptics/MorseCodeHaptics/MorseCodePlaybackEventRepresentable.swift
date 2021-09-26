//
//  MorseCodePlaybackEventRepresentable.swift
//  MorseCodeHaptics
//
//  Created by wickedRun on 2021/09/25.
//

import Foundation
import UIKit

protocol MorseCodePlaybackEventRepresentable {
    var playbackEvents: [MorseCodePlaybackEvent] { get } // 기본 구현 해놓고 아래서 components와 componentSeparationDuration을 사용해서 다시 구현.
    var components: [MorseCodePlaybackEventRepresentable] { get }
    var componentSeparationDuration: TimeInterval { get }
}

extension TimeInterval {
    static let morseCodeUnit: TimeInterval = 0.2
}

extension MorseCodeSignal: MorseCodePlaybackEventRepresentable {
    var playbackEvents: [MorseCodePlaybackEvent] {
        switch self {
        case .short:
            return [.on(.morseCodeUnit)]
        case .long:
            return [.on(.morseCodeUnit * 3)]
        }
    }
    var components: [MorseCodePlaybackEventRepresentable] { [] }
    var componentSeparationDuration: TimeInterval { 0.0 }
}

extension MorseCodeCharacter: MorseCodePlaybackEventRepresentable {
    var components: [MorseCodePlaybackEventRepresentable] { signals }
    var componentSeparationDuration: TimeInterval { .morseCodeUnit }
}

extension MorseCodeWord: MorseCodePlaybackEventRepresentable {
    var components: [MorseCodePlaybackEventRepresentable] { characters }
    var componentSeparationDuration: TimeInterval { .morseCodeUnit * 3 }
}

extension MorseCodeMessage: MorseCodePlaybackEventRepresentable {
    var components: [MorseCodePlaybackEventRepresentable] { words }
    var componentSeparationDuration: TimeInterval { .morseCodeUnit * 7 }
}

extension MorseCodePlaybackEventRepresentable {
    var playbackEvents: [MorseCodePlaybackEvent] {
        components.flatMap { component in
            component.playbackEvents + [.off(componentSeparationDuration)]
        }
    }
}
