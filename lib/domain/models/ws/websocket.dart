import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:oppenhomies/domain/helpers/market_hours_service.dart';

class WebSocketManager {
  final Map<String, WebSocketChannel> _channels = {};
  final String _wsUrl;

  WebSocketManager(this._wsUrl);

  Stream<dynamic> connect(String endpoint) {
    if (MarketHoursService.isMarketOpen()) {
      if (!_channels.containsKey(endpoint)) {
        _channels[endpoint] = WebSocketChannel.connect(Uri.parse('$_wsUrl$endpoint'));
      }
      return _channels[endpoint]!.stream;
    } else {
      return const Stream.empty();
    }
  }

  void disconnect(String endpoint) {
    _channels[endpoint]?.sink.close();
    _channels.remove(endpoint);
  }

  void disconnectAll() {
    for (var channel in _channels.values) {
      channel.sink.close();
    }
    _channels.clear();
  }

  bool isConnected(String endpoint) => _channels.containsKey(endpoint);
}