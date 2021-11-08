part of sloth_chat;

class EventBusC {
  static EventBusC? _instance;
  EventBusC._();
  factory EventBusC() {
    _instance ??= EventBusC._();
    return _instance!;
  }

  final EventBus bus = EventBus();
}
