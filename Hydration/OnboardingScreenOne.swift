//
//  OnboardingScreenOne.swift
//  Hydration
//
//  Created by Shamam Alkafri on 27/10/2024.
//

import SwiftUI

struct OnboardingScreenOne: View {
    @State private var bodyWeight: String = ""
    @State private var navigateToNotificationScreen = false
    @State private var showAlert = false
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Spacer(minLength: 2)
                
                Image(systemName: "drop.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50, alignment: .leading)
                    .foregroundColor(.cyan)
                    .padding(.leading, 25)
                
                Text("Hydrate")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.top, 10)
                    .padding(.leading, 20)
                
                Text("Start with Hydrate to record and track your water intake daily based on your needs and stay hydrated")
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                
                HStack {
                    Text("Body weight")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    TextField("", text: $bodyWeight)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(width: 100, height: 40)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    
                    if !bodyWeight.isEmpty {
                        Button(action: {
                            bodyWeight = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 16)
                
                Spacer()

                NavigationLink(
                    destination: NotificationPreferencesView(viewModel: HydrationViewModel(bodyWeight: Double(bodyWeight) ?? 0.0)),
                    isActive: $navigateToNotificationScreen
                ) {
                    EmptyView()
                }

                Button(action: {
                    if bodyWeight.isEmpty {
                        showAlert = true
                    } else {
                        UserDefaults.standard.set(Double(bodyWeight), forKey: "userBodyWeight")
                        hasCompletedOnboarding = true // Mark onboarding as complete
                        navigateToNotificationScreen = true
                    }
                }) {
                    Text("Calculate Now")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cyan)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                }
                .padding(.bottom, 40)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Input Required"),
                        message: Text("Please enter your body weight before proceeding."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}


struct OnboardingScreenOne_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreenOne()
    }
}


