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
  // Список предустановленных GitHub-источников / Брокеров
  static final List<BrokerProvider> defaultBrokers = [
    BrokerProvider(
      name: 'v2rayaggregator',
      url: 'https://raw.githubusercontent.com/v2rayaggregator/v2rayaggregator/main/aggregated_configs.txt',
    ),
    BrokerProvider(
      name: 'Free V2Ray GitHub',
      url: 'https://raw.githubusercontent.com/freefq/free/master/v2ray',
    ),
  ];

  // Скачивание и сохранение конфигов от выбранного брокера
  static Future<int> fetchFromBroker(BrokerProvider broker) async {
    try {
      final response = await http.get(Uri.parse(broker.url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final rawText = response.body;
        final newConfigs = ConfigParser.parseBulk(rawText);

        if (newConfigs.isNotEmpty) {
          final existing = await ConfigStorage.loadConfigs();
          existing.addAll(newConfigs);
          await ConfigStorage.saveConfigs(existing);
        }
        return newConfigs.length;
      }
    } catch (e) {
      // Ошибка сети или таймаут
    }
    return 0;
  }
}
