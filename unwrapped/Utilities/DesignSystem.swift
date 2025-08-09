import SwiftUI

enum DS {
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
    }

    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 20
        static let xl: CGFloat = 28
    }

    enum Shadow {
        static let soft = Color.black.opacity(0.08)
        static let medium = Color.black.opacity(0.12)
    }

    enum Typography {
        static let title = Font.system(size: 36, weight: .bold, design: .rounded)
        static let headline = Font.system(size: 24, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 17, weight: .regular, design: .rounded)
        static let caption = Font.system(size: 13, weight: .regular, design: .rounded)
    }
}

