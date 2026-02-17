import Foundation
import SwiftUI

/// Direction of a swipe action.
enum SwipeDirection {
    case left   // Pass/Nope
    case right  // Like
}

/// Record of a swipe action.
struct SwipeRecord: Identifiable {
    let id = UUID()
    let profileId: String
    let direction: SwipeDirection
    let timestamp: Date
}

/// ViewModel managing Tender swipe state and logic.
final class TenderViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var profiles: [Profile]
    @Published private(set) var currentIndex: Int = 0
    @Published private(set) var swipeHistory: [SwipeRecord] = []
    @Published var isComplete: Bool = false

    // MARK: - Computed Properties

    /// The currently visible cards (up to 3 for the stack effect).
    var visibleProfiles: [Profile] {
        guard currentIndex < profiles.count else { return [] }
        let endIndex = min(currentIndex + 3, profiles.count)
        return Array(profiles[currentIndex..<endIndex])
    }

    /// The current top profile.
    var currentProfile: Profile? {
        guard currentIndex < profiles.count else { return nil }
        return profiles[currentIndex]
    }

    /// Progress through all profiles (0.0 to 1.0).
    var progress: Double {
        guard !profiles.isEmpty else { return 0 }
        return Double(currentIndex) / Double(profiles.count)
    }

    /// Number of profiles liked.
    var likeCount: Int {
        swipeHistory.filter { $0.direction == .right }.count
    }

    /// Number of profiles passed.
    var passCount: Int {
        swipeHistory.filter { $0.direction == .left }.count
    }

    // MARK: - Initialization

    init(profiles: [Profile] = Profile.sampleProfiles) {
        self.profiles = profiles
    }

    // MARK: - Actions

    /// Handle a swipe on the current profile.
    func swipe(_ direction: SwipeDirection) {
        guard let profile = currentProfile else { return }

        // Record the swipe
        let record = SwipeRecord(
            profileId: profile.id,
            direction: direction,
            timestamp: Date()
        )
        swipeHistory.append(record)

        // Move to next profile
        currentIndex += 1

        // Check if complete
        if currentIndex >= profiles.count {
            isComplete = true
        }
    }

    /// Like the current profile (swipe right).
    func like() {
        swipe(.right)
    }

    /// Pass on the current profile (swipe left).
    func pass() {
        swipe(.left)
    }

    /// Reset to start over.
    func startOver() {
        currentIndex = 0
        swipeHistory.removeAll()
        isComplete = false
    }

    /// Reload profiles (useful for refreshing data).
    func reloadProfiles(_ newProfiles: [Profile]) {
        profiles = newProfiles
        startOver()
    }
}
