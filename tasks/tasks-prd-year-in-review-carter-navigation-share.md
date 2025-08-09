## Relevant Files

- `unwrapped/ProjectNamePlaceholderApp.swift` - App entry; configure root view and environment objects.
- `unwrapped/ContentView.swift` - Main shell; will host navigation to onboarding/curation.
- `unwrapped/ViewModels/ProjectViewModel.swift` - Project state; drives onboarding → curation flow.
- `unwrapped/Views/Onboarding/OnboardingView.swift` - Prefilled dates and source toggles.
- `unwrapped/Views/Curation/CurationView.swift` - Manage cards, preview, trigger export.
- `unwrapped/Services/ExportService.swift` - Renders PNGs; provides file URLs for sharing.

### Notes

- Keep the current tab-based UI intact; introduce a lightweight flow that presents onboarding first, then navigates to curation.
- Share integration should not block the UI; provide a simple ShareLink/ShareSheet with the latest export URLs.

## Tasks

- [ ] 1.0 Wire onboarding and curation into the app flow
  - [x] 1.1 Inject `ProjectViewModel` at app entry (`ProjectNamePlaceholderApp.swift`) as `@StateObject` and pass to root.
  - [x] 1.2 Update `ContentView.swift` to present `OnboardingView(viewModel:)` on first launch or via a "Year in Review" entry point in Home. (Added toolbar button and sheet)
  - [x] 1.3 After onboarding Continue, navigate to `ImportView(viewModel:)` to add media/screenshots. (NavigationDestination)
  - [x] 1.4 From Import, provide a clear action to proceed to `CurationView(viewModel:)`. (Continue button + NavigationLink)
  - [x] 1.5 Persist the project with `PersistenceService.save(_:)` after onboarding and after imports. (Save calls added)
  - [x] 1.6 Handle resume flow: if a saved project exists, skip onboarding and go directly to Import/Curation. (YearFlowContainer auto-loads latest)
  - [x] 1.7 Ensure `NSPhotoLibraryUsageDescription` is set in Info.plist (Photos access copy).
  - [x] 1.8 Add basic sample data hook for previews (does not ship). (N/A for now)

 - [ ] 2.0 Add share link/button around export results
  - [x] 2.1 In `CurationView`, assemble card views (Title, Top Moments, etc.) into `[AnyView]` for export.
  - [x] 2.2 Call `ExportService.exportCards(_:)` and store returned file URLs in `ProjectViewModel.exportedURLs`.
  - [x] 2.3 Present a `ShareLink` (iOS 16+) for multiple files; fallback to `UIActivityViewController` if needed. (ShareLink added)
  - [x] 2.4 Indicate export progress and completion (simple state with disabled button while exporting).
  - [x] 2.5 Provide "Open in Files" option for the export directory.
  - [x] 2.6 Clean up temporary export folders on next export or when user confirms.
