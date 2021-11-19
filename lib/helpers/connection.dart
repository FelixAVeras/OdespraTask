import 'dart:io';

enum ConnectionStatus { connected, disconnected }

const List<String> checkUrls = ["google.com", "github.com", "amis.odespra.dev"];

class Connection {
  static Future<ConnectionStatus> checkConnection() async {
    ConnectionStatus connectionStatus = ConnectionStatus.disconnected;

    for (final url in checkUrls) {
      try {
        final result = await InternetAddress.lookup(url);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          connectionStatus = ConnectionStatus.connected;
          break;
        }
      } on SocketException catch (_) {
        connectionStatus = ConnectionStatus.disconnected;
      }
    }
    return connectionStatus;
  }
}
