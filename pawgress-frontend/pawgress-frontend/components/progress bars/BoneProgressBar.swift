//
//  BoneProgressBar.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-13.
//

import SwiftUI

struct BoneProgressBar: View {
     let progress: Double // 0.0 to 1.0
     let boneCount: Int = 5
     var boneColor: Color = .gray.opacity(0.3)
     var fillColor: Color = .blue
     
     private var filledBoneCount: Int {
         Int(round(progress * Double(boneCount)))
     }
     
     var body: some View {
         HStack(spacing: 20) {
             ForEach(0..<boneCount, id: \.self) { index in
                 Image(systemName: "pawprint.fill")
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .foregroundStyle(index < filledBoneCount ? fillColor : boneColor)
                     .rotationEffect(Angle.degrees(-30))
             }
         }
         .animation(.easeInOut(duration: 0.3), value: filledBoneCount)
     }
}



// MARK: - Example Usage
struct CV: View {
    @State private var progress: Double = 0.0
       
       var body: some View {
           VStack(spacing: 40) {
               Text("Bone Progress Bar")
                   .font(.title)
                   .fontWeight(.bold)
               
               BoneProgressBar(
                   progress: progress,
                   boneColor: Color.oliveGold.opacity(0.2),
                   fillColor: Color.oliveGold
               )
               .frame(height: 40)
               .padding(.horizontal, 40)
               
               Text("\(Int(progress * 100))%")
                   .font(.system(size: 32, weight: .medium))
               
               VStack(spacing: 20) {
                   Slider(value: $progress, in: 0...1)
                       .padding(.horizontal)
                   
                   HStack(spacing: 15) {
                       Button("Empty") {
                           progress = 0
                       }
                       .buttonStyle(.bordered)
                       
                       Button("40%") {
                           progress = 0.4
                       }
                       .buttonStyle(.bordered)
                       
                       Button("50%") {
                           progress = 0.5
                       }
                       .buttonStyle(.bordered)
                       
                       Button("Full") {
                           progress = 1.0
                       }
                       .buttonStyle(.bordered)
                   }
               }
           }
           .padding()
       }
}

// MARK: - Preview
#Preview {
    CV()
}
