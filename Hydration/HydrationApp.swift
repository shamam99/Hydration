//
//  HydrationApp.swift
//  Hydration
//
//  Created by Shamam Alkafri on 27/10/2024.
//

import SwiftUI

@main
struct HydrationApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                WaterTrackerView(viewModel: HydrationViewModel(bodyWeight: UserDefaults.standard.double(forKey: "userBodyWeight")))
            } else {
                OnboardingScreenOne()
            }
        }
    }
}


