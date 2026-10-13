import 'package:flutter/services.dart';
import '../models/config_model.dart';

class VpnServiceChannel {
  static const MethodChannel _channel = MethodChannel('com.memento.vpn/service');

  // Запуск VPN с передачей сырой ссылки конфига
  static Future<bool> connect(VpnConfig config) async {
    try {
      final bool? result = await _channel.invokeMethod('connect', {
        'configUrl': config.rawUrl,
        'protocol': config.protocol.name,
        'name': config.name,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      print("Failed to connect VPN: '${e.message}'.");
      return false;
    }
  }

  // Остановка VPN
  static Future<bool> disconnect() async {
    try {
      final bool? result = await _channel.invokeMethod('disconnect');
      return result ?? false;
    } on PlatformException catch (e) {
      print("Failed to disconnect VPN: '${e.message}'.");
      return false;
    }
  }
}
