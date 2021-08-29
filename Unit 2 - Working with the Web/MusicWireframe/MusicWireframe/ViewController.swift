//
//  ViewController.swift
//  MusicWireframe
//
//  Created by wickedRun on 2021/08/28.
//

import UIKit

class ViewController: UIViewController {
    var isPlaying: Bool = true {
        didSet {
            playPauseButton.isSelected = isPlaying
        }
    }
    
    @IBOutlet var albumImageView: UIImageView!
    @IBOutlet var reverseBackground: UIView!
    @IBOutlet var playPauseBackground: UIView!
    @IBOutlet var forwardBackground: UIView!
    @IBOutlet var reverseButton: UIButton!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var forwardButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        [reverseBackground, playPauseBackground, forwardBackground].forEach { view in
            view?.layer.cornerRadius = view!.frame.height / 2
            // layer 타입은 CALayer(Core Animation layer).
            // UIView는 CALayer의 wrapper
            view?.clipsToBounds = true
            view?.alpha = 0.0
        }
    }
    
    @IBAction func touchedDown(_ sender: UIButton) {
        print("touchedDown")
        let buttonBackground: UIView
        switch sender {
        case reverseButton:
            buttonBackground = reverseBackground
        case playPauseButton:
            buttonBackground = playPauseBackground
        case forwardButton:
            buttonBackground = forwardBackground
        default:
            return
        }
        UIView.animate(withDuration: 0.25) {
            buttonBackground.alpha = 0.3
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    @IBAction func playPauseButtonTapped() {
        print("playpauseButton")
        isPlaying.toggle()
        if isPlaying {
            UIView.animate(withDuration: 0.8, delay: 0,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.1,
                           options: [],
                           animations: {
                            self.albumImageView.transform = CGAffineTransform.identity
                           },
                           completion: nil)
        } else {
            UIView.animate(withDuration: 0.5) {
                self.albumImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
    }

    @IBAction func touchedUpInside(_ sender: UIButton) {
        print("touchedUpInside")
        // 여기서 touchUpInside를 두개 정의하는데 이거를 연결할때
        // 버튼 connections inspector에서
        // playPauseButtonTapped 뒤에 연결점에서 이 함수로 연결하였음.
        let buttonBackground: UIView
        
        switch sender {
        case reverseButton:
            buttonBackground = reverseBackground
        case playPauseButton:
            buttonBackground = playPauseBackground
        case forwardButton:
            buttonBackground = forwardBackground
        default:
            return
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            buttonBackground.alpha = 0.0
            buttonBackground.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            sender.transform = CGAffineTransform.identity
        }, completion: { (_) in
            buttonBackground.transform = CGAffineTransform.identity
        })
        
    }
    
    
}

