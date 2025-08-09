import SwiftUI
import UIKit

struct CurationView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State private var selection: CardType = .title
    @State private var editMode: EditMode = .inactive
    @State private var isExporting = false
    @State private var showShare = false
    @State private var showShareSheet = false
    @State private var zipURL: URL? = nil

    var body: some View {
        NavigationView {
            List {
                Section("Cards") {
                    ForEach($viewModel.project.cards) { $card in
                        HStack {
                            Text(card.type.rawValue.capitalized)
                            Spacer()
                            Toggle("", isOn: $card.isEnabled).labelsHidden()
                        }
                    }
                    .onMove { from, to in
                        viewModel.project.cards.move(fromOffsets: from, toOffset: to)
                        viewModel.save()
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .navigationTitle("Curation")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(editMode.isEditing ? "Done" : "Reorder") { editMode = editMode.isEditing ? .inactive : .active }
                }
            }

            previewPane
        }
    }

    @ViewBuilder var previewPane: some View {
        VStack {
            Picker("Preview", selection: $selection) {
                ForEach(CardType.allCases) { t in
                    Text(t.rawValue.capitalized).tag(t)
                }
            }.pickerStyle(.segmented)

            Spacer()
            CardFrame {
                Text(selection.rawValue.capitalized)
                    .font(DS.Typography.title)
                    .foregroundColor(Palette.ink)
            }
            Spacer()

            if !viewModel.exportedURLs.isEmpty {
                ShareLink(items: viewModel.exportedURLs) {
                    Label("Share Exports", systemImage: "square.and.arrow.up")
                }
                if let zipURL {
                    ShareLink(item: zipURL) { Label("Share ZIP", systemImage: "archivebox") }
                }
                Button {
                    showShareSheet = true
                } label: {
                    Label("Share (compat)", systemImage: "square.and.arrow.up.on.square")
                }
            }
            Button(isExporting ? "Exporting…" : "Export All") {
                Task { await exportAll() }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isExporting)
        }
        .padding()
        .sheet(isPresented: $showShareSheet) {
            let items: [Any] = zipURL != nil ? [zipURL!] : viewModel.exportedURLs
            ShareSheet(items: items)
        }
    }

    private func exportAll() async {
        isExporting = true
        defer { isExporting = false }
        ExportService.cleanupOldExports()
        let views = buildCardViews()
        do {
            let urls = try ExportService.exportCards(views)
            viewModel.exportedURLs = urls
            zipURL = try? ExportService.zipExports(urls)
        } catch {
            print("Export error: \(error)")
        }
    }

    private func buildCardViews() -> [AnyView] {
        var result: [AnyView] = []
        for card in viewModel.project.cards where card.isEnabled {
            switch card.type {
            case .title:
                result.append(AnyView(TitleCard(project: viewModel.project)))
            case .topMoments:
                result.append(AnyView(TopMomentsCard(moments: card.moments)))
            case .milestones:
                result.append(AnyView(MilestonesCard(milestones: card.milestones)))
            case .places:
                result.append(AnyView(PlacesCard(places: card.places)))
            case .activities:
                result.append(AnyView(ActivitiesCard(totals: card.activityTotals)))
            case .soundtrack:
                result.append(AnyView(SoundtrackCard(tracks: card.tracks)))
            case .funStats:
                result.append(AnyView(FunStatsCard(stats: card.funStats)))
            case .goals:
                result.append(AnyView(GoalsCard(goals: card.goals)))
            case .closing:
                result.append(AnyView(ClosingCard()))
            }
        }
        return result
    }
}
