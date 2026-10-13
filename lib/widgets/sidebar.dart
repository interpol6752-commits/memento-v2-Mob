import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
      {'icon': LucideIcons.download, 'title': 'Import Links'},
      {'icon': LucideIcons.table, 'title': 'Config Table'},
      {'icon': LucideIcons.shield, 'title': 'VPN Connection'},
      {'icon': LucideIcons.edit3, 'title': 'Editor'},
      {'icon': LucideIcons.activity, 'title': 'Config Pinger'},
      {'icon': LucideIcons.search, 'title': 'IP Scanner'},
      {'icon': LucideIcons.share2, 'title': 'Export'},
      {'icon': LucideIcons.heart, 'title': 'Donate ❤️'},
      {'icon': LucideIcons.mail, 'title': 'Contact Me'},
    ];

    return Container(
      width: 250,
      color: AppTheme.sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.neonGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(LucideIcons.eye, color: AppTheme.neonGreen),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MEMENTO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                    Text('FROM EPODONIOS TO A WHO', style: TextStyle(fontSize: 7, color: AppTheme.textMuted)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: AppTheme.cardBorder, height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.neonGreen.withOpacity(0.12) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected ? Border.all(color: AppTheme.neonGreen.withOpacity(0.3)) : null,
                  ),
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      menuItems[index]['icon'] as IconData,
                      color: isSelected ? AppTheme.neonGreen : AppTheme.textMuted,
                      size: 18,
                    ),
                    title: Text(
                      menuItems[index]['title'] as String,
                      style: TextStyle(
                        color: isSelected ? AppTheme.neonGreen : AppTheme.textLight,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                    onTap: () => onItemSelected(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: const Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Total Configs', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                    Text('10', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ]),
                  SizedBox(height: 6),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: [
                      CircleAvatar(radius: 3, backgroundColor: AppTheme.neonGreen),
                      SizedBox(width: 6),
                      Text('Valid', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                    ]),
                    Text('10', style: TextStyle(color: AppTheme.neonGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                  ]),
                  SizedBox(height: 6),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: [
                      CircleAvatar(radius: 3, backgroundColor: Colors.red),
                      SizedBox(width: 6),
                      Text('Invalid', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                    ]),
                    Text('0', style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
