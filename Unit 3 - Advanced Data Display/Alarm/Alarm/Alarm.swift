//
//  Alarm.swift
//  Alarm
//
//  Created by wickedRun on 2021/10/12.
//  Copyright © 2021 AppDev Training. All rights reserved.
//

import UserNotifications

struct Alarm {
    private var notificationId: String
    var date: Date
    
    init(date: Date, notificationId: String? = nil) {
        self.date = date
        self.notificationId = notificationId ?? UUID().uuidString
    }
    
    func schedule(completion: @escaping (Bool) -> ()) {
        authorizeIfNeeded { (granted) in
            guard granted else {
                DispatchQueue.main.async {
                    completion(false)
                }
                
                return
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Beep Beep"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = Alarm.notificationCategoryId
        
        let triggerDateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: self.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: self.notificationId, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    func unschedule() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationId])
    }
    
    private func authorizeIfNeeded(completion: @escaping (Bool) -> ()) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                completion(true)
                
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound], completionHandler: { (granted, _) in
                    completion(granted)
                })
                
            case .denied, .provisional, .ephemeral: // 책에는 ephemeral이 없어서 그냥 여기 추가함. ios 14에 추가된 것 같다.
                completion(false)
            }
        }
    }
}

extension Alarm {
    static let notificationCategoryId = "AlarmNotification"
    static let snoozeActionID = "snooze"
}
