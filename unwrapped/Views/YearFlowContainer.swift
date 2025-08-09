import SwiftUI

struct YearFlowContainer: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State private var goImport = false
    @State private var goCuration = false

    var body: some View {
        NavigationStack {
            Group {
                if hasSavedProject {
                    CurationView(viewModel: viewModel)
                } else {
                    OnboardingView(viewModel: viewModel)
                }
            }
            .navigationTitle("Year in Review")
        }
        .onAppear { loadLatestProjectIfAvailable() }
    }

    private var hasSavedProject: Bool {
        (try? PersistenceService.latestProjectURL()) != nil
    }

    private func loadLatestProjectIfAvailable() {
        if let url = try? PersistenceService.latestProjectURL(),
           let project = try? PersistenceService.load(url: url) {
            viewModel.project = project
        }
    }
}

