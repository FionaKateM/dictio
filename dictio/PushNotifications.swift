//
//  PushNotifications.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 12/03/2023.
//

import Foundation
import UserNotifications

func addNotification() {
    let center = UNUserNotificationCenter.current()
    let addRequest = {
        let content = UNMutableNotificationContent()
        content.title = "The daily game is ready"
        content.subtitle = "Don't lose your streak!"
        content.sound = UNNotificationSound.default
        
        
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    center.getNotificationSettings { settings in
        if settings.authorizationStatus == .authorized {
            addRequest()
        } else {
            center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    addRequest()
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
