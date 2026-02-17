import SwiftUI

/// Main container view for the Tender swipe experience.
struct TenderView: View {
    @EnvironmentObject var viewModel: TenderViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(hex: "#1a1a2e"),
                        Color(hex: "#16213e")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header with title and progress
                    headerSection

                    if viewModel.isComplete {
                        // Completion view
                        completionView
                    } else {
                        // Card stack
                        cardStackSection

                        // Action buttons
                        actionButtonsSection
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 12) {
            // Title (only show large on first card)
            if viewModel.currentIndex == 0 {
                Text("Tender")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white.opacity(0.95))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }

            // Progress bar
            VStack(spacing: 8) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background track
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white.opacity(0.12))
                            .frame(height: 6)

                        // Progress fill
                        RoundedRectangle(cornerRadius: 3)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "#8b5cf6").opacity(0.9),
                                        Color(hex: "#0ea5e9").opacity(0.9)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * viewModel.progress, height: 6)
                            .animation(.easeOut(duration: 0.3), value: viewModel.progress)
                    }
                }
                .frame(height: 6)
                .padding(.horizontal)

                // Progress text
                HStack {
                    Text("\(viewModel.currentIndex) of \(viewModel.profiles.count)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))

                    Spacer()

                    Text("\(Int(viewModel.progress * 100))% complete")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
        .animation(.easeInOut(duration: 0.25), value: viewModel.currentIndex)
    }

    // MARK: - Card Stack Section

    private var cardStackSection: some View {
        GeometryReader { geometry in
            ZStack {
                SwipeCardStack()
                    .environmentObject(viewModel)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
    }

    // MARK: - Action Buttons Section

    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 24) {
                // Pass button (X)
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        viewModel.pass()
                    }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                } label: {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#ff6b6b"), Color(hex: "#ee5253")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 64, height: 64)
                            .shadow(color: Color(hex: "#ff6b6b").opacity(0.4), radius: 8, y: 4)

                        Image(systemName: "xmark")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .disabled(viewModel.currentProfile == nil)

                // Like button (Heart)
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        viewModel.like()
                    }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                } label: {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#00d2d3"), Color(hex: "#1dd1a1")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 64, height: 64)
                            .shadow(color: Color(hex: "#00d2d3").opacity(0.4), radius: 8, y: 4)

                        Image(systemName: "heart.fill")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .disabled(viewModel.currentProfile == nil)
            }

            // Hint text
            Text("Swipe right to like • Swipe left to pass")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.bottom, 24)
    }

    // MARK: - Completion View

    private var completionView: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("💕")
                .font(.system(size: 80))

            Text("That's Everyone!")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)

            Text("You've swiped through all the Sams")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))

            // Stats
            HStack(spacing: 40) {
                VStack {
                    Text("\(viewModel.likeCount)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(hex: "#1dd1a1"))
                    Text("Likes")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }

                VStack {
                    Text("\(viewModel.passCount)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(hex: "#ff6b6b"))
                    Text("Passes")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(.top, 8)

            Spacer()

            // Start Over button
            Button {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    viewModel.startOver()
                }
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                Text("Start Over")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#8b5cf6"), Color(hex: "#0ea5e9")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .transition(.scale.combined(with: .opacity))
    }
}

#Preview {
    TenderView()
        .environmentObject(TenderViewModel())
}
