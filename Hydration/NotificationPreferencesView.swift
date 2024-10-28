//
//  NotificationPreferencesView.swift
//  Hydration
//
//  Created by Shamam Alkafri on 27/10/2024.
//

import SwiftUI
import UserNotifications

struct NotificationPreferencesView: View {
    @ObservedObject var viewModel: HydrationViewModel
    @State private var selectedInterval = "15 Mins"
    @State private var startHour = Date()
    @State private var endHour = Date()
    @State private var isAMStart = true
    @State private var isAMEnd = true
    @State private var navigateToWaterTracker = false

    let intervals = ["15 Mins", "30 Mins", "60 Mins", "90 Mins", "2 Hours", "3 Hours", "4 Hours", "5 Hours"]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Notification Preferences")
                .font(.system(size: 24, weight: .bold))
                .padding(.horizontal, 20)
                .padding(.top, 40)
            
            Text("The start and End hour")
                .font(.system(size: 18, weight: .bold))
                .padding(.top, 20)
                .padding(.horizontal, 20)
            
            Text("Specify the start and end time to receive notifications")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
                .padding(.top, 5)
                .padding(.bottom, 5)
            
            VStack(spacing: 0) {
                HStack {
                    Text("Start hour")
                        .font(.system(size: 18))
                        .padding(.leading, 4)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    DatePicker("", selection: $startHour, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .frame(width: 80, height: 35)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: startHour) { newValue in
                            isAMStart = Calendar.current.component(.hour, from: newValue) < 12
                        }
                    
                    Picker("", selection: $isAMStart) {
                        Text("AM").tag(true)
                        Text("PM").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 80)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                
                Divider()
                    .padding(.horizontal, 20)
                
                HStack {
                    Text("End hour")
                        .font(.system(size: 18))
                        .padding(.leading, 4)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    DatePicker("", selection: $endHour, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .frame(width: 80, height: 35)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: endHour) { newValue in
                            isAMEnd = Calendar.current.component(.hour, from: newValue) < 12
                        }
                    
                    Picker("", selection: $isAMEnd) {
                        Text("AM").tag(true)
                        Text("PM").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 80)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
            }
            .background(Color(UIColor.systemGray6))
            .cornerRadius(2)
            .padding(.horizontal, 20)
            .padding(.top, 30)
            .padding(.bottom, 30)
            
            Text("Notification Interval")
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 15)
                .padding(.horizontal, 20)
            
            Text("How often would you like to receive notifications within the specified time interval")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
                .padding(.top, 1)
                .padding(.bottom, 5)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                ForEach(intervals, id: \.self) { interval in
                    Button(action: {
                        selectedInterval = interval
                    }) {
                        VStack {
                            Text(interval.split(separator: " ")[0])
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(selectedInterval == interval ? .white : .cyan)
                            
                            Text(interval.split(separator: " ")[1])
                                .font(.system(size: 14))
                                .foregroundColor(selectedInterval == interval ? .white : .black)
                        }
                        .frame(width: 80, height: 80)
                        .background(selectedInterval == interval ? Color.cyan : Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 30)

            Button(action: {
                viewModel.notificationSettings = NotificationSettings(
                    startHour: startHour,
                    endHour: endHour,
                    interval: NotificationSettings.intervalToSeconds(selectedInterval)
                )
                viewModel.scheduleNotifications()
                navigateToWaterTracker = true
            }) {
                Text("Start")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            .padding(.top, 30)
            .background(
                NavigationLink(
                    destination: WaterTrackerView(viewModel: viewModel),
                    isActive: $navigateToWaterTracker
                ) { EmptyView() }
            )
            
            Spacer()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct NotificationPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationPreferencesView(viewModel: HydrationViewModel(bodyWeight: 70))
    }
}


