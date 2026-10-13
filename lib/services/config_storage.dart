import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/config_model.dart';

class ConfigStorage {
  static const String _storageKey = 'saved_vpn_configs';

  // Сохранение всего списка
  static Future<void> saveConfigs(List<VpnConfig> configs) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = configs.map((c) => c.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  // Загрузка сохраненных конфигов
  static Future<List<VpnConfig>> loadConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => VpnConfig.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Очистка всех конфигов (для кнопки Clear All)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
