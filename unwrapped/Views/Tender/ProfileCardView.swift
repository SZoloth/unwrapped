import SwiftUI

/// Individual profile card displaying photo, info, and interests.
struct ProfileCardView: View {
    let profile: Profile

    @State private var currentPhotoIndex = 0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Photo section (2/3 of card)
                photoSection(geometry: geometry)
                    .frame(height: geometry.size.height * 0.65)

                // Info section (1/3 of card)
                infoSection
                    .frame(height: geometry.size.height * 0.35)
            }
            .background(Color(hex: "#2d2d44"))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.3), radius: 16, x: 0, y: 8)
        }
    }

    // MARK: - Photo Section

    private func photoSection(geometry: GeometryProxy) -> some View {
        ZStack(alignment: .top) {
            // Photo display
            if profile.photos.isEmpty {
                // Placeholder if no photos
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#4a5568"), Color(hex: "#2d3748")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay {
                        VStack(spacing: 12) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.white.opacity(0.6))
                            Text(profile.name)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
            } else if let uiImage = UIImage(named: profile.photos[currentPhotoIndex]) {
                // Asset image exists
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
                    .clipped()
            } else {
                // Asset not found - show gradient placeholder with name
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#667eea"), Color(hex: "#764ba2")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay {
                        VStack(spacing: 12) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.6))
                            Text(profile.name)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
            }

            // Photo navigation overlays (tap left/right)
            if profile.photos.count > 1 {
                HStack(spacing: 0) {
                    // Tap left for previous
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                currentPhotoIndex = currentPhotoIndex == 0
                                    ? profile.photos.count - 1
                                    : currentPhotoIndex - 1
                            }
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }

                    // Tap right for next
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                currentPhotoIndex = (currentPhotoIndex + 1) % profile.photos.count
                            }
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                }
            }

            // Photo indicator dots
            if profile.photos.count > 1 {
                HStack(spacing: 4) {
                    ForEach(0..<profile.photos.count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(index == currentPhotoIndex ? Color.white : Color.white.opacity(0.3))
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }

            // Verification badge
            if profile.verified {
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#22c55e").opacity(0.9))
                            .frame(width: 24, height: 24)

                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 16)
                }
            }
        }
        .clipped()
    }

    // MARK: - Info Section

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Name and age
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(profile.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Text("\(profile.age)")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
            }

            // Occupation and distance
            HStack(spacing: 4) {
                Text(profile.occupation)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))

                if profile.distance > 0 {
                    Text("•")
                        .foregroundColor(.white.opacity(0.4))
                    Text("\(profile.distance) miles away")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            // Bio
            Text(profile.bio)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 8)

            // Interests
            interestTags
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Interest Tags

    private var interestTags: some View {
        FlowLayout(spacing: 8) {
            ForEach(profile.interests.prefix(4), id: \.self) { interest in
                Text(interest)
                    .font(.caption)
                    .foregroundColor(Color(hex: "#e7e9ee"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
            }
        }
    }
}

// MARK: - Flow Layout for Interest Tags

/// A layout that wraps content to multiple lines.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)

        for (index, subview) in subviews.enumerated() {
            subview.place(
                at: CGPoint(
                    x: bounds.minX + result.positions[index].x,
                    y: bounds.minY + result.positions[index].y
                ),
                proposal: .unspecified
            )
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + rowHeight)
        }
    }
}

#Preview("ProfileCardView") {
    ZStack {
        Color(hex: "#1a1a2e").ignoresSafeArea()

        ProfileCardView(profile: Profile.sampleProfiles[0])
            .frame(width: 350, height: 500)
    }
}
