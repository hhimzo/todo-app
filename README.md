# Todo App

A production-grade, offline-first Todo application for Android and Web built with Flutter.

[![CI](https://github.com/hhimzo/todo-app/actions/workflows/ci.yml/badge.svg)](https://github.com/hhimzo/todo-app/actions/workflows/ci.yml)
[![Deploy](https://github.com/hhimzo/todo-app/actions/workflows/deploy.yml/badge.svg)](https://github.com/hhimzo/todo-app/actions/workflows/deploy.yml)

## Features

- Create, read, update, delete tasks
- Priority levels (Low / Medium / High) with colour indicators
- Categories with colour coding
- Due date picker with overdue indicators
- Search and filter
- Google Sign-In (local profile storage)
- Local push notifications for due tasks
- Dark mode with system-preference detection
- Offline-first — all data stored locally (SQLite on Android, IndexedDB on Web)

## Prerequisites

| Tool | Version |
|---|---|
| Flutter SDK | >= 3.32.0 |
| Dart SDK | >= 3.3.0 (included with Flutter) |
| Java JDK | 17 (Android builds only) |
| Android SDK | API 21+ (Android builds only) |

Install Flutter: https://docs.flutter.dev/get-started/install

## Local Setup

```bash
git clone https://github.com/hhimzo/todo-app.git
cd todo-app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

## Running

### Web
```bash
flutter run -d chrome
```

### Android
```bash
flutter devices          # list connected devices / emulators
flutter run -d <device-id>
```

## Environment Variables

Copy `.env.example` to `.env` and fill in values. The app works without any env values — Google Sign-In will silently no-op if no client ID is configured.

| Variable | Description |
|---|---|
| `GOOGLE_CLIENT_ID_WEB` | OAuth 2.0 Client ID for Web (Google Cloud Console → Credentials) |
| `GOOGLE_CLIENT_ID_ANDROID` | OAuth 2.0 Client ID for Android |

## CI/CD

Two GitHub Actions workflows run automatically:

| Workflow | Trigger | What it does |
|---|---|---|
| `ci.yml` | PR to `main` | Lint, format check, tests, coverage artifact |
| `deploy.yml` | Push to `main` | Build web -> GitHub Pages; Build APK + AAB -> GitHub Release |

### Android Signing — Required GitHub Secrets

| Secret | How to generate |
|---|---|
| `KEYSTORE_BASE64` | `base64 -w 0 upload-keystore.jks` |
| `KEY_ALIAS` | The alias used when creating the keystore (e.g. `upload`) |
| `KEY_PASSWORD` | Key password |
| `STORE_PASSWORD` | Keystore password |

Generate an upload keystore:
```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Add secrets at: `https://github.com/hhimzo/todo-app/settings/secrets/actions`

## Architecture

Clean Architecture with three layers:

```
lib/
├── core/          # DI, routing, theme, constants
├── data/          # Drift database, repository implementations
├── domain/        # Entities, repository interfaces, use cases
└── presentation/  # Screens, widgets, Riverpod providers
```

See [DECISIONS.md](DECISIONS.md) for full stack rationale.

## Contributing

1. Fork and create a branch: `git checkout -b feat/my-feature`
2. Follow conventional commits: `feat:`, `fix:`, `chore:`, `docs:`
3. Ensure `flutter analyze` passes with zero warnings
4. Run `dart format .` before committing
5. Open a PR — the template will guide you

## Licence

MIT — see [LICENSE](LICENSE)
