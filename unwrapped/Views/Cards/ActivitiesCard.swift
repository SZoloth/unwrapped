import SwiftUI

struct ActivitiesCard: View {
    var totals: ActivityTotals?

    var body: some View {
        CardFrame {
            VStack(alignment: .leading, spacing: DS.Spacing.md) {
                Text("Activities Summary")
                    .font(DS.Typography.headline)
                    .foregroundColor(Palette.ink)
                HStack {
                    stat("Distance", String(format: "%.1f km", totals?.distanceKM ?? 0))
                    stat("Elevation", String(format: "%.0f m", totals?.elevationM ?? 0))
                    stat("Time", String(format: "%.1f h", totals?.timeHours ?? 0))
                }
                Spacer()
            }
        }
    }

    func stat(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(DS.Typography.caption).foregroundColor(Palette.inkSecondary)
            Text(value).font(DS.Typography.headline).foregroundColor(Palette.ink)
        }
        .padding(DS.Spacing.lg)
        .background(Palette.pastelGreen.opacity(0.25))
        .cornerRadius(DS.Radius.md)
    }
}

