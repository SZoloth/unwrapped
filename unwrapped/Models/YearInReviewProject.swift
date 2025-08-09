import Foundation
import CoreLocation

struct YearInReviewProject: Codable, Identifiable {
    let id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var cards: [Card]
    var settings: Settings

    init(
        id: UUID = UUID(),
        title: String = "Bubba & Bubba: Our Year",
        startDate: Date,
        endDate: Date,
        cards: [Card] = [],
        settings: Settings = .default
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.cards = cards
        self.settings = settings
    }

    static var defaultDates: (Date, Date) {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents(year: 2024, month: 7, day: 30)
        let start = calendar.date(from: components) ?? Date()
        components.year = 2025
        let end = calendar.date(from: components) ?? Date()
        return (start, end)
    }
}

// MARK: - Cards
enum CardType: String, Codable, CaseIterable, Identifiable {
    case title, topMoments, milestones, places, activities, soundtrack, funStats, goals, closing
    var id: String { rawValue }
}

struct Card: Codable, Identifiable {
    let id: UUID
    var type: CardType
    var isEnabled: Bool

    // Minimal payloads; views can load more via services
    var titleData: TitleData? = nil
    var moments: [Moment] = []
    var milestones: [Milestone] = []
    var places: [Place] = []
    var activityTotals: ActivityTotals? = nil
    var tracks: [Track] = []
    var funStats: [FunStat] = []
    var goals: [Goal] = []

    init(id: UUID = UUID(), type: CardType, isEnabled: Bool = true) {
        self.id = id
        self.type = type
        self.isEnabled = isEnabled
    }
}

struct TitleData: Codable {
    var heroImageURL: URL?
}

struct Moment: Codable, Identifiable {
    let id: UUID
    var imageURL: URL
    var caption: String?
    var date: Date?
    var location: CLLocationCoordinate2DWrapper?
}

struct Milestone: Codable, Identifiable {
    let id: UUID
    var title: String
    var date: Date?
    var note: String?
}

struct Place: Codable, Identifiable {
    let id: UUID
    var name: String
    var coordinate: CLLocationCoordinate2DWrapper
    var visitCount: Int
}

struct ActivityTotals: Codable {
    var distanceKM: Double
    var elevationM: Double
    var timeHours: Double
}

struct Track: Codable, Identifiable {
    let id: UUID
    var title: String
    var artist: String
}

struct FunStat: Codable, Identifiable {
    let id: UUID
    var label: String
    var value: String
}

struct Goal: Codable, Identifiable {
    let id: UUID
    var text: String
}

struct Settings: Codable {
    var theme: Theme

    static let `default` = Settings(theme: .cozyPastel)
}

enum Theme: String, Codable { case cozyPastel }

// MARK: - Codable helpers
struct CLLocationCoordinate2DWrapper: Codable {
    var latitude: Double
    var longitude: Double

    init(_ coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}

