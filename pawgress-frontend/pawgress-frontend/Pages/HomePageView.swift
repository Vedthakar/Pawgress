//
//  HomePageView.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-13.
//

import SwiftUI

struct HomePageView: View {
    @State private var hearts: [HeartAnimation] = []
    @State private var hunger: Double = 0 //TODO: View model
    @State private var water: Double = 0 //TODO: View model
    var body: some View {
        VStack {
            //MARK: Image of pet
            Image(.pawgressMainPet)
                .resizable()
                .frame(width: 300, height: 300)
                .onTapGesture(perform: {showHearts()})
                .overlay(
                    ZStack {
                        ForEach(hearts) { heart in
                            Image(systemName: "heart.fill")
                                .foregroundStyle(Color.coralPink.opacity(0.6))
                                .font(.system(size: 20))
                                .rotationEffect(.degrees(heart.rotation))
                                .offset(
                                    x: heart.isVisible ? heart.xOffset : 0,
                                    y: heart.isVisible ? heart.yOffset : 0
                                )
                                .opacity(heart.isVisible ? 0 : 1)
                                .animation(.easeOut(duration: 1.5), value: heart.isVisible)
                        }
                    }
                )
            Spacer()
            
            //MARK: Progress bars
            VStack(alignment:.leading) {
                HStack(spacing: 40) {
                    PercentageMessage(value: hunger)
                        .frame(width: 70)
                    
                    BoneProgressBar(
                        progress: hunger,
                        boneColor: Color.coralPink.opacity(0.2),
                        fillColor: Color.coralPink.opacity(0.7)
                    )
                    .frame(width: 200, height: 25)
                }
                
                HStack(alignment: .center, spacing: 20) {
                    PercentageMessage(value: water)
                        .frame(width: 70)
                    
                    WaterProgressBar(
                        progress: water,
                        emptyColor: Color.coralPink.opacity(0.1),
                        fillColor: Color.coralPink.opacity(0.3),
                        waveHeight: 6,
                        waveFrequency: 2
                    )
                    .frame(width: 230, height: 25)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.ivoryWhite.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.coralPink, lineWidth: 2)
                    )
            )
            .padding(.horizontal, 30)
            
            //MARK: Buttons to navigate to study & automate task
            //TODO: Route to page soon, create those pages
            HStack(alignment: .center, spacing: 10) {
                IconButton(action: {print("Balls")}, text: "tasks", image: .pawgressTasks)
                IconButton(action: {print("Balls")}, text: "study", image: .pawgressStudy)
            }
            .padding(20)
        
                
            //MARK: Testing only
            HStack {
                Text("sliders for testing only")
                Slider(value: $hunger, in: 0...1)
                    .frame(width: 50, height: 10)
                Slider(value: $water, in: 0...1)
                    .frame(width: 50, height: 10)
            }
           
                
        
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ZStack(alignment: .bottom) {
                Color.lightCream
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        Spacer()
                        
                        UnevenRoundedRectangle(
                            topLeadingRadius: 60,
                            topTrailingRadius: 60
                        )
                        .stroke(Color.sunflower, lineWidth: 5)
                        .fill(Color.sunflowerSubtle)
                        .frame(height: geometry.size.height / 2.1)
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
                .ignoresSafeArea()
            }
        )
        .safeAreaInset(edge: .top) {
            NavTitleView()
        }
        .navigationBarHidden(true)

        
    }
    
    //TODO: Remove from here
    private func showHearts() {
        let heartCount = Int.random(in: 5...8)
        
        for _ in 0..<heartCount {
            let heart = HeartAnimation(
                id: UUID(),
                xOffset: CGFloat.random(in: -50...50),
                yOffset: CGFloat.random(in: -100...(-20)),
                rotation: Double.random(in: -30...30),
                scale: CGFloat.random(in: 0.5...1.2),
                isVisible: false
            )
            hearts.append(heart)
            
            // Animate
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                if let index = hearts.firstIndex(where: { $0.id == heart.id }) {
                    hearts[index].isVisible = true
                }
            }
            
            // Remove
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                hearts.removeAll { $0.id == heart.id }
            }
        }
    }
}


#Preview {
    HomePageView()
}
