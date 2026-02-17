import SwiftUI

/// A stack of swipeable profile cards with gesture handling.
struct SwipeCardStack: View {
    @EnvironmentObject var viewModel: TenderViewModel

    var body: some View {
        ZStack {
            // Render cards in reverse order so top card is rendered last (on top)
            ForEach(Array(viewModel.visibleProfiles.enumerated().reversed()), id: \.element.id) { index, profile in
                SwipeableCard(
                    profile: profile,
                    isTop: index == 0,
                    stackIndex: index,
                    onSwipe: { direction in
                        viewModel.swipe(direction)
                    }
                )
            }
        }
    }
}

/// An individual swipeable card with drag gesture.
struct SwipeableCard: View {
    let profile: Profile
    let isTop: Bool
    let stackIndex: Int
    let onSwipe: (SwipeDirection) -> Void

    @State private var offset: CGSize = .zero
    @State private var isDragging = false

    // Thresholds for swipe detection
    private let swipeThreshold: CGFloat = 120
    private let velocityThreshold: CGFloat = 500
    private let maxRotation: Double = 30

    // Computed properties for animations
    private var rotation: Double {
        Double(offset.width / 20).clamped(to: -maxRotation...maxRotation)
    }

    private var cardOpacity: Double {
        let absOffset = abs(offset.width)
        if absOffset < 150 {
            return 1.0
        }
        return max(0, 1.0 - (absOffset - 150) / 150)
    }

    private var cardScale: CGFloat {
        // Cards behind the top card are slightly smaller
        1.0 - CGFloat(stackIndex) * 0.05
    }

    private var cardYOffset: CGFloat {
        // Cards behind the top card are slightly lower
        CGFloat(stackIndex) * 10
    }

    var body: some View {
        ProfileCardView(profile: profile)
            .scaleEffect(isDragging && isTop ? 1.02 : cardScale)
            .offset(x: isTop ? offset.width : 0, y: isTop ? offset.height : cardYOffset)
            .rotationEffect(.degrees(isTop ? rotation : 0))
            .opacity(isTop ? cardOpacity : 1.0)
            .zIndex(Double(10 - stackIndex))
            .gesture(isTop ? dragGesture : nil)
            .animation(.spring(response: 0.4, dampingFraction: 0.75), value: offset)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isDragging)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = value.translation
                isDragging = true
            }
            .onEnded { value in
                isDragging = false

                // Calculate if swipe should complete
                let horizontalOffset = value.translation.width
                let horizontalVelocity = value.predictedEndTranslation.width - value.translation.width

                let shouldSwipeRight = horizontalOffset > swipeThreshold || horizontalVelocity > velocityThreshold
                let shouldSwipeLeft = horizontalOffset < -swipeThreshold || horizontalVelocity < -velocityThreshold

                if shouldSwipeRight {
                    // Animate card off screen to the right
                    withAnimation(.easeOut(duration: 0.3)) {
                        offset = CGSize(width: 500, height: value.translation.height)
                    }
                    // Haptic feedback
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    // Trigger swipe after animation starts
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        onSwipe(.right)
                        offset = .zero
                    }
                } else if shouldSwipeLeft {
                    // Animate card off screen to the left
                    withAnimation(.easeOut(duration: 0.3)) {
                        offset = CGSize(width: -500, height: value.translation.height)
                    }
                    // Haptic feedback
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    // Trigger swipe after animation starts
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        onSwipe(.left)
                        offset = .zero
                    }
                } else {
                    // Snap back to center
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        offset = .zero
                    }
                }
            }
    }
}

// MARK: - Comparable Extension for Clamping
extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}

#Preview("SwipeCardStack") {
    ZStack {
        Color(hex: "#1a1a2e").ignoresSafeArea()
        SwipeCardStack()
            .environmentObject(TenderViewModel())
            .padding()
    }
}
