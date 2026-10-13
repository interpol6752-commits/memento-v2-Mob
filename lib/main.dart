import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'models/config_model.dart';
import 'screens/import_links_screen.dart';
import 'screens/config_table_screen.dart';
import 'screens/vpn_connection_screen.dart';

void main() {
  runApp(const MementoApp());
}

class MementoApp extends StatelessWidget {
  const MementoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEMENTO VPN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 2; // По умолчанию открыт VPN Connection (индекс 2)
  VpnConfig? _selectedConfigToConnect;

  // Переключение на экран подключения с выбранным конфигом
  void _selectAndConnect(VpnConfig config) {
    setState(() {
      _selectedConfigToConnect = config;
      _selectedIndex = 2; // Переход на вкладку VPN Connection
    });
  }

  @override
  Widget build(BuildContext context) {
    // Список экранов приложения
    final List<Widget> screens = [
      const ImportLinksScreen(),
      ConfigTableScreen(onSelectAndConnect: _selectAndConnect),
      VpnConnectionScreen(selectedConfig: _selectedConfigToConnect),
      // Остальные экраны-заглушки или кастомные экраны под Editor, Donate и т.д.
      const Center(child: Text('Editor (Coming Soon)', style: TextStyle(color: Colors.white54))),
      const Center(child: Text('Config Pinger (Coming Soon)', style: TextStyle(color: Colors.white54))),
      const Center(child: Text('IP Scanner (Coming Soon)', style: TextStyle(color: Colors.white54))),
      const Center(child: Text('Export (Coming Soon)', style: TextStyle(color: Colors.white54))),
      // Donate со ссылкой на репозиторий
      Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Donate ❤️', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Проект создан на основе репозитория:', style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 8),
            SelectableText(
              'https://github.com/interpol6752-commits/memento-v2-Mob/tree/main',
              style: TextStyle(color: AppTheme.neonGreen, fontSize: 13),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      body: Row(
        children: [
          // Компактный левый сайдбар (иконки)
          Container(
            width: 70,
            color: AppTheme.cardBg,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _sidebarItem(Icons.download, 0, 'Import'),
                _sidebarItem(Icons.table_chart, 1, 'Table'),
                _sidebarItem(Icons.security, 2, 'VPN'),
                _sidebarItem(Icons.edit, 3, 'Editor'),
                _sidebarItem(Icons.bolt, 4, 'Pinger'),
                _sidebarItem(Icons.radar, 5, 'Scanner'),
                _sidebarItem(Icons.share, 6, 'Export'),
                _sidebarItem(Icons.favorite, 7, 'Donate'),
              ],
            ),
          ),
          // Основная рабочая область
          Expanded(
            child: Container(
              color: AppTheme.bgDark,
              child: screens[_selectedIndex < screens.length ? _selectedIndex : 2],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, int index, String tooltip) {
    final isSelected = _selectedIndex == index;
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? AppTheme.neonGreen : Colors.white38,
        size: 22,
      ),
      tooltip: tooltip,
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}
