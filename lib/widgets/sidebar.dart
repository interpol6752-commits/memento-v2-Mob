import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {'icon': Icons.download, 'title': 'Import Links'},
      {'icon': Icons.table_chart, 'title': 'Config Table'},
      {'icon': Icons.security, 'title': 'VPN Connection'},
      {'icon': Icons.edit, 'title': 'Editor'},
      {'icon': Icons.show_chart, 'title': 'Config Pinger'},
      {'icon': Icons.search, 'title': 'IP Scanner'},
      {'icon': Icons.share, 'title': 'Export'},
      {'icon': Icons.favorite, 'title': 'Donate ❤️'},
      {'icon': Icons.mail, 'title': 'Contact Me'},
    ];

    return Container(
      width: 70, // Сделали узкую аккуратную панель только для иконок
      color: AppTheme.sidebarBg,
      child: Column(
        children: [
          // Логотип (только иконка глаза)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.neonGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.visibility, color: AppTheme.neonGreen, size: 20),
            ),
          ),
          const Divider(color: AppTheme.cardBorder, height: 1),
          
          // Список иконок меню без текста
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.neonGreen.withOpacity(0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected ? Border.all(color: AppTheme.neonGreen.withOpacity(0.4)) : null,
                  ),
                  child: IconButton(
                    icon: Icon(
                      menuItems[index]['icon'] as IconData,
                      color: isSelected ? AppTheme.neonGreen : AppTheme.textMuted,
                      size: 20,
                    ),
                    onPressed: () => onItemSelected(index),
                    tooltip: menuItems[index]['title'] as String,
                  ),
                );
              },
            ),
          ),

          // Компактный индикатор конфигов внизу
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: const Column(
                children: [
                  Icon(Icons.check_circle, color: AppTheme.neonGreen, size: 14),
                  SizedBox(height: 2),
                  Text('10', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
