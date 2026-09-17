# flutter-task-app

Flutter client + Go REST API，本地可跑通 CRUD 子集（list / create / complete）。

**Pair:** [go-tasks-api](https://github.com/YOUR_USER/go-tasks-api) — run this API first.

Portfolio sample, not production.

## Screenshots

Add `screenshots/list.png` (and optional `complete.png`) after you run the app locally.

## Stack

Flutter / Dart, `http` for REST.

## Run (≈2 min)

1. Start the Go API (sibling repo or your clone of `go-tasks-api`):

```bash
go run ./cmd/server
```

2. In this repo:

```bash
flutter pub get
flutter run
```

Default API base URL: `http://127.0.0.1:8080`.

Override for device/emulator:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

(Use `10.0.2.2` for the Android emulator; iOS simulator and desktop can use `127.0.0.1`.)

## Features

- List tasks on launch (no login)
- Create task
- Tap open task to complete

## Quality

```bash
flutter analyze
flutter test
```
