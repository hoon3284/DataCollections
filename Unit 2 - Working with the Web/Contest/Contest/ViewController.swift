//
//  ViewController.swift
//  Contest
//
//  Created by wickedRun on 2021/08/28.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func submitButtonTapped(_ sender: UIButton) {
        let email = emailTextField.text!
        if !email.isEmpty {
            performSegue(withIdentifier: "submitSegue", sender: nil)
        } else {
            // 1번 방법
//            UIView.animate(withDuration: 0.1, animations: {
//                self.emailTextField.transform = CGAffineTransform(translationX: 10, y: 0)
//            }, completion: { (_) in
//                UIView.animate(withDuration: 0.1, animations: {
//                    self.emailTextField.transform = CGAffineTransform(translationX: -20, y: 0)
//                }) { (_) in
//                    UIView.animate(withDuration: 0.1) {
//                        self.emailTextField.transform = CGAffineTransform.identity
//                    }
//                }
//            })
            
            // 2번 방법
//            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: [], animations: {
//                self.emailTextField.transform = CGAffineTransform(translationX: -10, y: 0)
//            }, completion: { (_) in
//                UIView.animate(withDuration: 0.1) {
//                    self.emailTextField.transform = CGAffineTransform.identity
//                }
//            })
            
            // Challenge Extra shaking
            // https://zeddios.tistory.com/636 : 이 함수에 대한 설명 링크
            // 내가 이해한 바로는 맨위에 withDuration은 전체 시간.
            // 아래 각 프레임에 처음 변수는 start 시간.
            // 두번째 변수는 withDuration(전체시간)에서 나누어서 구하면서 1초에서 0.2면 0.2초 동안 해당 프레임 애니메이션한다.
            // 1번 방법을 이 함수를 사용한다면 훨씬 보기 쉬워진다.
            // 이렇게 프레임들이 딱딱 맞지 않으면 굉장이 어색하다.
            // 그래서 실제로 적용할때는 숫자를 바로 넣지말고 변수로 저장해서 계산하면서 하면 좋을듯
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                    self.emailTextField.transform = CGAffineTransform(translationX: -5, y: 0)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3) {
                    self.emailTextField.transform = CGAffineTransform(translationX: 10, y: 0)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.3) {
                    self.emailTextField.transform = CGAffineTransform(translationX: -10, y: 0)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2) {
                    self.emailTextField.transform = CGAffineTransform.identity
                }
            }, completion: nil)
            
        }
    }
    
}

