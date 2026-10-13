import 'package:http/http.dart' as http;
import '../models/config_model.dart';
import 'config_parser.dart';
import 'config_storage.dart';

class BrokerProvider {
  final String name;
  final String url;

  BrokerProvider({required this.name, required this.url});
}

class BrokerService {
  // Список надежных публичных источников с сырыми конфигами
  static final List<BrokerProvider> defaultBrokers = [
    BrokerProvider(
      name: 'v2rayaggregator (Main)',
      url: 'https://raw.githubusercontent.com/v2rayaggregator/v2rayaggregator/main/aggregated_configs.txt',
    ),
    BrokerProvider(
      name: 'FreeFQ V2Ray List',
      url: 'https://raw.githubusercontent.com/freefq/free/master/v2ray',
    ),
    BrokerProvider(
      name: 'EmarProject Configs',
      url: 'https://raw.githubusercontent.com/EmarProject/free-v2ray-configs/main/configs.txt',
    ),
  ];

  // Скачивание с детальным возвратом ошибки
  static Future<Map<String, dynamic>> fetchFromBroker(BrokerProvider broker) async {
    try {
      final response = await http.get(Uri.parse(broker.url)).timeout(const Duration(seconds: 15));
      
      if (response.statusCode == 200) {
        final rawText = response.body;
        if (rawText.trim().isEmpty) {
          return {'count': 0, 'error': 'Получен пустой файл от репозитория'};
        }

        final newConfigs = ConfigParser.parseBulk(rawText);

        if (newConfigs.isNotEmpty) {
          final existing = await ConfigStorage.loadConfigs();
          existing.addAll(newConfigs);
          await ConfigStorage.saveConfigs(existing);
          return {'count': newConfigs.length, 'error': null};
        } else {
          return {'count': 0, 'error': 'В файле нет валидных протоколов (vless://, vmess:// и др.)'};
        }
      } else {
        return {'count': 0, 'error': 'Ошибка сервера: HTTP ${response.statusCode}'};
      }
    } catch (e) {
      return {'count': 0, 'error': 'Сетевая ошибка: проверь интернет'};
    }
  }
}
