import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/sidebar.dart';
import 'screens/import_links_screen.dart';
import 'screens/config_table_screen.dart';
import 'screens/vpn_connection_screen.dart';
import 'screens/editor_screen.dart';
import 'screens/config_pinger_screen.dart';
import 'screens/donate_screen.dart';

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
      home: const MainDashboard(),
    );
  }
}

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 2; // По умолчанию VPN Connection

  final List<Widget> _screens = [
    const ImportLinksScreen(),
    const ConfigTableScreen(),
    const VpnConnectionScreen(),
    const EditorScreen(),
    const ConfigPingerScreen(),
    const Center(child: Text('IP Scanner', style: TextStyle(color: Colors.white))),
    const Center(child: Text('Export', style: TextStyle(color: Colors.white))),
    const DonateScreen(),
    const Center(child: Text('Contact Me', style: TextStyle(color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: Container(
              color: AppTheme.background,
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
