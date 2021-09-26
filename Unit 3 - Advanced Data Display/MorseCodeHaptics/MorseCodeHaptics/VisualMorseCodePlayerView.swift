//
//  VisualMorseCodePlayerView.swift
//  MorseCodeHaptics
//
//  Created by wickedRun on 2021/09/26.
//

import UIKit

class VisualMorseCodePlayerView: UIView, MorseCodePlayer {
    
    func play(message: MorseCodeMessage) throws {
        message.playbackEvents.forEach { playbackEvent in
            Timer.scheduledTimer(withTimeInterval: playbackEvent.duration, repeats: false) { timer in
                self.updateUI(event: playbackEvent)
            }
            RunLoop.current.run(until: Date().addingTimeInterval(playbackEvent.duration))
            // 여기서 좀 헤맸는데 timer를 current에 등록하고 바로 런을 해준다.
            // 그냥 run()만 했을때는 영구적으로 계속 실행하도록 되기때문에 계속 돈다.
            // 그래서 until 변수를 받는 메소드를 썼을 때 until까지만 current 루프를 실행하도록 한다.
        }
        // sync(진동과 화면 색 같음)가 살짝 맞지만 정확하게는 맞지 않는다.
        // visual이 시작할때가 playbackEvent.duration이 지난 후에 시작하고
        // haptic은 바로 시작한다 그래서 대충 starttime을 0.4로 맞췄는데 완전 잘맞지는 않는다.
        
    }
    
    func updateUI(event: MorseCodePlaybackEvent) {
        switch event {
        case .on:
            backgroundColor = .white
        case .off:
            backgroundColor = .black
        }
//        setNeedsDisplay() 이걸 주석처리해도 실행된다 왜그런지는 공부해야할듯.
    }
}
