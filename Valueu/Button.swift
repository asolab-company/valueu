import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var shadowColor: Color = Color(hex: "#4A0000")

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#FE0C24"),
                        Color(hex: "#980716"),
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(
                    color: shadowColor.opacity(
                        configuration.isPressed ? 0.6 : 1.0
                    ),
                    radius: 0,
                    x: 0,
                    y: configuration.isPressed ? 2 : 6
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        Color.white.opacity(
                            configuration.isPressed ? 0.25 : 0.15
                        ),
                        lineWidth: 1
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct GreenButtonStyle: ButtonStyle {
    var shadowColor: Color = Color(hex: "#2D5C1C")

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#93CF6E"),
                        Color(hex: "#5EA133"),
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(
                    color: shadowColor.opacity(
                        configuration.isPressed ? 0.6 : 1.0
                    ),
                    radius: 0,
                    x: 0,
                    y: configuration.isPressed ? 2 : 6
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        Color.white.opacity(
                            configuration.isPressed ? 0.25 : 0.15
                        ),
                        lineWidth: 1
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct PrimaryButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Button("Primary Button") {}
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal)
        }
        .padding()

        .previewLayout(.sizeThatFits)
    }
}
