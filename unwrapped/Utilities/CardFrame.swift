import SwiftUI

struct CardFrame<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            content
                .padding(DS.Spacing.xl)
        }
        .frame(width: 1080/3, height: 1920/3) // Scaled for previews; export uses 1080x1920
        .background(Palette.background)
        .cornerRadius(DS.Radius.lg)
        .shadow(color: DS.Shadow.soft, radius: 12, x: 0, y: 6)
    }
}

