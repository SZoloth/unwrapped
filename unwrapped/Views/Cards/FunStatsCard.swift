import SwiftUI

struct FunStatsCard: View {
    var stats: [FunStat]

    var body: some View {
        CardFrame {
            VStack(alignment: .leading, spacing: DS.Spacing.md) {
                Text("Fun Stats")
                    .font(DS.Typography.headline)
                    .foregroundColor(Palette.ink)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: DS.Spacing.md) {
                    ForEach(stats.prefix(6)) { s in
                        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
                            Text(s.label).font(DS.Typography.caption).foregroundColor(Palette.inkSecondary)
                            Text(s.value).font(DS.Typography.headline).foregroundColor(Palette.ink)
                        }
                        .padding(DS.Spacing.lg)
                        .background(Palette.softPeach.opacity(0.4))
                        .cornerRadius(DS.Radius.md)
                    }
                }
                Spacer()
            }
        }
    }
}

