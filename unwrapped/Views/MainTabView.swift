import SwiftUI

/// Root TabView for AnniversaryOS containing Tender and Wrapped tabs.
struct MainTabView: View {
    @EnvironmentObject var projectVM: ProjectViewModel
    @EnvironmentObject var tenderVM: TenderViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Tender (Swipe Profiles)
            TenderView()
                .environmentObject(tenderVM)
                .tabItem {
                    Image(systemName: "flame.fill")
                    Text("Tender")
                }
                .tag(0)

            // Tab 2: Wrapped (Year in Review)
            YearFlowContainer(viewModel: projectVM)
                .tabItem {
                    Image(systemName: "gift.fill")
                    Text("Wrapped")
                }
                .tag(1)
        }
        .tint(Palette.accent)
    }
}

#Preview {
    MainTabView()
        .environmentObject(ProjectViewModel())
        .environmentObject(TenderViewModel())
}
