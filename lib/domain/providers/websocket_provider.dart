import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:oppenhomies/domain/models/ws/websocket.dart';

part 'websocket_provider.g.dart';

@riverpod
WebSocketManager webSocketManager(WebSocketManagerRef ref) {
  final manager = WebSocketManager('ws://10.147.20.102:8080');
  ref.onDispose(() => manager.disconnectAll());
  return manager;
}