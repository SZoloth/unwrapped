import XCTest
@testable import unwrapped

final class YearInReviewTests: XCTestCase {
    func testProjectDefaultDates() {
        let (start, end) = YearInReviewProject.defaultDates
        XCTAssertLessThan(start, end)
    }
}

