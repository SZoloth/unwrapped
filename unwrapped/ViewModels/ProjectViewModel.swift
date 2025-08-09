import Foundation
import SwiftUI

final class ProjectViewModel: ObservableObject {
    @Published var project: YearInReviewProject
    @Published var isPresentingImport = false
    @Published var isExporting = false
    @Published var exportedURLs: [URL] = []

    init() {
        let (start, end) = YearInReviewProject.defaultDates
        let defaultCards: [Card] = CardType.allCases.map { Card(type: $0) }
        self.project = YearInReviewProject(startDate: start, endDate: end, cards: defaultCards)
    }

    func save() {
        do { _ = try PersistenceService.save(project) } catch { print("Save error: \(error)") }
    }
}

