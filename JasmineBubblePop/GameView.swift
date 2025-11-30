//
//  GameView.swift
//  JasmineBubblePop
//
//  Created by APPLE on 2025/4/1.
//

import SwiftUI

struct GameView: View {
    let settings: SettingsModel
    
    @State private var timeRemaining: Int
    @State private var score: Int = 0
    @State private var highScore: Int = 0
    @State private var bubbles: [Bubble] = []
    @State private var lastPoppedColor: Color? = nil
    @State private var comboCount: Int = 0
    
    @State private var showGameOver = false
    @State private var finalScore = 0
    @State private var navigateToHighScore = false
    
    @State private var scoreChangeText: String = ""
    @State private var showScoreChange: Bool = false
    @State private var comboText: String = ""
    @State private var showComboText: Bool = false
    
    @State private var countdownNumber: Int? = 3
    @State private var showCountdown = true

    init(settings: SettingsModel) {
        self.settings = settings
        _timeRemaining = State(initialValue: settings.time)
    }

    var body: some View {
        ZStack {
            VStack {
                // Display player name, score, high score, and timer
                HStack {
                    VStack(alignment: .leading) {
                        Text("Player: \(settings.name)")
                            .font(.title3)
                        Text("Score: \(score)")
                            .font(.title3)
                        Text("High Score: \(highScore)")
                            .font(.title3)
                    }
                    Spacer()
                    Text("Time: \(timeRemaining) s")
                        .font(.title2.bold())
                }
                .padding()
                
                Spacer()
                
                // Display bubbles
                ZStack {
                    ForEach(bubbles) { bubble in
                        ZStack {
                            Circle()
                                .fill(bubble.color)
                                .frame(width: bubble.size, height: bubble.size)
                                    
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.8), Color.clear]),
                                        center: .topLeading,
                                        startRadius: 5,
                                        endRadius: bubble.size / 1.5
                                    )
                                )
                                .frame(width: bubble.size, height: bubble.size)
                        }
                        .position(x: bubble.x, y: bubble.y)
                        .onTapGesture {
                            popBubble(bubble)
                        }
                    }
                }
                .clipped()
            }
            
            // Show animated score change
            if showScoreChange {
                Text(scoreChangeText)
                    .font(.largeTitle.bold())
                    .foregroundColor(.yellow)
                    .padding()
                    .cornerRadius(10)
                    .transition(.scale)
                    .zIndex(1)
                    .offset(y: -150)
            }
            
            // Show animated combo text
            if showComboText {
                Text(comboText)
                    .font(.title.bold())
                    .foregroundColor(.orange)
                    .padding(10)
                    .cornerRadius(10)
                    .transition(.scale)
                    .zIndex(1)
                    .offset(y: -200)
            }
            
            // Show countdown overlay
            if showCountdown {
                Text(countdownText())
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .transition(.opacity)
                    .zIndex(2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.pink.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onAppear {
            loadHighScore()
            startCountdown()
        }
        .navigationDestination(isPresented: $navigateToHighScore) {
            HighScore()
        }
        .alert(isPresented: $showGameOver) {
            Alert(
                title: Text("Game Over"),
                message: Text("Your final score is \(finalScore)"),
                dismissButton: .default(Text("View High Score")) {
                    navigateToHighScore = true
                }
            )
        }
    }
    
    // Start flashing countdown: 3, 2, 1, Start!
    private func startCountdown() {
        countdownNumber = 3
        showCountdown = true
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if let number = countdownNumber {
                if number > 1 {
                    countdownNumber! -= 1
                } else if number == 1 {
                    countdownNumber = 0
                } else {
                    timer.invalidate()
                    withAnimation {
                        showCountdown = false
                    }
                    // After countdown, start game
                    refreshBubbles()
                    startGame()
                }
            }
        }
    }
    
    // Generate text to display for countdown
    private func countdownText() -> String {
        if let number = countdownNumber {
            if number > 0 {
                return "\(number)"
            } else {
                return "Start!"
            }
        } else {
            return ""
        }
    }
    
    // Start the game and countdown timer
    private func startGame() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            timeRemaining -= 1
            if timeRemaining > 0 {
                refreshBubbles()
            } else {
                timer.invalidate()
                finalScore = score
                saveScore(name: settings.name, score: score)
                showGameOver = true
            }
        }
    }
    
    // Generate new bubbles without overlap
    private func refreshBubbles() {
        bubbles.removeAll()
        let numberOfBubbles = Int.random(in: 0...settings.maxBubbles)
        var newBubbles: [Bubble] = []
        let bubbleSize: CGFloat = 60
        let maxAttempts = 100
        
        let safeTop: CGFloat = 50
        let safeBottom: CGFloat = 300
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        for _ in 0..<numberOfBubbles {
            var attempt = 0
            var validPosition = false
            var newBubble: Bubble!

            while !validPosition && attempt < maxAttempts {
                attempt += 1
                let randomX = CGFloat.random(in: bubbleSize/2...(screenWidth - bubbleSize/2))
                let randomY = CGFloat.random(in: safeTop + bubbleSize/2...(screenHeight - safeBottom - bubbleSize/2))
                
                let (color, points) = generateRandomColorAndPoints()
                
                let candidate = Bubble(
                    x: randomX,
                    y: randomY,
                    color: color,
                    size: bubbleSize,
                    points: points
                )
                
                validPosition = true
                for existing in newBubbles {
                    let distance = sqrt(pow(candidate.x - existing.x, 2) + pow(candidate.y - existing.y, 2))
                    if distance < bubbleSize {
                        validPosition = false
                        break
                    }
                }
                if validPosition {
                    newBubble = candidate
                }
            }
            if let bubble = newBubble {
                newBubbles.append(bubble)
            }
        }
        bubbles = newBubbles
    }
    
    // Handle bubble pop, scoring, combo, and high score updating
    private func popBubble(_ bubble: Bubble) {
        if let index = bubbles.firstIndex(where: { $0.id == bubble.id }) {
            bubbles.remove(at: index)
            
            var gainedPoints = bubble.points
            
            if let lastColor = lastPoppedColor, lastColor == bubble.color {
                // 1.5x points for consecutive same color bubble
                gainedPoints = Int(round(Double(gainedPoints) * 1.5))
                comboCount += 1
            } else {
                // Reset combo if color is different
                comboCount = 0
            }
            
            score += gainedPoints
            lastPoppedColor = bubble.color
            
            // Update high score if needed
            if score > highScore {
                highScore = score
            }
            
            // Show score change animation
            scoreChangeText = "+\(gainedPoints)"
            withAnimation(.easeOut(duration: 0.5)) {
                showScoreChange = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation {
                    showScoreChange = false
                }
            }
            
            // Show combo animation if combo count > 0
            if comboCount > 0 {
                comboText = generateComboText(combo: comboCount + 1)
                withAnimation(.easeOut(duration: 0.5)) {
                    showComboText = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation {
                        showComboText = false
                    }
                }
            }
        }
    }
    
    // Generate random bubble color and points
    private func generateRandomColorAndPoints() -> (Color, Int) {
        let random = Int.random(in: 1...100)
        switch random {
        case 1...40:
            return (.red, 1)
        case 41...70:
            return (.pink, 2)
        case 71...85:
            return (.green, 5)
        case 86...95:
            return (.blue, 8)
        default:
            return (.black, 10)
        }
    }
    
    // Save the final score to UserDefaults
    private func saveScore(name: String, score: Int) {
        var currentScores = UserDefaults.standard.array(forKey: "HighScores") as? [[String: Any]] ?? []
        currentScores.append(["name": name, "score": score])
        UserDefaults.standard.set(currentScores, forKey: "HighScores")
    }
    
    // Load the highest score from saved records
    private func loadHighScore() {
        if let savedScores = UserDefaults.standard.array(forKey: "HighScores") as? [[String: Any]] {
            let allScores = savedScores.compactMap { dict in
                dict["score"] as? Int
            }
            highScore = allScores.max() ?? 0
        }
    }
    
    // Generate combo text based on combo count
    private func generateComboText(combo: Int) -> String {
        switch combo {
        case 2:
            return "Combo x2!"
        case 3:
            return "Combo x3! Great!"
        case 4:
            return "Combo x4! Awesome!"
        case 5:
            return "Combo x5! Amazing!"
        default:
            return "Combo x\(combo)! Unstoppable!"
        }
    }
}

#Preview {
    GameView(settings: SettingsModel(name: "Test", time: 10, maxBubbles: 15))
}
