import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Donate ❤️', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 6),
          Text('If this program made your life easier, feel free to support!', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
        ],
      ),
    );
  }
}
