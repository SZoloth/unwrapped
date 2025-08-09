import SwiftUI

struct GoalsCard: View {
    var goals: [Goal]

    var body: some View {
        CardFrame {
            VStack(alignment: .leading, spacing: DS.Spacing.md) {
                Text("Looking Ahead")
                    .font(DS.Typography.headline)
                    .foregroundColor(Palette.ink)
                ForEach(goals.prefix(3)) { g in
                    HStack(alignment: .top, spacing: DS.Spacing.sm) {
                        Image(systemName: "sparkles").foregroundColor(Palette.pastelGreen)
                        Text(g.text).font(DS.Typography.body).foregroundColor(Palette.ink)
                    }
                }
                Spacer()
            }
        }
    }
}

