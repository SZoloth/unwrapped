import SwiftUI

/// Container for the Wrapped year-in-review experience.
/// Directly shows the pre-populated carousel - no builder needed.
struct YearFlowContainer: View {
    @ObservedObject var viewModel: ProjectViewModel

    var body: some View {
        WrappedExperienceView()
    }
}

