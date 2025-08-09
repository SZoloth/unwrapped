import SwiftUI

struct TitleCard: View {
    var project: YearInReviewProject
    var hero: Image? = nil

    var body: some View {
        CardFrame {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {
                Text(project.title)
                    .font(DS.Typography.title)
                    .foregroundColor(Palette.ink)
                Text("\(formatted(project.startDate)) – \(formatted(project.endDate))")
                    .font(DS.Typography.headline)
                    .foregroundColor(Palette.inkSecondary)
                Spacer()
                hero?.resizable().scaledToFill().frame(maxWidth: .infinity).clipped().cornerRadius(DS.Radius.md)
            }
        }
    }

    private func formatted(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}

