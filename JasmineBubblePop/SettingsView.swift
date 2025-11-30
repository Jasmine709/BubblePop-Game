//
//  SettingsView.swift
//  JasmineBubblePop
//
//  Created by APPLE on 2025/4/1.
//

import SwiftUI

// Indicate warning
enum ActiveAlert {
    case timeWarning
    case bubbleWarning
    case nameWarning
}

struct SettingsView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    @State private var countdownValue: Double = 60 // default 60 seconds
    @State private var bubbleValue: Double = 15 // default 15 bubbles

    @State private var activeAlert: ActiveAlert? = nil
    @State private var showAlert = false
    @State private var navigateToGame = false // 新增跳转状态

    var body: some View {
        NavigationStack {
            VStack {
                Label("Settings", systemImage:"")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding()

                // Enter player name
                Text("Enter Your Name:")
                    .font(.title2)
                    .padding(.top)
                TextField("Name", text: $settingsViewModel.playerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 30)

                // Set time
                Text("Game Time (Seconds)")
                    .font(.title2)
                    .padding(.top)
                if #available(iOS 17.0, *) {
                    Slider(value: $countdownValue, in: 0...60, step: 1)
                        .padding(.horizontal)
                        .onChange(of: countdownValue) { _, newValue in
                            if newValue == 0 {
                                activeAlert = .timeWarning
                                showAlert = true
                            }
                        }
                } else {
                    Slider(value: $countdownValue, in: 0...60, step: 1)
                        .padding(.horizontal)
                        .onChange(of: countdownValue) { newValue in
                            if newValue == 0 {
                                activeAlert = .timeWarning
                                showAlert = true
                            }
                        }
                }
                Text("\(Int(countdownValue)) seconds")
                    .padding(.bottom, 30)

                // Set number of bubbles
                Text("Max Number of Bubbles")
                    .font(.title2)
                    .padding(.top)
                if #available(iOS 17.0, *) {
                    Slider(value: $bubbleValue, in: 0...15, step: 1)
                        .padding(.horizontal)
                        .onChange(of: bubbleValue) { _, newValue in
                            if newValue == 0 {
                                activeAlert = .bubbleWarning
                                showAlert = true
                            }
                        }
                } else {
                    Slider(value: $bubbleValue, in: 0...15, step: 1)
                        .padding(.horizontal)
                        .onChange(of: bubbleValue) { newValue in
                            if newValue == 0 {
                                activeAlert = .bubbleWarning
                                showAlert = true
                            }
                        }
                }
                Text("\(Int(bubbleValue)) bubbles")
                    .padding(.bottom, 30)

                // Start Game button
                Button(action: {
                    if settingsViewModel.playerName.trimmingCharacters(in: .whitespaces).isEmpty {
                        activeAlert = .nameWarning
                        showAlert = true
                    } else {
                        navigateToGame = true
                    }
                }) {
                    Text("Start Game!")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)
                        )
                        .cornerRadius(15)
                }
                .padding(.top, 40)

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.pink.opacity(0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .alert(isPresented: $showAlert) {
                switch activeAlert {
                case .timeWarning:
                    return Alert(
                        title: Text("Warning"),
                        message: Text("Game time is set to 0 seconds. The game may end immediately."),
                        dismissButton: .default(Text("OK"))
                    )
                case .bubbleWarning:
                    return Alert(
                        title: Text("Warning"),
                        message: Text("No bubbles will be displayed if the number is set to 0."),
                        dismissButton: .default(Text("OK"))
                    )
                case .nameWarning:
                    return Alert(
                        title: Text("Warning"),
                        message: Text("Please enter your name before starting the game."),
                        dismissButton: .default(Text("OK"))
                    )
                case .none:
                    return Alert(title: Text("Error"))
                }
            }
            .navigationDestination(isPresented: $navigateToGame) {
                GameView(settings: SettingsModel(name: settingsViewModel.playerName, time: Int(countdownValue), maxBubbles: Int(bubbleValue)))
            }
        }
    }
}

#Preview {
    SettingsView()
}
