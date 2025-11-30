#  BubblePop Game  

Project Duration: Mar 2025

An interactive iOS game built with Swift and Xcode.  
Players pop randomly spawning bubbles within a time limit to achieve the highest score possible.  
Features include real-time animations, scoring logic, combo bonuses, UI transitions, configurable settings, and persistent high-score storage.

##  Game Overview

BubblePop is a fast-paced tapping game where colorful bubbles appear on the screen at random positions.  
Each bubble has different point values and probabilities.  
Players score by tapping the bubbles before they disappear, with bonus multipliers for combo pops.

##  Features

###  Core Gameplay
- Bubbles appear at random screen locations  
- No overlapping bubbles  
- Tap to pop & score points  
- Different bubble types with different values:
  - Red (1)
  - Pink (2)
  - Green (5)
  - Blue (8)
  - Black (10)

###  Timer System
- Countdown timer displayed on screen  
- Game ends automatically when time reaches zero  
- Smooth UI updates every second  

###  Scoring System
- Live score display  
- Combo multiplier for consecutive bubbles of the same color  
- Ensures balanced and fun scoring progression  

###  Configurable Settings
- Adjustable game duration  
- Adjustable maximum bubble count  
- Settings are validated and stored locally  

###  High Score Tracking
- Stores player names and scores  
- Displays top results in a leaderboard view  
- Uses persistent local storage (UserDefaults)

## Tech Stack
- Swift 5
- Xcode
- UIKit / SwiftUI UI components
- UserDefaults (persistent data storage)
- Timer API
- Randomization utilities for bubble generation

## How to Run

### 1.Clone this repository:
```bash
git clone https://github.com/Jasmine709/BubblePop-Game.git
```
### 2.Open the project in Xcode
### 3.Run on an iPhone simulator or physical iOS device
