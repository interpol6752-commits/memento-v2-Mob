import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ImportLinksScreen extends StatelessWidget {
  const ImportLinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Import Links', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 6),
          const Text('Bring your V2Ray configs into MEMENTO from text, clipboard or subscription URL.', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: const TextField(
                maxLines: null,
                expands: true,
                style: TextStyle(color: AppTheme.neonGreen, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Paste configs here (vless://, vmess://, trojan://)...',
                  hintStyle: TextStyle(color: AppTheme.textMuted),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
