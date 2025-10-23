import SwiftUI

struct SettingView: View {

    @Environment(\.openURL) private var openURL
    @State private var showShare = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .top) {

            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#0219DA"),
                    Color(hex: "#1299FE"),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .top)
            .frame(height: 50)

            VStack(spacing: 20) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Setting")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()

                    Image(systemName: "chevron.left")
                        .opacity(0)
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
                .padding(.bottom, 30)

                SettingsRow(
                    icon: "app_ic_share",
                    title: "Share app",
                    action: { showShare = true }
                )
                SettingsRow(
                    icon: "app_ic_terms",
                    title: "Terms and Conditions",
                    action: { openURL(Constants.termsOfUse) }
                )

                SettingsRow(
                    icon: "app_ic_privacy",
                    title: "Privacy",
                    action: { openURL(Constants.privacyPolicy) }
                )

                Spacer()

            }

        }
        .background(
            ZStack {
                Color(hex: "#1B1A1A")
                    .ignoresSafeArea()

                Image("app_bg_main")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
        )
        .sheet(isPresented: $showShare) {
            ShareSheet(items: Constants.shareItems)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void

    private let corner: CGFloat = 10

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(icon)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)

                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 24)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .fill(Color.init(hex: "000C34"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .stroke(Color.init(hex: "1196FD"), lineWidth: 1)
            )
            .contentShape(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
            )
        }
        .buttonStyle(ScaleCapsuleStyle())
        .padding(.horizontal, 26)
    }
}

private struct ScaleCapsuleStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .shadow(radius: configuration.isPressed ? 0 : 6, y: 2)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
    }
    func updateUIViewController(
        _ vc: UIActivityViewController,
        context: Context
    ) {}
}

#Preview {
    SettingView()
}
