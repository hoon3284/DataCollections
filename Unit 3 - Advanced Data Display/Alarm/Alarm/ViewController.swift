//
//  ViewController.swift
//  Alarm
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var alarmLabel: UILabel!
    
    @IBOutlet var scheduleButton: UIButton!
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .alarmUpdated, object: nil)
    }

    @IBAction func setAlarmButtonTapped(_ sender: UIButton) {
        if let alarm = Alarm.scheduled {
            alarm.unschedule()
        } else {
            let alarm = Alarm(date: datePicker.date)
            alarm.schedule { [weak self] (permissionGranted) in
                // closure는 self가 해제 될 때까지 기다리고 self는 closure가 해제될 때까지 기다리는 strong reference cycle 상황을 만들어 내게 된다. 이러한 상황을 해결하기 위해 사용하는 것이 [weak self]이다.
                // 사용법은 [weak self] param in 을 명시해주고 self가 사용되는 곳에 self를 optional로 사용해주면 strong reference cycle 상황을 피해갈 수 있게 된다.
                if !permissionGranted {
                    self?.presentNeedAuthorizationAlert()
                }
            }
        }
    }
    
    @objc func updateUI() {
        if let scheduledAlarm = Alarm.scheduled {
            let formattedAlarm = dateFormatter.string(from: scheduledAlarm.date)
            alarmLabel.text = "Your alarm is scheduled for \(formattedAlarm)"
            datePicker.isEnabled = false
            scheduleButton.setTitle("Remove Alarm", for: .normal)
        } else {
            alarmLabel.text = "Set an alarm below"
            datePicker.isEnabled = true
            scheduleButton.setTitle("Set Alarm", for: .normal)
        }
    }
    
    func presentNeedAuthorizationAlert() {
        let title = "Authorization Needed"
        let message = "Alarms don't work without notifications, and it looks like you haven't granted us permission to send you those. Please go to the iOS Settings app and grant us notification permissions."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
