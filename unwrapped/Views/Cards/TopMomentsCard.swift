import SwiftUI

struct TopMomentsCard: View {
    var moments: [Moment]

    var body: some View {
        CardFrame {
            VStack(alignment: .leading, spacing: DS.Spacing.md) {
                Text("Top Moments")
                    .font(DS.Typography.headline)
                    .foregroundColor(Palette.ink)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: DS.Spacing.sm) {
                    ForEach(moments.prefix(6)) { m in
                        ZStack(alignment: .bottomLeading) {
                            if let ui = UIImage(contentsOfFile: m.imageURL.path) {
                                Image(uiImage: ui).resizable().scaledToFill()
                            } else {
                                Rectangle().fill(Palette.blushPink)
                            }
                        }
                        .frame(height: 120)
                        .clipped()
                        .cornerRadius(DS.Radius.sm)
                    }
                }
                Spacer()
            }
        }
    }
}

