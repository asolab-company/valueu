import SwiftUI

struct LoadingView: View {
    var onFinish: () -> Void
    @State private var progress: CGFloat = 0.0
    @State private var isFinished = false
    @State private var timer: Timer? = nil

    private let duration: Double = 1.5

    var body: some View {
        ZStack {

            VStack(spacing: 10) {
                Spacer()
                Text("\(Int(progress * 100))%")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .monospacedDigit()

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(hex: "1196FD"))
                            .frame(height: 8)

                        Capsule()
                            .fill(Color.white)
                            .frame(width: geo.size.width * progress, height: 8)
                    }
                }
                .frame(height: 5)
            }
            .padding(.horizontal, 80)
            .padding(.bottom, 30)
        }
        .background(
            ZStack {
                Color(hex: "000C34")
                    .ignoresSafeArea()
                Image("loading")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }

        )
        .onAppear {
            startProgress()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func startProgress() {
        progress = 0
        timer?.invalidate()

        let stepCount = 100
        let interval = duration / Double(stepCount)
        var tick = 0

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true)
        { t in
            tick += 1
            progress = min(1.0, CGFloat(tick) / CGFloat(stepCount))

            if tick >= stepCount {
                t.invalidate()
                isFinished = true
                onFinish()
            }
        }

        RunLoop.main.add(timer!, forMode: .common)
    }
}

#Preview {
    LoadingView {
    }

}
