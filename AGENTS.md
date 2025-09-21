# Repository Guidelines

<!-- 저장소 참여자들에게 필요한 핵심 가이드를 정리한 문서입니다 -->

<!-- 프로젝트 파일 구조와 디렉터리 역할을 소개합니다 -->
## Project Structure & Module Organization
- `NetworkingStudy/` contains the SwiftUI app entry point plus feature folders: `GitHub/` for GitHub search views and DTOs, `Service/` for networking, `Ramdom/` for the random-user screen, and `Utils/` for reusable helpers like `CachedAsyncImage`.
- Assets live in `NetworkingStudy/Assets.xcassets`. Keep new imagery or colors there so Xcode resolves catalog references automatically.
- The Xcode project file `NetworkingStudy.xcodeproj` tracks schemes and build settings; update it through Xcode to avoid merge conflicts.

<!-- 자주 사용하는 빌드 및 테스트 명령어를 정리했습니다 -->
## Build, Test, and Development Commands
- `xcodebuild -resolvePackageDependencies` locks external Swift Package Manager dependencies; run before first build or when Package.swift changes.
- `xcodebuild clean build -project NetworkingStudy.xcodeproj -scheme NetworkingStudy -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.5'` matches CI and verifies the app builds from a clean state.
- `xcodebuild test` with the same flags executes simulator-based XCTest suites; include it in local validation before opening a PR.

<!-- Swift 코딩 스타일과 네이밍 규칙을 안내합니다 -->
## Coding Style & Naming Conventions
- Follow Swift API Design Guidelines: `UpperCamelCase` for types, `lowerCamelCase` for properties/functions, and descriptive case names for enums.
- Indent with four spaces and group related extensions in dedicated files (e.g., keep networking utilities in `Utils/`).
- Prefer `struct` for SwiftUI views, keep view models under `GitHub/ViewModel/`, and annotate public async functions with concise doc comments.

<!-- 테스트 작성 및 실행 시 유의할 점을 설명합니다 -->
## Testing Guidelines
- Add or update tests in an `XCTest` target (create `NetworkingStudyTests` if absent) focusing on view models and `NetworkService` behavior.
- Use async XCTest expectations (`await`, `XCTAssertThrowsError`) to cover networking branches, and mirror fixture data structures found in `GitHub/DTOs`.
- Record the simulator/device used when reporting issues uncovered during manual UI testing.

<!-- 커밋·PR 작성 시 따라야 할 규칙을 명시합니다 -->
## Commit & Pull Request Guidelines
- Prefix commit messages with a relevant gitmoji (e.g., `:sparkles:` for features, `:bug:` for fixes) followed by an imperative summary written in Korean (`:sparkles: 아바타 로더에 캐싱 추가`).
- Reference related GitHub issues in the PR body, summarize key changes, and attach before/after screenshots for UI updates.
- Ensure CI passes, note any skipped tests, and call out follow-up tasks so reviewers can assess risk quickly.

<!-- 외부 API 사용과 설정 관련 주의사항을 공유합니다 -->
## API & Configuration Notes
- External data comes from `api.github.com` and `randomuser.me`; avoid hard-coding tokens and prefer configurable constants when authentication is needed.
- Throttle experimental calls to respect rate limits, and log requests with `Logger` (see `Service/NetworkService.swift`) instead of `print` in production contributions.
