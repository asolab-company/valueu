import SwiftUI

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

enum Device {
    static var isSmall: Bool {
        UIScreen.main.bounds.height < 700
    }

    static var isMedium: Bool {
        UIScreen.main.bounds.height >= 700 && UIScreen.main.bounds.height < 850
    }

    static var isLarge: Bool {
        UIScreen.main.bounds.height >= 850
    }
}
