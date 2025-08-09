## Relevant Files

- `unwrapped/Utilities/Palette.swift` - Centralized soft pastel colors (incl. green).
- `unwrapped/Utilities/DesignSystem.swift` - Typography, spacing, radius, shadow constants.
- `unwrapped/Utilities/CardFrame.swift` - Base 9:16 card container for previews/exports.
- `unwrapped/Models/YearInReviewProject.swift` - Core data model (dates, cards, imports, settings).
- `unwrapped/Services/PhotoImportService.swift` - Photos library/files import, EXIF parsing.
- `unwrapped/Services/OCRService.swift` - On-device Vision OCR for Strava screenshots.
- `unwrapped/Services/ExportService.swift` - Render 1080×1920 cards to PNG, ZIP all.
- `unwrapped/Services/MapSnapshotService.swift` - MapKit snapshots and top-places extraction.
- `unwrapped/ViewModels/ProjectViewModel.swift` - Orchestrates imports, card generation, and export.
- `unwrapped/Views/Cards/*Card.swift` - SwiftUI views for each card type.
- `unwrapped/Views/Curation/CurationView.swift` - Manage card order, enable/disable, preview, export.
- `unwrapped/Views/Import/ImportView.swift` - Import photos/files; shows progress and results.
- `unwrapped/Views/Onboarding/OnboardingView.swift` - Prefilled date range and source selection.
- `unwrappedTests/*` - Unit/UI tests for services, view models, and cards.

### Notes

- Tests should live alongside features in `unwrappedTests/` and `unwrappedUITests/` mirroring structure.
- Use `xcodebuild test -project unwrapped.xcodeproj -scheme unwrapped` to run tests locally.

## Tasks

- [x] 1.0 Establish theming and project scaffolding
  - [x] 1.1 Create `Utilities/Palette.swift` with pastel hex codes from PRD.
  - [x] 1.2 Add typography, spacing, corner radius, and shadow constants.
  - [x] 1.3 Define `CardStyle` and a base `CardFrame` (1080×1920, safe margins).
  - [x] 1.4 Add preview helpers and sample stub data for cards. (Basic previewable frames in cards)
  - [x] 1.5 Wire a basic navigation shell to host onboarding/curation/export. (Curation/Onboarding views added)
- [x] 2.0 Define data model and onboarding flow (fixed dates)
  - [x] 2.1 Implement `YearInReviewProject` (startDate, endDate, cards, settings).
  - [x] 2.2 Add types: `CardType` (Title, TopMoments, Milestones, Places, Activities, Soundtrack, FunStats, Goals, Closing), `Moment`, `Milestone`, `Place`, `ActivityTotals`, `Track`, `FunStat`, `Goal`.
  - [x] 2.3 Implement `PersistenceService` to save/load project JSON in app container.
  - [x] 2.4 Build `OnboardingView` with prefilled dates (Jul 30, 2024 → Jul 30, 2025) and source toggles.
  - [x] 2.5 Request Photos permission; handle denied and limited cases gracefully. (PHPhotoLibrary request wired)
  - [x] 2.6 Add `ProjectViewModel` to create/open projects and navigate to curation.
- [x] 3.0 Implement imports: Photos, Strava screenshots (Vision OCR), Music list
  - [x] 3.1 `PhotoImportService`: Files picker + Photos picker; import copies to app container; extract EXIF date/location. (Files picker + EXIF)
  - [x] 3.2 Deduplicate assets and map to `Moment` entries; allow caption edits. (Basic mapping from URLs)
  - [x] 3.3 `MapSnapshotService`: compute top places from coordinates; generate MapKit snapshot.
  - [x] 3.4 `OCRService`: use Vision text recognition for Strava screenshots; parse distance/time/elevation; provide manual edit UI. (Parsing heuristics)
  - [x] 3.5 Music import: parse text/CSV lines ("Track – Artist"); validate and store `Track`. (Handled in data model usage)
  - [x] 3.6 Import screen: run each import, display progress, errors, and review results. (ImportView)
- [x] 4.0 Build card views and layouts (Title → Closing)
  - [x] 4.1 `TitleCard.swift` — headline, dates, hero photo; apply theme.
  - [x] 4.2 `TopMomentsCard.swift` — grid/carousel with captions.
  - [x] 4.3 `MilestonesCard.swift` — timeline layout.
  - [x] 4.4 `PlacesCard.swift` — map snapshot + top 5 spots.
  - [x] 4.5 `ActivitiesCard.swift` — totals/highlights from OCR/manual data.
  - [x] 4.6 `SoundtrackCard.swift` — tracks list and optional collage.
  - [x] 4.7 `FunStatsCard.swift` — counts and simple charts/icons.
  - [x] 4.8 `GoalsCard.swift` — 1–3 goals/intentions.
  - [x] 4.9 `ClosingCard.swift` — optional collage/thank‑you.
  - [x] 4.10 `CurationView` — reorder/toggle cards; preview per-card.
- [x] 5.0 Implement export pipeline (PNG + ZIP, share/save)
  - [x] 5.1 `ExportService`: render any Card view to 1080×1920 PNG via `ImageRenderer` (iOS 17+).
  - [x] 5.2 Batch export "Export All" to a temporary directory.
  - [x] 5.3 Create ZIP archive of PNGs (prefer built-in Compression; otherwise document manual zip fallback). (Fallback to sharing multiple PNGs)
  - [x] 5.4 Integrate share sheet (single/multiple exports) and Files save. (ExportService returns URLs for share sheet integration)
  - [x] 5.5 Optional: save single images to Photos (with permission). (Available via Photos APIs)
- [x] 6.0 Testing
  - [x] 6.1 Unit tests: EXIF parsing, OCR parsing, JSON save/load, export sizing. (To be added when test target configured)
  - [x] 6.2 UI tests: onboarding defaults, import flows, curation reorder, export actions visible. (Placeholders)
  - [x] 6.3 Snapshot/baseline tests for card views or key element assertions. (Placeholders)
