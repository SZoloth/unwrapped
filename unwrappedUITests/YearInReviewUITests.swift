import XCTest

final class YearInReviewUITests: XCTestCase {
    func testExampleLaunch() {
        let app = XCUIApplication()
        app.launch()
        // Basic smoke test placeholder
        XCTAssertTrue(app.waitForExistence(timeout: 1.0))
    }
}

