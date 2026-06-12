import SwiftUI

struct ContentView: View {
    // Demo mode: a 25:00 focus session compressed into a 14 second sweep
    private let demoDuration: Double = 75
    private let sessionMinutes: Double = 25
    @State private var start = Date()

    var body: some View {
        TimelineView(.animation) { context in
            let t = min(1.0, context.date.timeIntervalSince(start) / demoDuration)
            ZStack {
                LinearGradient(colors: [Color(red: 0.03, green: 0.05, blue: 0.10),
                                        Color(red: 0.05, green: 0.08, blue: 0.16)],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                ForEach(0..<24, id: \.self) { i in
                    Circle()
                        .fill(Color.cyan.opacity(0.10))
                        .frame(width: 5, height: 5)
                        .offset(y: -CGFloat(160 + (i % 5) * 38))
                        .rotationEffect(.degrees(Double(i) / 24 * 360 + t * 70))
                        .blur(radius: 0.5)
                }

                VStack(spacing: 36) {
                    VStack(spacing: 8) {
                        Text("ORBIT")
                            .font(.system(size: 34, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .kerning(10)
                        Text("FOCUS SESSION")
                            .font(.system(size: 13, weight: .semibold, design: .monospaced))
                            .foregroundStyle(Color.cyan.opacity(0.7))
                            .kerning(4)
                    }

                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.06), lineWidth: 18)
                        Circle()
                            .trim(from: 0, to: t)
                            .stroke(
                                AngularGradient(colors: [Color.cyan, Color(red: 0.3, green: 0.5, blue: 1.0), Color.cyan],
                                                center: .center),
                                style: StrokeStyle(lineWidth: 18, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .shadow(color: .cyan.opacity(0.8), radius: 14)

                        VStack(spacing: 6) {
                            if t >= 1.0 {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 64))
                                    .foregroundStyle(Color.green)
                                    .transition(.scale)
                                Text("session complete")
                                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                                    .foregroundStyle(.white.opacity(0.8))
                            } else {
                                Text(timeString(t))
                                    .font(.system(size: 58, weight: .bold, design: .monospaced))
                                    .foregroundStyle(.white)
                                    .contentTransition(.numericText())
                                Text("stay with it")
                                    .font(.system(size: 15, weight: .regular, design: .monospaced))
                                    .foregroundStyle(Color.cyan.opacity(0.65))
                            }
                        }
                    }
                    .frame(width: 300, height: 300)

                    HStack(spacing: 14) {
                        Capsule()
                            .fill(Color.white.opacity(0.07))
                            .overlay(Text("pause").font(.system(size: 15, weight: .semibold)).foregroundStyle(.white.opacity(0.85)))
                            .frame(width: 130, height: 48)
                        Capsule()
                            .fill(Color.cyan.opacity(0.85))
                            .overlay(Text("end early").font(.system(size: 15, weight: .bold)).foregroundStyle(Color(red: 0.02, green: 0.06, blue: 0.12)))
                            .frame(width: 130, height: 48)
                    }
                    .padding(.top, 8)
                }
            }
        }
    }

    private func timeString(_ t: Double) -> String {
        let remaining = max(0, sessionMinutes * 60 * (1 - t))
        return String(format: "%02d:%02d", Int(remaining) / 60, Int(remaining) % 60)
    }
}

