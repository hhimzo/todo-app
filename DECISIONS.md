# Architecture Decisions

## Stack: Flutter (Dart)

**Chosen:** Flutter 3.x with Dart

### Evaluated alternatives

| Option | Pros | Cons |
|---|---|---|
| **Flutter** ✓ | Single Dart codebase, best-in-class Android perf, native PWA, Impeller renderer, strong Google backing | Dart learning curve (smaller than JS ecosystem) |
| React Native + Expo | JS ecosystem, large community | Web support via Expo is second-class; RN Web adds bundle weight |
| Ionic + Capacitor | Web-first, uses HTML/CSS/JS | WebView wrapper; inferior Android performance and Google Play quality signals |
| KMM (Kotlin Multiplatform) | Native Android UI | No web target; iOS-focused sharing |

**Decision:** Flutter wins on all three primary criteria: maximum code sharing (single codebase for Android + Web), first-class Google Play deployment, and best PWA output via `flutter build web`.

## State Management: Riverpod 2

Compile-safe dependency injection and reactive state with no BuildContext required. Preferred over Bloc (more boilerplate) and Provider (deprecated patterns).

## Navigation: go_router

Official Flutter-team router. Supports deep linking required for notification taps and web URL routing.

## Local Storage: Drift (SQLite / IndexedDB)

Type-safe, reactive SQLite layer. On web it uses IndexedDB via `drift_flutter`. Single API across both platforms — no conditional code needed.

## DI: get_it

Lightweight service locator. No reflection, compatible with all Flutter platforms.

## Architecture: Clean Architecture

```
domain/     — entities, repository interfaces, use cases (zero Flutter deps)
data/       — repository implementations, database, models
presentation/ — screens, widgets, Riverpod providers
core/       — DI wiring, routing, theme, constants
```

Enforces separation of concerns. Domain entities have zero Flutter dependencies, making unit testing trivial without mocking the framework.
