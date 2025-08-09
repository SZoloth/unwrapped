import SwiftUI

struct SoundtrackCard: View {
    var tracks: [Track]

    var body: some View {
        CardFrame {
            VStack(alignment: .leading, spacing: DS.Spacing.md) {
                Text("Soundtrack of the Year")
                    .font(DS.Typography.headline)
                    .foregroundColor(Palette.ink)
                ForEach(tracks.prefix(8)) { t in
                    Text("\(t.title) — \(t.artist)")
                        .font(DS.Typography.body)
                        .foregroundColor(Palette.ink)
                }
                Spacer()
            }
        }
    }
}

