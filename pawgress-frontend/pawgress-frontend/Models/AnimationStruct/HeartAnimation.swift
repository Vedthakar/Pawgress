//
//  HeartAnimation.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-14.
//

import Foundation
import CoreGraphics

// Heart animation data structure
struct HeartAnimation: Identifiable {
    let id: UUID
    let xOffset: CGFloat
    let yOffset: CGFloat
    let rotation: Double
    let scale: CGFloat
    var isVisible: Bool
}
