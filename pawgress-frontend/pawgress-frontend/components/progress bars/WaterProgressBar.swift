import SwiftUI

struct WaterProgressBar: View {
    var progress: Double // 0.0 to 1.0
    var emptyColor: Color = .blue.opacity(0.2)
    var fillColor: Color = .blue.opacity(0.5)
    var waveHeight: CGFloat = 3
    var waveFrequency: CGFloat = 2
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background wave (empty)
                WaveBarShape(
                    waveHeight: waveHeight,
                    frequency: waveFrequency
                )
                .stroke(emptyColor, lineWidth: 8)
                
                // Filled wave
                WaveBarShape(
                    waveHeight: waveHeight,
                    frequency: waveFrequency
                )
                .trim(from: 0, to: progress)
                .stroke(fillColor, lineWidth: 8)
                .animation(.easeInOut(duration: 0.5), value: progress)
            }
        }
    }
}

struct WaveBarShape: Shape {
    var waveHeight: CGFloat
    var frequency: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let midY = rect.midY
        let points = 100
        
        path.move(to: CGPoint(x: 0, y: midY))
        
        for i in 0...points {
            let x = width * CGFloat(i) / CGFloat(points)
            let relativeX = CGFloat(i) / CGFloat(points)
            let sine = sin(relativeX * .pi * 2 * frequency)
            let y = midY + sine * waveHeight
            
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return path
    }
}

// MARK: - Example Usage
struct CVV: View {
    @State private var progress: Double = 0.0
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Water Wave Progress Bar")
                .font(.title)
                .fontWeight(.bold)
            
            WaterProgressBar(
                progress: progress,
                emptyColor: .cyan.opacity(0.3),
                fillColor: .cyan,
                waveHeight: 15,
                waveFrequency: 3
            )
            .frame(height: 60)
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
                    
                    Button("25%") {
                        progress = 0.25
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
    CVV()
}
