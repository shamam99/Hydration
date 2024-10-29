//
//  HydrationData.swift
//  Hydration
//
//  Created by Shamam Alkafri on 27/10/2024.
//

import Foundation

struct HydrationData {
    var bodyWeight: Double
    var currentIntake: Double
    var targetIntake: Double {
        return bodyWeight * 0.03
    }
    
    init(bodyWeight: Double, currentIntake: Double = 0.0) {
        self.bodyWeight = bodyWeight
        self.currentIntake = currentIntake
    }
}

