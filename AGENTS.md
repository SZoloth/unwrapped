# Repository Guidelines

## Project Structure & Module Organization
- Source: `unwrapped/` (SwiftUI app). Notable folders: `Models/`, `ViewModels/`, `Services/`, `Utilities/`, `Extensions/`, `Assets.xcassets/`, `ContentView.swift`.
- Tests: `unwrappedTests/` (unit) and `unwrappedUITests/` (UI).
- Xcode project: `unwrapped.xcodeproj/` (targets: `unwrapped`, `unwrappedTests`, `unwrappedUITests`).
- Workflows & docs: `ai-dev-workflow/` (LLM workflows), `tasks/` (task lists), top-level `README.md`.

## Build, Test, and Development Commands
- List targets/schemes: `xcodebuild -list -project unwrapped.xcodeproj`
- Build (Debug): `xcodebuild -project unwrapped.xcodeproj -target unwrapped -configuration Debug build`
- Run tests (simulator): `xcodebuild test -project unwrapped.xcodeproj -scheme unwrapped -destination 'platform=iOS Simulator,name=iPhone 15'`
- Open in Xcode (preferred for local dev): `xed .` then select scheme `unwrapped` and run.

## Coding Style & Naming Conventions
- Swift 5, SwiftUI. Follow Apple’s API Design Guidelines.
- Indentation: 2 spaces; max line length ~120.
- Naming: `UpperCamelCase` for types, `lowerCamelCase` for methods/properties; files match primary type (e.g., `UserProfileViewModel.swift`).
- Group code by feature in `Models/`, `ViewModels/`, `Services/`, `Utilities/`; keep views stateless where possible.
- Comments: prefer clear code over comments; use `// TODO:` and `// FIXME:` for follow-ups.

## Testing Guidelines
- Frameworks: XCTest (+ XCUITest in `unwrappedUITests`).
- Naming: `test_<subject>_<expectation>()` (e.g., `test_fetchProfile_returnsCachedValue`).
- Scope: unit-test public behavior of view models and services; add UI tests for critical flows.
- Commands: run via Xcode’s Test navigator or `xcodebuild test` (see above). Aim to keep tests fast and deterministic.

## Commit & Pull Request Guidelines
- Commits: imperative mood, concise scope (e.g., `Add login flow retry`). Group related changes; avoid mixed concerns.
- Prefer Conventional Commit prefixes when helpful (feat, fix, refactor, test, docs).
- PRs: include a clear description, linked issues (e.g., `Fixes #123`), test coverage notes, and screenshots/screen recordings for UI changes.

## Security & Configuration Tips
- Do not commit secrets, certificates, or DerivedData. Signing uses local developer profiles.
- Keep iOS deployment target consistent with the project (see `project.pbxproj`, currently iOS 17).

## Agent-Specific Notes
- When using LLM agents, propose changes via small, reviewable PRs. Put generated task plans in `tasks/` and reference workflows in `ai-dev-workflow/`.
