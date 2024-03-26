abstract class SocketLogger {
  void onConnect({String? url});

  void onDisconnect({String? url});

  void onSend(String event, [dynamic data]);

  void onReceive(String event, dynamic data);

  void onError(dynamic error);
}
