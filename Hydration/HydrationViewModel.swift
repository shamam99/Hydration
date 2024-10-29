//
//  HydrationViewModel.swift
//  Hydration
//
//  Created by Shamam Alkafri on 27/10/2024.
import Foundation
import UserNotifications
import SwiftUI

@MainActor
class HydrationViewModel: ObservableObject {
    @Published var hydrationData: HydrationData
    @Published var notificationSettings: NotificationSettings
    @AppStorage("currentIntake") var storedIntake: Double = 0.0

    init(bodyWeight: Double) {
        let initialHydrationData = HydrationData(
            bodyWeight: bodyWeight,
            currentIntake: UserDefaults.standard.double(forKey: "currentIntake")
        )
        let initialNotificationSettings = NotificationSettings(
            startHour: Date(),
            endHour: Date().addingTimeInterval(8 * 3600),
            interval: 5
        )

        self.hydrationData = initialHydrationData
        self.notificationSettings = initialNotificationSettings

        requestNotificationPermission()
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    func increaseIntake() {
        hydrationData.currentIntake += 0.1
        storedIntake = hydrationData.currentIntake
    }

    func decreaseIntake() {
        hydrationData.currentIntake = max(0, hydrationData.currentIntake - 0.1)
        storedIntake = hydrationData.currentIntake
    }

    func scheduleNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()

        print("Scheduling notifications...")

        var currentNotificationTime = notificationSettings.startHour
        while currentNotificationTime < notificationSettings.endHour {
            let content = UNMutableNotificationContent()
            content.sound = .default

            if hydrationData.currentIntake == 0 {
                content.title = "Reminder Notification"
                content.body = "It's time to hydrate. Take a sip to stay on track!"
                content.categoryIdentifier = "reminderNotification"
            } else if hydrationData.currentIntake < hydrationData.targetIntake / 2 {
                content.title = "Motivational Notification"
                content.body = "Keep going! Each sip brings you closer to your goal."
                content.categoryIdentifier = "motivationalNotification"
            } else if hydrationData.currentIntake < hydrationData.targetIntake {
                content.title = "Achievement Notification"
                content.body = "Almost there! A few more sips to reach your goal."
                content.categoryIdentifier = "achievementNotification"
            } else {
                print("Target intake reached, stopping notification scheduling.")
                break
            }

            let triggerDate = Calendar.current.dateComponents([.hour, .minute, .second], from: currentNotificationTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error adding notification request: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled for \(currentNotificationTime)")
                }
            }

            currentNotificationTime = currentNotificationTime.addingTimeInterval(notificationSettings.interval)
            print("Next notification scheduled at: \(currentNotificationTime)")
        }
        
        notificationCenter.getPendingNotificationRequests { requests in
            print("Scheduled notifications count: \(requests.count)")
            for request in requests {
                print("Scheduled: \(request.identifier), Trigger: \(String(describing: request.trigger))")
            }
        }
    }
}
