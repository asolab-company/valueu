import SwiftUI

struct OnboardingView: View {

    private let accent = Color(hex: "00CFA6")

    var onContinue: () -> Void = {}
    var body: some View {
        ZStack {

            VStack(spacing: 10) {

                Spacer()

                VStack(alignment: .leading, spacing: 20) {

                    Text(
                        "Gratitude List helps you focus on the positive side of life."
                    )
                    .foregroundColor(.white)
                    .font(
                        .system(
                            size: Device.isSmall ? 18 : 20,
                            weight: .bold
                        )
                    )
                    .multilineTextAlignment(.leading)

                    Text(
                        "Write down a few things you’re thankful for each day and see how your mindset starts to change — more peace, more happiness, more you."
                    )
                    .foregroundColor(.white)
                    .font(
                        .system(
                            size: Device.isSmall ? 14 : 16,
                            weight: .regular
                        )
                    )
                    .multilineTextAlignment(.leading)

                }
                .padding(.bottom)

                Button(action: { onContinue() }) {
                    ZStack {

                        HStack {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .bold))
                                .opacity(0)
                            Spacer()
                            Text("Continue")
                                .font(.system(size: 16, weight: .bold))

                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .bold))
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.bottom, Device.isSmall ? 0 : 10)
                TermsFooter()
                    .padding(.bottom)

            }
            .padding(.horizontal, 24)

        }.background(
            ZStack {
                Color(hex: "000C34")
                    .ignoresSafeArea()
                Image("onboard")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

            }

        )

    }

}

private struct TermsFooter: View {
    var body: some View {
        VStack(spacing: 2) {
            Text("By Proceeding You Accept")
                .foregroundColor(Color.init(hex: "FFFFFF"))
                .font(.footnote)

            HStack(spacing: 0) {
                Text("Our ")
                    .foregroundColor(Color.init(hex: "FFFFFF"))
                    .font(.footnote)

                Link("Terms Of Use", destination: Constants.termsOfUse)
                    .font(.footnote)
                    .foregroundColor(Color.init(hex: "1196FD"))
                    .underline()

                Text(" And ")
                    .foregroundColor(Color.init(hex: "FFFFFF"))
                    .font(.footnote)

                Link("Privacy Policy", destination: Constants.privacyPolicy)
                    .font(.footnote)
                    .foregroundColor(Color.init(hex: "1196FD"))
                    .underline()
            }
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }
}

extension Text {

    func link(_ url: URL) -> some View {
        Link(destination: url) { self }
    }
}

#Preview {
    OnboardingView {

    }

}
