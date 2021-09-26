//
//  MorseCodePlayer.swift
//  MorseCodeHaptics
//
//  Created by wickedRun on 2021/09/25.
//

import Foundation

protocol MorseCodePlayer {
    func play(message: MorseCodeMessage) throws
}
