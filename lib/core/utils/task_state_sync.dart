import 'dart:async';

class TaskStateSyncEvent {
  const TaskStateSyncEvent({
    required this.reason,
    required this.timestamp,
  });

  final String reason;
  final DateTime timestamp;
}

class TaskStateSync {
  static final StreamController<TaskStateSyncEvent> _controller =
      StreamController<TaskStateSyncEvent>.broadcast();

  static Stream<TaskStateSyncEvent> get stream => _controller.stream;

  static void emit(String reason) {
    if (_controller.isClosed) {
      return;
    }
    _controller.add(
      TaskStateSyncEvent(
        reason: reason,
        timestamp: DateTime.now(),
      ),
    );
  }
}
