//
//  GameModel.swift
//  JasmineBubblePop
//
//  Created by APPLE on 2025/4/27.
//

import SwiftUI

struct Bubble: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var color: Color
    var size: CGFloat
    var points: Int
    var isPopped: Bool = false
}
