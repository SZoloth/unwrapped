import SwiftUI
import UIKit
import PhotosUI

struct ImportView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State private var showingImagePicker = false
    @State private var pickedImageURLs: [URL] = []
    @State private var proceedToCuration = false
    @State private var photoItems: [PhotosPickerItem] = []

    var body: some View {
        List {
            Section("Photos") {
                Button("Import from Files…") { showingImagePicker = true }
                PhotosPicker("Import from Photos…", selection: $photoItems, maxSelectionCount: 20, matching: .images)
                Text("Imported: \(pickedImageURLs.count)")
            }

            Section("Strava Screenshots (OCR)") {
                Text("Add screenshots via Files; OCR parses distance/time/elevation. Edit later if needed.")
            }

            Section("Music List") {
                Text("Paste tracks as 'Title – Artist' lines in the Soundtrack card.")
            }

            Section {
                NavigationLink("Proceed to Curation", isActive: $proceedToCuration) { EmptyView() }
                Button("Continue") { proceedToCuration = true }
                    .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("Import")
        .fileImporter(isPresented: $showingImagePicker, allowedContentTypes: [.image], allowsMultipleSelection: true) { result in
            switch result {
            case .success(let urls):
                pickedImageURLs = urls
                let moments = PhotoImportService.moments(from: urls)
                if let idx = viewModel.project.cards.firstIndex(where: { $0.type == .topMoments }) {
                    viewModel.project.cards[idx].moments.append(contentsOf: moments)
                }
                viewModel.save()
            case .failure:
                break
            }
        }
        .onChange(of: photoItems) { _, newItems in
            Task {
                var newURLs: [URL] = []
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        if let saved = try? PersistenceService.saveImageData(data, suggestedName: UUID().uuidString) {
                            newURLs.append(saved)
                        }
                    }
                }
                if !newURLs.isEmpty {
                    pickedImageURLs.append(contentsOf: newURLs)
                    let moments = PhotoImportService.moments(from: newURLs)
                    if let idx = viewModel.project.cards.firstIndex(where: { $0.type == .topMoments }) {
                        viewModel.project.cards[idx].moments.append(contentsOf: moments)
                    }
                    viewModel.save()
                }
            }
        }
        .navigationDestination(isPresented: $proceedToCuration) {
            CurationView(viewModel: viewModel)
        }
    }
}
