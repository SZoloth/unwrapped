import SwiftUI

/// Centralized soft pastel color palette used across the app.
enum Palette {
    // Core pastels
    static let pastelGreen = Color(hex: "#8FD5A6")
    static let blushPink   = Color(hex: "#F7C5CC")
    static let softPeach   = Color(hex: "#FFD7A8")
    static let lavender    = Color(hex: "#C9C3E6")
    static let skyBlue     = Color(hex: "#B8DDF4")
    static let warmCream   = Color(hex: "#FFF6E8")

    // Text / neutrals
    static let ink         = Color(hex: "#2B2B2B")
    static let inkSecondary = Color(hex: "#6B7280")

    // Convenience groupings
    static var background: Color { warmCream }
    static var accent: Color { pastelGreen }
}

// MARK: - Hex to Color helper
extension Color {
    /// Initialize a Color from hex string like "#RRGGBB" or "#RRGGBBAA".
    init(hex: String) {
        let r, g, b, a: Double
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") { hexString.removeFirst() }

        var value: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&value)

        switch hexString.count {
        case 6: // RRGGBB
            r = Double((value & 0xFF0000) >> 16) / 255
            g = Double((value & 0x00FF00) >> 8) / 255
            b = Double(value & 0x0000FF) / 255
            a = 1.0
        case 8: // RRGGBBAA
            r = Double((value & 0xFF000000) >> 24) / 255
            g = Double((value & 0x00FF0000) >> 16) / 255
            b = Double((value & 0x0000FF00) >> 8) / 255
            a = Double(value & 0x000000FF) / 255
        default:
            // Fallback to clear if format unexpected
            r = 0; g = 0; b = 0; a = 0
        }

        self = Color(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}

