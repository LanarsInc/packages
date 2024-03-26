// ignore_for_file: noop_primitive_operations

import 'dart:math' as math;

abstract class Logger {
  Logger({
    this.maxWidth = 90,
    this.compact = true,
    this.logPrint = print,
  });

  /// InitialTab count to logPrint json response
  static const int initialTab = 1;

  /// 1 tab length
  static const String tabStep = '    ';

  /// Print compact json response
  final bool compact;

  /// Width size per logPrint
  final int maxWidth;

  /// Log printer; defaults logPrint log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file.
  void Function(Object object) logPrint;

  void printLine([String pre = '', String suf = '╝']) => logPrint('$pre${'═' * maxWidth}$suf');

  void printKV(String? key, Object? v) {
    final pre = '╟ $key: ';
    final msg = v.toString();

    if (pre.length + msg.length > maxWidth) {
      logPrint(pre);
      printBlock(msg);
    } else {
      logPrint('$pre$msg');
    }
  }

  void printBoxed({String? header, String? text}) {
    logPrint('');
    logPrint('╔╣ $header');
    logPrint('║  $text');
    printLine('╚');
  }

  void printBlock(String msg) {
    final lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      logPrint(
        (i >= 0 ? '║ ' : '') +
            msg.substring(i * maxWidth, math.min<int>(i * maxWidth + maxWidth, msg.length)),
      );
    }
  }

  String getIndent([int tabCount = initialTab]) => tabStep * tabCount;

  void printPrettyMap(
    Map data, {
    int tabs = initialTab,
    bool isListItem = false,
    bool isLast = false,
  }) {
    var localTabs = tabs;
    final isRoot = localTabs == initialTab;
    final initialIndent = getIndent(localTabs);
    localTabs++;

    if (isRoot || isListItem) logPrint('║$initialIndent{');

    data.keys.toList().asMap().forEach((index, key) {
      final isLast = index == data.length - 1;
      dynamic value = data[key];
      if (value is String) {
        value = '"${value.replaceAll(RegExp(r'([\r\n])+'), " ")}"';
      }
      if (value is Map) {
        if (compact && canFlattenMap(value)) {
          logPrint('║${getIndent(localTabs)} $key: $value${!isLast ? ',' : ''}');
        } else {
          logPrint('║${getIndent(localTabs)} $key: {');
          printPrettyMap(value, tabs: localTabs);
        }
      } else if (value is List) {
        if (compact && canFlattenList(value)) {
          logPrint('║${getIndent(localTabs)} $key: ${value.toString()}');
        } else {
          logPrint('║${getIndent(localTabs)} $key: [');
          printList(value, tabs: localTabs);
          logPrint('║${getIndent(localTabs)} ]${isLast ? '' : ','}');
        }
      } else {
        final msg = value.toString().replaceAll('\n', '');
        final indent = getIndent(localTabs);
        final linWidth = maxWidth - indent.length;
        if (msg.length + indent.length > linWidth) {
          final lines = (msg.length / linWidth).ceil();
          for (var i = 0; i < lines; ++i) {
            logPrint(
              '║${getIndent(localTabs)} ${msg.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, msg.length))}',
            );
          }
        } else {
          logPrint('║${getIndent(localTabs)} $key: $msg${!isLast ? ',' : ''}');
        }
      }
    });

    logPrint('║$initialIndent}${isListItem && !isLast ? ',' : ''}');
  }

  void printList(List list, {int tabs = initialTab}) {
    list.asMap().forEach((i, e) {
      final isLast = i == list.length - 1;
      if (e is Map) {
        if (compact && canFlattenMap(e)) {
          logPrint('║${getIndent(tabs)}  $e${!isLast ? ',' : ''}');
        } else {
          printPrettyMap(e, tabs: tabs + 1, isListItem: true, isLast: isLast);
        }
      } else {
        logPrint('║${getIndent(tabs + 2)} $e${isLast ? '' : ','}');
      }
    });
  }

  bool canFlattenMap(Map map) {
    return map.values.where((val) => val is Map || val is List).isEmpty &&
        map.toString().length < maxWidth;
  }

  bool canFlattenList(List list) {
    return list.length < 10 && list.toString().length < maxWidth;
  }

  void printMapAsTable(Map? map, {String? header}) {
    if (map == null || map.isEmpty) return;
    logPrint('╔ $header ');
    map.forEach((key, value) => printKV(key.toString(), value));
    printLine('╚');
  }
}
