import SwiftUI

struct MilestonesCard: View {
    var milestones: [Milestone]

    var body: some View {
        CardFrame {
            VStack(alignment: .leading, spacing: DS.Spacing.md) {
                Text("Milestones")
                    .font(DS.Typography.headline)
                    .foregroundColor(Palette.ink)
                ForEach(milestones.prefix(6)) { m in
                    HStack(alignment: .top, spacing: DS.Spacing.sm) {
                        Circle().fill(Palette.lavender).frame(width: 10, height: 10)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(m.title).font(DS.Typography.body).foregroundColor(Palette.ink)
                            if let d = m.date {
                                Text(DateFormatter.localizedString(from: d, dateStyle: .medium, timeStyle: .none)).font(DS.Typography.caption).foregroundColor(Palette.inkSecondary)
                            }
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

