import SwiftUI
import Photos

struct OnboardingView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var allowPhotos = true
    @State private var includeStrava = true
    @State private var includeMusic = true
    @State private var requestedPhotosAuth = false
    @State private var proceedToImport = false

    init(viewModel: ProjectViewModel) {
        self.viewModel = viewModel
        _startDate = State(initialValue: viewModel.project.startDate)
        _endDate = State(initialValue: viewModel.project.endDate)
    }

    var body: some View {
        NavigationStack {
            Form {
            Section("Date Range") {
                DatePicker("Start", selection: $startDate, displayedComponents: .date)
                DatePicker("End", selection: $endDate, displayedComponents: .date)
            }

            Section("Sources") {
                Toggle("Photos Library", isOn: $allowPhotos)
                Toggle("Strava Screenshots (OCR)", isOn: $includeStrava)
                Toggle("Music List (text/CSV)", isOn: $includeMusic)
            }

                Section {
                    Button("Continue") {
                        commit()
                    }.buttonStyle(.borderedProminent)
                }
            }
            .navigationDestination(isPresented: $proceedToImport) {
                ImportView(viewModel: viewModel)
            }
            .navigationTitle("Year Setup")
            .onAppear { preflightPhotosAuth() }
        }
    }

    private func commit() {
        viewModel.project.startDate = startDate
        viewModel.project.endDate = endDate
        viewModel.save()
        if allowPhotos && !requestedPhotosAuth {
            PHPhotoLibrary.requestAuthorization { _ in }
            requestedPhotosAuth = true
        }
        proceedToImport = true
    }

    private func preflightPhotosAuth() {
        // No-op; PHPicker does not require, but we can pre-request if desired
    }
}
