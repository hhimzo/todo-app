# Google Play Store Readiness Checklist

## App Signing

- [ ] Generate upload key:
  ```bash
  keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
  ```
- [ ] Enrol in Google Play App Signing (recommended): upload key signs the AAB; Google re-signs for distribution
- [ ] Store upload keystore securely — if lost, the app cannot be updated
- [ ] `upload-keystore.jks` is in `.gitignore` ✓

## Target SDK

| Setting | Value | Justification |
|---|---|---|
| `minSdkVersion` | 21 (Android 5.0) | Covers 99%+ of active devices; required by several Flutter plugins |
| `targetSdkVersion` | 34 (Android 14) | Required by Google Play for new apps as of August 2024 |
| `compileSdkVersion` | 34 | Matches target |

## Required Store Metadata

- [ ] App icon: 512×512 PNG (no transparency, no rounded corners — Play adds them)
- [ ] Feature graphic: 1024×500 PNG
- [ ] Screenshots: min 2, max 8 per form factor (phone, 7" tablet, 10" tablet)
- [ ] Short description (≤80 chars): `Offline-first Todo app. Tasks, priorities, due dates, and dark mode.`
- [ ] Full description (≤4000 chars): see below
- [ ] Category: Productivity
- [ ] Content rating questionnaire: "Everyone"

## Full Description Draft

```
Stay organised with a clean, fast, and fully offline Todo app.

Features:
• Create and manage tasks with priorities and due dates
• Organise tasks into colour-coded categories
• Search and filter your task list
• Sign in with Google to personalise your experience
• Get notified before tasks are due
• Beautiful dark mode with automatic system detection
• Works completely offline — your data never leaves your device
```

## Privacy Policy

- [ ] Deploy `web/privacy/index.html` to GitHub Pages
- URL: `https://hhimzo.github.io/todo-app/privacy/`
- [ ] Enter this URL in the Play Console privacy policy field

## Data Safety Form

Since all storage is local-only:

- [ ] "Does your app collect or share user data?" → **No** (for task data)
- [ ] Declare Google account info: Name, Email → Collected, not shared, optional (user-initiated)
- [ ] Notifications: no data collected

## Pre-launch Checklist

- [ ] `flutter analyze` zero warnings
- [ ] Test on Android API 21 emulator (minSdk)
- [ ] Test on Android API 34 emulator (targetSdk)
- [ ] App does not crash on first launch
- [ ] Notification permission dialog shown with rationale before OS prompt
- [ ] Back navigation correct on all screens
- [ ] App works fully offline
