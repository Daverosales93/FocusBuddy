import SwiftUI
import UIKit
import AudioToolbox

struct ContentView: View {
    @State private var timeRemaining = 25 * 60
    @State private var timerActive = false
    @State private var timer: Timer?
    @State private var progress: CGFloat = 1.0
    @State private var motivationalMessage = ""

    let messages = [
        "Stay Focused!", "Keep Going!", "You're Doing Great!", "Almost There!", "Well Done! Take a Break!"
    ]

    var body: some View {
        VStack(spacing: 30) {
            Image("FocusBuddyLogoTimer")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 150)

            Text(motivationalMessage)
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

            HStack(spacing: 20) {
                Button(action: toggleTimer) {
                    Text(timerActive ? "Stop" : "Start")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 150)
                        .background(timerActive ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                }
                .scaleEffect(timerActive ? 1.1 : 1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.5), value: timerActive)

                Button(action: resetTimer) {
                    Text("Reset")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 150)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                }
            }
        }
        .padding()
        .onAppear {
            updateProgress()
            updateMessage()
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
                    updateMessage()
                } else {
                    timer?.invalidate()
                    timerActive = false
                    motivationalMessage = "Session Complete! Well Done!"
                    playCompletionSound()
                }
            }
        } else {
            timer?.invalidate()
        }
    }

    func resetTimer() {
        timer?.invalidate()
        timeRemaining = 25 * 60
        timerActive = false
        updateProgress()
        updateMessage()
    }

    func updateProgress() {
        progress = CGFloat(timeRemaining) / CGFloat(25 * 60)
    }

    func updateMessage() {
        let index = max(0, messages.count - Int(Double(timeRemaining) / 60.0 / 5.0) - 1)
        motivationalMessage = messages[min(index, messages.count - 1)]
    }

    func playCompletionSound() {
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
        AudioServicesPlaySystemSound(1005)
    }
}

#Preview {
    ContentView()
}
