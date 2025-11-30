//
//  ContentView.swift
//  JasmineBubblePop
//
//  Created by APPLE on 2025/4/1.
//

import SwiftUI

struct ContentView: View {
    @State private var bounce = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Bubble Pop")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .green, .blue, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .white.opacity(0.8), radius: 10)
                    .shadow(color: .blue.opacity(0.3), radius: 20)
                    .shadow(color: .pink.opacity(0.2), radius: 30)
                    //change size of text
                    .scaleEffect(bounce ? 1.05 : 0.95)
                        .animation(
                            Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                            value: bounce
                        )
                        .onAppear {
                            bounce = true
                        }
                .padding(.bottom, 70)
                
                // Link to Setting swiftUI
                NavigationLink(
                    destination: SettingsView(),
                    label: {
                        Text("Play")
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(
                                LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)
                                    )
                                    .cornerRadius(15)
                    })
                .padding(.bottom, 30)
                
                // Link to GameView swiftUI
                NavigationLink(
                    destination: HighScore(),
                    label: {
                        Text("High Score")
                        .font(.title)
                    })
            }
            .padding()
            
            // background for entire screen
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.pink.opacity(0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}

#Preview {
    ContentView()
}
