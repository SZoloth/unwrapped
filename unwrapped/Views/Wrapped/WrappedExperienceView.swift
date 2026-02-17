import SwiftUI

/// The main Wrapped experience - a full-screen swipeable card carousel.
struct WrappedExperienceView: View {
    @State private var currentIndex = 0
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?

    // Pre-populated relationship data
    private let data = WrappedData.bubbaAndBubba

    var body: some View {
        ZStack {
            // Background gradient that changes with card
            backgroundGradient
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: currentIndex)

            VStack(spacing: 0) {
                // Progress dots
                progressIndicator
                    .padding(.top, 8)

                // Card carousel
                TabView(selection: $currentIndex) {
                    ForEach(Array(data.cards.enumerated()), id: \.offset) { index, card in
                        WrappedCardView(card: card)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentIndex)

                // Bottom controls
                bottomControls
                    .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let image = shareImage {
                ShareSheet(items: [image])
            }
        }
    }

    // MARK: - Progress Indicator

    private var progressIndicator: some View {
        HStack(spacing: 4) {
            ForEach(0..<data.cards.count, id: \.self) { index in
                Capsule()
                    .fill(index == currentIndex ? Color.white : Color.white.opacity(0.3))
                    .frame(width: index == currentIndex ? 24 : 8, height: 4)
                    .animation(.spring(response: 0.3), value: currentIndex)
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Bottom Controls

    private var bottomControls: some View {
        HStack {
            // Previous button
            Button {
                withAnimation {
                    currentIndex = max(0, currentIndex - 1)
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.white.opacity(currentIndex > 0 ? 1 : 0.3))
                    .frame(width: 44, height: 44)
            }
            .disabled(currentIndex == 0)

            Spacer()

            // Share button
            Button {
                captureAndShare()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.2))
                .cornerRadius(25)
            }

            Spacer()

            // Next button
            Button {
                withAnimation {
                    currentIndex = min(data.cards.count - 1, currentIndex + 1)
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.white.opacity(currentIndex < data.cards.count - 1 ? 1 : 0.3))
                    .frame(width: 44, height: 44)
            }
            .disabled(currentIndex == data.cards.count - 1)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Background Gradient

    private var backgroundGradient: some View {
        let colors = data.cards[currentIndex].gradientColors
        return LinearGradient(
            colors: colors.map { Color(hex: $0) },
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Share

    @MainActor
    private func captureAndShare() {
        let card = data.cards[currentIndex]
        let cardView = WrappedCardView(card: card)
            .frame(width: 390, height: 700)
            .background(
                LinearGradient(
                    colors: card.gradientColors.map { Color(hex: $0) },
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

        let renderer = ImageRenderer(content: cardView)
        renderer.scale = 3.0

        if let image = renderer.uiImage {
            shareImage = image
            showShareSheet = true
        }
    }
}

// MARK: - Individual Card View

struct WrappedCardView: View {
    let card: WrappedCard

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Main content
            VStack(spacing: 20) {
                // Emoji/Icon
                if let emoji = card.emoji {
                    Text(emoji)
                        .font(.system(size: 80))
                }

                // Title
                Text(card.title)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                // Subtitle
                if let subtitle = card.subtitle {
                    Text(subtitle)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }

                // Stats
                if !card.stats.isEmpty {
                    VStack(spacing: 16) {
                        ForEach(card.stats, id: \.label) { stat in
                            HStack {
                                Text(stat.label)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                                Spacer()
                                Text(stat.value)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }

                // List items (for milestones, tracks, etc.)
                if !card.items.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(card.items.enumerated()), id: \.offset) { index, item in
                            HStack(spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(width: 24)
                                Text(item)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .padding(.horizontal, 30)

            Spacer()

            // Footer
            if let footer = card.footer {
                Text(footer)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.bottom, 30)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Data Models

struct WrappedCard {
    let title: String
    var subtitle: String?
    var emoji: String?
    var stats: [WrappedStat] = []
    var items: [String] = []
    var footer: String?
    var gradientColors: [String]
}

struct WrappedStat {
    let label: String
    let value: String
}

struct WrappedData {
    let title: String
    let cards: [WrappedCard]
}

// MARK: - Pre-populated Data

extension WrappedData {
    static let bubbaAndBubba = WrappedData(
        title: "Bubba & Bubba: Our Year",
        cards: [
            // 1. Title card
            WrappedCard(
                title: "Bubba & Bubba",
                subtitle: "Our Year Together\nJuly 2024 - July 2025",
                emoji: "💕",
                footer: "Tap to continue",
                gradientColors: ["#667eea", "#764ba2"]
            ),

            // 2. Days together
            WrappedCard(
                title: "365 Days",
                subtitle: "of adventures, laughs,\nand love",
                emoji: "📅",
                gradientColors: ["#f093fb", "#f5576c"]
            ),

            // 3. Top moments
            WrappedCard(
                title: "Top Moments",
                subtitle: "The memories we'll never forget",
                emoji: "✨",
                items: [
                    "First trip to Tokyo",
                    "Surprise birthday party",
                    "Moving in together",
                    "Adopting Luna",
                    "New Year's Eve in Paris"
                ],
                gradientColors: ["#4facfe", "#00f2fe"]
            ),

            // 4. Milestones
            WrappedCard(
                title: "Milestones",
                subtitle: "We hit some big ones",
                emoji: "🎯",
                items: [
                    "Said 'I love you'",
                    "Met the parents",
                    "First anniversary",
                    "Got our own place",
                    "Started a business together"
                ],
                gradientColors: ["#43e97b", "#38f9d7"]
            ),

            // 5. Places
            WrappedCard(
                title: "Places We Explored",
                subtitle: "Our favorite spots",
                emoji: "🗺️",
                stats: [
                    WrappedStat(label: "Cities visited", value: "12"),
                    WrappedStat(label: "Countries", value: "5"),
                    WrappedStat(label: "Road trips", value: "8")
                ],
                gradientColors: ["#fa709a", "#fee140"]
            ),

            // 6. Activities
            WrappedCard(
                title: "Adventures Together",
                subtitle: "We stayed active",
                emoji: "🏃‍♂️",
                stats: [
                    WrappedStat(label: "Hikes completed", value: "24"),
                    WrappedStat(label: "Miles walked", value: "342"),
                    WrappedStat(label: "Sunrises watched", value: "17")
                ],
                gradientColors: ["#a8edea", "#fed6e3"]
            ),

            // 7. Soundtrack
            WrappedCard(
                title: "Our Soundtrack",
                subtitle: "The songs of our year",
                emoji: "🎵",
                items: [
                    "Golden Hour - JVKE",
                    "Die With A Smile - Lady Gaga",
                    "All I Want - Kodaline",
                    "Perfect - Ed Sheeran",
                    "Lover - Taylor Swift"
                ],
                gradientColors: ["#6a11cb", "#2575fc"]
            ),

            // 8. Fun stats
            WrappedCard(
                title: "Fun Stats",
                subtitle: "By the numbers",
                emoji: "📊",
                stats: [
                    WrappedStat(label: "Date nights", value: "52"),
                    WrappedStat(label: "Movies watched", value: "73"),
                    WrappedStat(label: "Meals cooked", value: "200+"),
                    WrappedStat(label: "'I love you's", value: "∞")
                ],
                gradientColors: ["#ff9a9e", "#fecfef"]
            ),

            // 9. Closing
            WrappedCard(
                title: "Here's to Year Two",
                subtitle: "Thanks for all the memories,\nand here's to making more",
                emoji: "🥂",
                footer: "Made with love",
                gradientColors: ["#a18cd1", "#fbc2eb"]
            )
        ]
    )
}

#Preview {
    WrappedExperienceView()
}
