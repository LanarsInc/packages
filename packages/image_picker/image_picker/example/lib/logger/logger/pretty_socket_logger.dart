
import 'package:image_picker_example/logger/logger/logger.dart';
import 'package:image_picker_example/logger/logger/socket_logger.dart';

class PrettySocketLogger extends Logger implements SocketLogger {
  PrettySocketLogger({
    super.maxWidth = 90,
    super.compact = true,
    super.logPrint = print,
  });

  @override
  void onConnect({String? url}) => printBoxed(header: '✅CONNECTED✅', text: url);

  @override
  void onDisconnect({String? url}) => printBoxed(header: '❌DISCONNECTED❌', text: url);

  @override
  void onSend(String event, [dynamic data]) {
    _printHeader('Send', event);

    if (data != null) {
      logPrint('╔ Data');
      logPrint('║');

      if (data is Map) {
        printPrettyMap(data);
      } else {
        printBlock(data.toString());
      }

      logPrint('║');
      printLine('╚');
    }
  }

  @override
  void onReceive(String event, dynamic data) {
    _printHeader('Receive', event);

    if (data != null) {
      logPrint('╔ Data');
      logPrint('║');
      _printBody(data);
      logPrint('║');
      printLine('╚');
    }
  }

  void _printHeader(String title, String event) {
    logPrint('');
    logPrint('╔╣ $title ║ $event');
    printLine('╚');
  }

  void _printBody(dynamic data) {
    if (data != null) {
      if (data is Map) {
        printPrettyMap(data);
      } else if (data is List) {
        logPrint('║${getIndent()}[');
        printList(data);
        logPrint('║${getIndent()}]');
      } else {
        printBlock(data.toString());
      }
    }
  }

  @override
  void onError(dynamic error) {
    if (error != null) {
      if (error is Map) {
        printMapAsTable(error, header: 'Error');
      } else {
        printBoxed(header: 'Unexpected error', text: error.toString());
      }
    }
  }
}
