# unwrapped - iOS SwiftUI Application

This is a modern iOS application built with SwiftUI targeting iOS 17+.

## Development

Open `unwrapped.xcodeproj` in Xcode to start development.

## Architecture

- **Framework**: SwiftUI with UIKit bridges where needed
- **Language**: Swift 5.9+
- **Architecture**: MVVM with @StateObject and @Published
- **Networking**: Async/await with Combine for reactive programming
- **Testing**: XCTest for unit tests, XCUITest for UI tests
- **Deployment**: iOS 17+ targeting iPhone and iPad

## Project Structure

- `Models/` - Data models and business logic
- `ViewModels/` - MVVM view models with @ObservableObject
- `Services/` - API clients and business services
- `Extensions/` - Swift extensions and utilities
- `Utilities/` - Helper functions and constants

## Guidelines for Claude

- Use SwiftUI best practices and declarative patterns
- Implement proper state management with @StateObject/@ObservableObject
- Follow iOS Human Interface Guidelines
- Use async/await for network calls
- Implement proper error handling and loading states
- Write unit tests for view models and services
- Use the existing NetworkManager for API calls
