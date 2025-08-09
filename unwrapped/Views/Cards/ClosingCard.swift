import SwiftUI

struct ClosingCard: View {
    var body: some View {
        CardFrame {
            VStack(spacing: DS.Spacing.lg) {
                Spacer()
                Text("Thanks for the memories")
                    .font(DS.Typography.title)
                    .foregroundColor(Palette.ink)
                Text("Bubba & Bubba")
                    .font(DS.Typography.headline)
                    .foregroundColor(Palette.inkSecondary)
                Spacer()
            }
        }
    }
}

