import SwiftUI
import UIKit

struct ContentView: View {
    @State private var timeRemaining = 25 * 60
    @State private var timerActive = false
    @State private var timer: Timer?
    @State private var progress: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 30) {
            Image("FocusBuddyLogoTimer")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 150)
            // Text("Focus Buddy Timer")
            //     .font(.system(size: 50, weight: .black, design: .default))
            //     .italic()
            //     .foregroundStyle(
            //         LinearGradient(colors: [Color.blue, Color.black], startPoint: .leading, endPoint: .trailing)
            //     )
            //     .shadow(color: .black.opacity(0.7), radius: 6, x: 2, y: 2)
            
            Text("Stay Focused, Beat Procrastination!")
                .font(.headline)
                .foregroundColor(.gray)

            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(.gray)

                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(
                        AngularGradient(gradient: Gradient(colors: [.green, .yellow, .orange, .red]), center: .center),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.easeInOut(duration: 0.5), value: progress)

                Text(formattedTime())
                    .font(.system(size: 50, weight: .medium, design: .rounded))
                    .monospacedDigit()
            }
            .frame(width: 250, height: 250)

            Button(action: toggleTimer) {
                Text(timerActive ? "Detener" : "Iniciar")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .frame(width: 200)
                    .background(timerActive ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(radius: 10)
            }
            .scaleEffect(timerActive ? 1.1 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.5), value: timerActive)
        }
        .padding()
        .onAppear {
            updateProgress()
        }
    }

    func formattedTime() -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func toggleTimer() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        timerActive.toggle()

        if timerActive {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                    updateProgress()
                } else {
                    timer?.invalidate()
                    timerActive = false
                }
            }
        } else {
            timer?.invalidate()
        }
    }

    func updateProgress() {
        progress = CGFloat(timeRemaining) / CGFloat(25 * 60)
    }
}

#Preview {
    ContentView()
}
