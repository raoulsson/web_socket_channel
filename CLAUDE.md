# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Forked Dart package (`web_socket_channel`) providing cross-platform WebSocket `StreamChannel` wrappers. Adds connection timeout support and async connection establishment on top of the original `dart-lang/web_socket_channel`.

## Common Commands

```bash
# Install dependencies
dart pub get

# Run all tests
dart test

# Run a single test file
dart test test/io_test.dart

# Run VM-only or browser-only tests
dart test --platform vm
dart test --platform chrome

# Static analysis
dart analyze

# Format code (check mode, used in CI)
dart format --output=none --set-exit-if-changed .

# Format code (apply)
dart format .
```

## Architecture

Three-layer design for cross-platform WebSocket communication:

1. **Public API** (`lib/web_socket_channel.dart`, `lib/io.dart`, `lib/html.dart`, `lib/status.dart`) — Entry points consumers import. Platform selection uses Dart conditional imports (`if (dart.library.io)` / `if (dart.library.html)`).

2. **Core implementation** (`lib/src/channel.dart`) — `WebSocketChannel` class implements `StreamChannelMixin`. Key concepts:
   - `ready` Future — must be awaited before sending data
   - `WebSocketSink` — extends `DelegatingStreamSink` with `close(closeCode, closeReason)`
   - `WebSocketSinkCompleter` — async sink initialization pattern
   - Platform-specific connect logic in `_connect_io.dart` / `_connect_html.dart` / `_connect_api.dart`

3. **Protocol layer** (`lib/src/copy/`) — WebSocket protocol implementation copied from the Dart SDK. Handles framing, masking, ping/pong, and state transitions.

Platform implementations:
- `IOWebSocketChannel` — wraps `dart:io` WebSocket, supports custom `HttpClient`, `connectWebSocketChannel()` for fail-fast async connect
- `HtmlWebSocketChannel` — wraps `dart:html` WebSocket, supports `binaryType` control

## Code Style

- Line length: 80 characters
- Strict casts enabled (`strict-casts: true`)
- Linter extends `package:pedantic` with 70+ additional rules
- Prefer relative imports, `const` constructors, final locals, expression function bodies
- `package_api_docs` required for public API

## SDK and Dependencies

- Dart SDK: `>=3.0.0 <4.0.0`, Flutter: `>=3.0.0`
- Core deps: `async`, `crypto` (WebSocket handshake signing), `stream_channel`

## Testing Notes

- Tests use `@TestOn('vm')` and `@TestOn('browser')` annotations for platform-specific tests
- IO tests start a local `HttpServer` with `shelf` for WebSocket echo testing
- HTML tests require Chrome (`--platform chrome`)
