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
