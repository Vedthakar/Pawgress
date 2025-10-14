//
//  PawPrintsPattern.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-14.
//

import SwiftUI

struct PawPrintsPattern: View {
    let positions: [(x: CGFloat, y: CGFloat, size: CGFloat, rotation: Double)] = [
        (0.05, 0.06, 26, -12),
        (0.10, 0.14, 24, 10),
        (0.15, 0.22, 28, -20),
        (0.20, 0.10, 25, 15),
        
        (0.25, 0.18, 27, -8),
        (0.30, 0.28, 23, 18),
        (0.35, 0.08, 29, -15),
        (0.40, 0.16, 25, 12),
        
        (0.45, 0.26, 24, -10),
        (0.50, 0.12, 28, 20),
        (0.55, 0.30, 22, -18),
        (0.60, 0.20, 27, 16),
        
        (0.65, 0.34, 25, -14),
        (0.70, 0.15, 26, 22),
        (0.75, 0.24, 23, -16),
        (0.80, 0.32, 28, 10),
        
        (0.85, 0.18, 25, -22),
        (0.90, 0.26, 27, 14),
        (0.95, 0.10, 24, -10),
        (0.98, 0.40, 29, 18)
    ]

    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<positions.count, id: \.self) { index in
                let pos = positions[index]
                Image(systemName: "pawprint.fill")
                    .font(.system(size: pos.size))
                    .foregroundColor(Color.oliveGold)
                    .position(
                        x: geometry.size.width * pos.x,
                        y: geometry.size.height * pos.y
                    )
                    .rotationEffect(.degrees(pos.rotation))
            }
        }
    }
}
