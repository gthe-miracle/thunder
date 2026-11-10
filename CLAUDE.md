# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`thunder` is a pub.dev Flutter package: a debug overlay that records HTTP traffic (via a middleware for `package:http`-based clients) and WebSocket traffic, shown in a slide-out panel. `example/` is a demo app depending on the package by path.

## Commands

There is no `.fvmrc`; `fvm` resolves to the global default SDK. The package requires Flutter `>=3.47.0` / Dart `^3.13.0`.

```bash
fvm flutter pub get
fvm flutter analyze                 # package and example/
fvm flutter test                    # whole suite
fvm flutter test test/thunder_sort_test.dart
fvm flutter test test/socket_client_test.dart --plain-name 'connects and echoes messages'
fvm dart format -l 80 <paths>
```

`.githooks/pre-commit` is opt-in (`git config core.hooksPath .githooks`). When active it runs `fvm dart format . -l 80` over the **whole tree** (re-staging only the already-staged files), then `fvm flutter analyze`, then `pana --exit-code-threshold 10` with a JSON report in `.pana_reports/`. A pub.dev score regression therefore blocks the commit.

## Public API and releases

`lib/thunder.dart` is the only public surface; everything else is under `lib/src/`. Adding an export is an API change. `public_member_api_docs` is on, so every public member needs a `///` doc comment.

A release is a `version` bump in `pubspec.yaml` plus a matching `CHANGELOG.md` entry describing user-visible behaviour.

## Architecture

### Thunder ships middleware types, not a client

`lib/src/common/extension/middleware_extensions.dart` defines `ApiClientHandler`, `ApiClientMiddleware`, `ApiClientRequest` (an extension type over `http.BaseRequest`), `ApiClientResponse` and `ApiClientException`. The host app owns the actual HTTP client and builds these values itself. The README links `example/lib/api_client.dart` as a reference implementation, but that file was removed; the example app currently demonstrates only the WebSocket side.

### Log state is static and app-lifetime

`ThunderLogsController` (`lib/src/feature/controllers/thunder_logs_controller.dart`) is both the `State` of the logs screen and the global store. Its static fields hold the HTTP log list, the socket session list, search, sort and the active tab. `_instance` points at the currently mounted state and is used only to trigger rebuilds.

This is what lets `Thunder.middleware` be captured before any `Thunder` widget exists and keep working across overlay remounts. The shared `ThunderMiddleware` is deliberately never reset in `dispose`. Consequences:

- Widget tests must reset the statics in `setUp` (see `test/thunder_logs_search_test.dart`).
- The toolbar buttons live outside the panel's `Navigator` and act through static methods (`toggleSearch`, `onSortLogsTap`, `onDeleteAllLogsTap`), which no-op while a detail screen is open.
- HTTP logs, socket sessions and per-session events are each capped at 1000, oldest dropped.

### HTTP flow

`Thunder.middleware` → `ThunderMiddleware.call` → `onNetworkActivity` fires **twice per request** (loading, then completed or errored) with the same `id` → upsert into `networkLogs` → `logNotifier.notify()`. Search never mutates the list; `visibleNetworkLogs` / `socketSessions` return a filtered view of the canonical list.

### WebSocket flow

One `ThunderWebSocketInterceptor` is one connection and one row in the Socket tab; it stamps every event with its `connectionId`. `SocketClient` (reconnecting client on `web_socket_channel`) calls the interceptor's `log*` methods; users with their own channel call them directly. `ThunderLogsController._onWebSocketLog` groups events by `connectionId` into a `ThunderWebSocketSession`, which is itself a `ChangeNotifier`.

The session detail screen listens to the session, not to the logs-screen notifiers, because the pushed route can outlive them. Sessions are dropped, never disposed.

`socket_client.dart` picks its connector by conditional import: `socket_connector_io.dart` on `dart:io`, `socket_connector.dart` on web, where `headers` and `pingInterval` are ignored.

### Notifications during build

Requests and socket connects are often started from `initState`, i.e. mid-build. Anything notified from a log event must go through `SafeChangeNotifier.notifyListenersSafely`, which defers to a post-frame callback during the persistent frame phase. `ThunderLogNotifier` and `ThunderWebSocketLogNotifier` carry no data; they are per-tab rebuild triggers so an HTTP event rebuilds only the HTTP list.

### Screen / controller split

Each stateful screen is three pieces: the `StatefulWidget`, an `abstract class XController extends State<XScreen>` holding fields, handlers and lifecycle, and a private `_XScreenState extends XController` containing only `build`. `Thunder` → `ThunderOverlayController` → `_ThunderState` follows the same shape.

### Panel theming

The panel is always dark and isolated from the host app: `_ThunderState` builds its `Theme` from `ThemeData.dark()` plus the `ThunderColors.dark` extension, and gives the panel its own `Navigator` and `ScaffoldMessenger`. Inside the panel, take colours from `ThunderColors.of(context)` and text styles from `Theme.of(context).textTheme.<style>?.copyWith(...)` so `Thunder(fontFamily:)` reaches every label. The font family must be declared by the host app's pubspec.

Large bodies are a known performance hazard: response bodies render line by line in a lazy list, and JSON pretty-printing runs through `compute` (not `Isolate.spawn`, which throws on web).

## Conventions the analyzer enforces

These apply to `lib/` and `test/`. `example/` has its own `analysis_options.yaml` with plain `flutter_lints`.

- Material widgets come from `package:material_ui/material_ui.dart` and Cupertino from `package:cupertino_ui/cupertino_ui.dart`, never the frozen SDK copies `package:flutter/material.dart` / `package:flutter/cupertino.dart`. The panel supplies both libraries' default localizations in `_ThunderState.build`, so it works under a host `MaterialApp` from either the SDK or `material_ui`.
- Relative imports inside `lib/`; tests import `package:thunder/thunder.dart` and reach internals via `package:thunder/src/...`.
- 80-column lines, expression-bodied members where possible, `on Object catch` instead of a bare `catch`, and `strict-casts` / `strict-raw-types` / `strict-inference`.
