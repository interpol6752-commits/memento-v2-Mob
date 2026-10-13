import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class ConfigTableScreen extends StatelessWidget {
  const ConfigTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final configs = [
      {'name': 'CA ca | @Raydikalx', 'protocol': 'VLESS', 'address': 'saas.sin.fan', 'port': '443', 'status': 'Valid'},
      {'name': 'DE de | @Raydikalx', 'protocol': 'TROJAN', 'address': '185.137.157.135', 'port': '443', 'status': 'Valid'},
      {'name': 'DE de | @Raydikalx', 'protocol': 'TROJAN', 'address': '185.137.157.140', 'port': '443', 'status': 'Valid'},
      {'name': 'EE ee | @Raydikalx', 'protocol': 'VLESS', 'address': '185.155.97.58', 'port': '45176', 'status': 'Valid'},
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Config Table', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 6),
          const Text('Browse every imported config in a powerful table.', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: ListView.separated(
                itemCount: configs.length,
                separatorBuilder: (_, __) => const Divider(color: AppTheme.cardBorder, height: 1),
                itemBuilder: (context, index) {
                  final item = configs[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(LucideIcons.circleDot, size: 14, color: AppTheme.neonGreen),
                    title: Row(
                      children: [
                        Expanded(flex: 3, child: Text(item['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        Expanded(flex: 2, child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppTheme.neonGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                          child: Text(item['protocol']!, style: const TextStyle(color: AppTheme.neonGreen, fontSize: 11), textAlign: TextAlign.center),
                        )),
                        Expanded(flex: 3, child: Text(item['address']!, style: const TextStyle(color: AppTheme.textMuted))),
                        Expanded(flex: 1, child: Text(item['port']!, style: const TextStyle(color: AppTheme.textMuted))),
                        const Expanded(flex: 1, child: Text('Valid', style: TextStyle(color: AppTheme.neonGreen))),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
