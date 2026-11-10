/// The lifecycle state of a WebSocket connection.
///
/// Emitted by `SocketClient.states` and recorded in the Thunder Socket
/// timeline. The concrete states are:
///
/// - [SocketConnecting] — the very first connection attempt is in progress
/// - [SocketConnected] — the connection is established
/// - [SocketReconnecting] — the connection dropped and a retry is pending
/// - [SocketDisconnected] — the connection is down
sealed class const SocketState() {
  /// Const constructor shared by all concrete states.
  this;
}

/// The initial connection attempt is in progress.
final class const SocketConnecting() extends SocketState {
  /// Creates a [SocketConnecting] state.
  this;

  @override
  String toString() => 'SocketConnecting()';
}

/// The connection is established and messages can be exchanged.
final class const SocketConnected() extends SocketState {
  /// Creates a [SocketConnected] state.
  this;

  @override
  String toString() => 'SocketConnected()';
}

/// The connection dropped and a reconnect attempt is pending or running.
final class const SocketReconnecting({
  /// The 1-based number of the pending reconnect attempt.
  ///
  /// Resets after every successful connection.
  required final int attempt,
}) extends SocketState {
  /// Creates a [SocketReconnecting] state for the given [attempt].
  this;

  @override
  String toString() => 'SocketReconnecting(attempt: $attempt)';
}

/// The connection is down.
///
/// Carries optional details about why it went down: a close frame's
/// [closeCode]/[closeReason] or the [error] that broke the connection.
final class const SocketDisconnected({
  /// The WebSocket close code, when a close frame was received or sent.
  final int? closeCode,

  /// The WebSocket close reason, when a close frame was received or sent.
  final String? closeReason,

  /// The error that caused the disconnect, when the connection failed
  /// rather than closed cleanly.
  final Object? error,
}) extends SocketState {
  /// Creates a [SocketDisconnected] state.
  this;

  @override
  String toString() =>
      'SocketDisconnected('
      'closeCode: $closeCode, '
      'closeReason: $closeReason, '
      'error: $error)';
}
