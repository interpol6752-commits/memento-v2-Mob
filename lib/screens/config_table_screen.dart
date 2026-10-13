import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme/app_theme.dart';
import '../models/config_model.dart';
import '../services/config_storage.dart';
import '../services/broker_service.dart';

class ConfigTableScreen extends StatefulWidget {
  final Function(VpnConfig) onSelectAndConnect;

  const ConfigTableScreen({super.key, required this.onSelectAndConnect});

  @override
  State<ConfigTableScreen> createState() => _ConfigTableScreenState();
}

class _ConfigTableScreenState extends State<ConfigTableScreen> {
  List<VpnConfig> _configs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loaded = await ConfigStorage.loadConfigs();
    setState(() {
      _configs = loaded;
    });
  }

  // Окно генерации QR-кода
  void _showQrDialog(VpnConfig config) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        title: Text(config.name, style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: SizedBox(
          width: 200,
          height: 200,
          child: Center(
            child: QrImageView(
              data: config.rawUrl,
              version: QrVersions.auto,
              size: 200.0,
              eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppTheme.neonGreen),
              dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Colors.white),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppTheme.neonGreen)),
          ),
        ],
      ),
    );
  }

  // Окно Брокеров (GitHub Репозитории) с обработкой ошибок
  void _showBrokersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        title: const Text('Select Broker (GitHub)', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: BrokerService.defaultBrokers.map((broker) {
            return ListTile(
              title: Text(broker.name, style: const TextStyle(color: Colors.white, fontSize: 13)),
              subtitle: Text(broker.url, style: const TextStyle(color: Colors.white38, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.download, color: AppTheme.neonGreen),
              onTap: () async {
                Navigator.pop(context);
                setState(() => _isLoading = true);
                
                final result = await BrokerService.fetchFromBroker(broker);
                final count = result['count'] as int;
                final error = result['error'] as String?;

                await _loadData();
                setState(() => _isLoading = false);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        count > 0 
                            ? 'Успешно загружено конфигов: $count!' 
                            : 'Сбой брокера: ${error ?? "Неизвестная ошибка"}',
                      ),
                      backgroundColor: count > 0 ? AppTheme.neonGreen : Colors.redAccent,
                    ),
                  );
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Шапка и кнопки управления
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Config Table',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _showBrokersDialog,
                    icon: const Icon(Icons.hub, size: 14),
                    label: const Text('Brokers'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent.withOpacity(0.2),
                      foregroundColor: Colors.purpleAccent,
                      side: const BorderSide(color: Colors.purpleAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Список конфигов
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.neonGreen))
                : _configs.isEmpty
                    ? const Center(child: Text('Нет конфигов. Используй Import или Brokers!', style: TextStyle(color: Colors.white30)))
                    : ListView.builder(
                        itemCount: _configs.length,
                        itemBuilder: (context, index) {
                          final cfg = _configs[index];
                          return Card(
                            color: AppTheme.cardBg,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: AppTheme.cardBorder),
                            ),
                            child: ListTile(
                              title: Text(cfg.name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                '${cfg.protocol.name.toUpperCase()} • ${cfg.address}:${cfg.port}',
                                style: const TextStyle(color: Colors.white54, fontSize: 11),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.qr_code, color: Colors.white70, size: 18),
                                    onPressed: () => _showQrDialog(cfg),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.play_arrow, color: AppTheme.neonGreen, size: 20),
                                    onPressed: () => widget.onSelectAndConnect(cfg),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
