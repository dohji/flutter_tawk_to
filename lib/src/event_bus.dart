// event_bus.dart
import 'package:event_bus/event_bus.dart';

// Create a global EventBus instance
final EventBus eventBus = EventBus();

// Define an event class for agent messages
class AgentMessageEvent {
  final String message;
  AgentMessageEvent(this.message);
}