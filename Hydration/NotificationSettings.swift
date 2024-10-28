//
//  NotificationSettings.swift
//  Hydration
//
//  Created by Shamam Alkafri on 27/10/2024.
//

import Foundation

struct NotificationSettings {
    var startHour: Date
    var endHour: Date
    var interval: TimeInterval
    
    init(startHour: Date, endHour: Date, interval: TimeInterval) {
        self.startHour = startHour
        self.endHour = endHour
        self.interval = interval
    }
    
    static func intervalToSeconds(_ interval: String) -> TimeInterval {
        switch interval {
        case "15 Mins": return 5
        case "30 Mins": return 30 * 60
        case "60 Mins": return 60 * 60
        case "90 Mins": return 90 * 60
        case "2 Hours": return 2 * 60 * 60
        case "3 Hours": return 3 * 60 * 60
        case "4 Hours": return 4 * 60 * 60
        case "5 Hours": return 5 * 60 * 60
        default: return 5 
        }
    }
}


