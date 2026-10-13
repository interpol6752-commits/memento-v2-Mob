import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ConfigPingerScreen extends StatelessWidget {
  const ConfigPingerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Config Pinger', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 6),
          Text('Measure the latency of each config server in real-time.', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
        ],
      ),
    );
  }
}
