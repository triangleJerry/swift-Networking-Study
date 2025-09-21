# Repository Guidelines

## Project Structure & Module Organization
- `NetworkingStudy/` contains the SwiftUI app entry point plus feature folders: `GitHub/` for GitHub search views and DTOs, `Service/` for networking, `Ramdom/` for the random-user screen, and `Utils/` for reusable helpers like `CachedAsyncImage`.
- Assets live in `NetworkingStudy/Assets.xcassets`. Keep new imagery or colors there so Xcode resolves catalog references automatically.
- The Xcode project file `NetworkingStudy.xcodeproj` tracks schemes and build settings; update it through Xcode to avoid merge conflicts.

## Build, Test, and Development Commands
- `xcodebuild -resolvePackageDependencies` locks external Swift Package Manager dependencies; run before first build or when Package.swift changes.
- `xcodebuild clean build -project NetworkingStudy.xcodeproj -scheme NetworkingStudy -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.5'` matches CI and verifies the app builds from a clean state.
- `xcodebuild test` with the same flags executes simulator-based XCTest suites; include it in local validation before opening a PR.

## Coding Style & Naming Conventions
- Follow Swift API Design Guidelines: `UpperCamelCase` for types, `lowerCamelCase` for properties/functions, and descriptive case names for enums.
- Indent with four spaces and group related extensions in dedicated files (e.g., keep networking utilities in `Utils/`).
- Prefer `struct` for SwiftUI views, keep view models under `GitHub/ViewModel/`, and annotate public async functions with concise doc comments.

## Testing Guidelines
- Add or update tests in an `XCTest` target (create `NetworkingStudyTests` if absent) focusing on view models and `NetworkService` behavior.
- Use async XCTest expectations (`await`, `XCTAssertThrowsError`) to cover networking branches, and mirror fixture data structures found in `GitHub/DTOs`.
- Record the simulator/device used when reporting issues uncovered during manual UI testing.

## Commit & Pull Request Guidelines
- Prefix commit messages with a relevant gitmoji (e.g., `:sparkles:` for features, `:bug:` for fixes) followed by an imperative summary (`:sparkles: Add caching to avatar loader`).
- Reference related GitHub issues in the PR body, summarize key changes, and attach before/after screenshots for UI updates.
- Ensure CI passes, note any skipped tests, and call out follow-up tasks so reviewers can assess risk quickly.

## API & Configuration Notes
- External data comes from `api.github.com` and `randomuser.me`; avoid hard-coding tokens and prefer configurable constants when authentication is needed.
- Throttle experimental calls to respect rate limits, and log requests with `Logger` (see `Service/NetworkService.swift`) instead of `print` in production contributions.
