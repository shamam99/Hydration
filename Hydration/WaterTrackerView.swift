//
//  WaterTrackerView.swift
//  Hydration
//
//  Created by Shamam Alkafri on 27/10/2024.
//

import SwiftUI

struct WaterTrackerView: View {
    @ObservedObject var viewModel: HydrationViewModel

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Today's Water Intake")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Text("\(viewModel.formattedIntake()) liter / \(String(format: "%.1f", viewModel.hydrationData.targetIntake)) liter")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(viewModel.hydrationData.currentIntake >= viewModel.hydrationData.targetIntake ? .green : .black)
                        .padding(.top, 1)
                }
                Spacer()
            }
            .padding(.leading, 10)
            .padding(.top, 50)
            
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(Color(UIColor.systemGray6), lineWidth: 30)
                    .frame(width: 320, height: 320)
                
                Circle()
                    .trim(from: 0, to: CGFloat(viewModel.hydrationData.currentIntake / viewModel.hydrationData.targetIntake))
                    .stroke(viewModel.hydrationData.currentIntake >= viewModel.hydrationData.targetIntake ? Color.green : Color.cyan, lineWidth: 30)
                    .frame(width: 320, height: 320)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.6), value: viewModel.hydrationData.currentIntake)
                
                if viewModel.hydrationData.currentIntake < viewModel.hydrationData.targetIntake {
                    Circle()
                        .fill(Color.cyan)
                        .frame(width: 30, height: 30)
                        .offset(y: -160)
                }
                
                viewModel.getIconForIntake()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.yellow)
                    .padding()
            }
            .padding(.top, 40)
            .padding(.bottom, 40)
            
            Text("\(String(format: "%.1f", viewModel.hydrationData.currentIntake)) L")
                .font(.system(size: 26, weight: .bold))
                .padding(.top, 20)
                .padding(.vertical, 20)
            
            HStack(spacing: 0) {
                Button(action: {
                    viewModel.decreaseIntake() // Call decreaseIntake method directly on the viewModel
                }) {
                    Text("-")
                        .font(.system(size: 30))
                        .frame(width: 50, height: 40)
                        .foregroundColor(.black)
                }
                
                Divider()
                    .frame(height: 20)
                    .background(Color.gray)
                    .padding(.vertical, 10)
                
                Button(action: {
                    viewModel.increaseIntake() 
                }) {
                    Text("+")
                        .font(.system(size: 30))
                        .frame(width: 50, height: 40)
                        .foregroundColor(.black)
                }
            }
            .frame(width: 120, height: 40)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .padding(.bottom, 40)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

extension HydrationViewModel {
    func formattedIntake() -> String {
        return String(format: "%.1f", max(0.0, hydrationData.currentIntake))
    }

    func getIconForIntake() -> Image {
        if hydrationData.currentIntake == 0 {
            return Image(systemName: "zzz")
        } else if hydrationData.currentIntake < 1.0 {
            return Image(systemName: "tortoise.fill")
        } else if hydrationData.currentIntake < hydrationData.targetIntake {
            return Image(systemName: "hare.fill")
        } else {
            return Image(systemName: "hands.clap.fill")
        }
    }
}

struct WaterTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        WaterTrackerView(viewModel: HydrationViewModel(bodyWeight: 70))
    }
}



