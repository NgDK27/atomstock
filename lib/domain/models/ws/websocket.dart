import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:oppenhomies/domain/helpers/market_hours_service.dart';

class WebSocketManager {
  WebSocketChannel? _channel;
  final String _wsUrl;

  WebSocketManager(this._wsUrl);

  Stream<dynamic> connect(String endpoint) {
    if (MarketHoursService.isMarketOpen()) {
      _channel = WebSocketChannel.connect(Uri.parse('$_wsUrl$endpoint'));
      return _channel!.stream;
    } else {
      return const Stream.empty();
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  bool get isConnected => _channel != null;
}