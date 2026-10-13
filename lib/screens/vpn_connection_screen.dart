import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/config_model.dart';
import '../services/config_storage.dart';

class VpnConnectionScreen extends StatefulWidget {
  final VpnConfig? selectedConfig;

  const VpnConnectionScreen({super.key, this.selectedConfig});

  @override
  State<VpnConnectionScreen> createState() => _VpnConnectionScreenState();
}

class _VpnConnectionScreenState extends State<VpnConnectionScreen>
    with SingleTickerProviderStateMixin {
  bool _isConnected = false;
  bool _autoFailover = true;
  bool _isSystemProxy = true;
  
  List<VpnConfig> _configs = [];
  VpnConfig? _currentConfig;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _loadConfigs();

    // Плавная анимация «дыхания» неоновой подсветки при подключении
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 2.0, end: 12.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadConfigs() async {
    final loaded = await ConfigStorage.loadConfigs();
    setState(() {
      _configs = loaded;
      if (widget.selectedConfig != null) {
        _currentConfig = widget.selectedConfig;
      } else if (_configs.isNotEmpty) {
        _currentConfig = _configs.first;
      }
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _toggleConnection() {
    setState(() {
      _isConnected = !_isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'VPN Connection',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Connect to a V2Ray server and tunnel your system through it.',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 20),

          // Главный блок статуса с неоновой подсветкой
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isConnected ? AppTheme.neonGreen : AppTheme.cardBorder,
                    width: _isConnected ? 2 : 1,
                  ),
                  boxShadow: _isConnected
                      ? [
                          BoxShadow(
                            color: AppTheme.neonGreen.withOpacity(0.4),
                            blurRadius: _glowAnimation.value,
                            spreadRadius: 1,
                          )
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isConnected ? Icons.security : Icons.shield_outlined,
                          color: _isConnected ? AppTheme.neonGreen : Colors.white54,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isConnected ? 'Connected' : 'Disconnected',
                              style: TextStyle(
                                color: _isConnected ? AppTheme.neonGreen : Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _currentConfig != null ? _currentConfig!.name : 'No config selected',
                              style: const TextStyle(color: Colors.white54, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _currentConfig == null ? null : _toggleConnection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isConnected ? Colors.redAccent.withOpacity(0.2) : AppTheme.neonGreen,
                        foregroundColor: _isConnected ? Colors.redAccent : Colors.black,
                        side: _isConnected ? const BorderSide(color: Colors.redAccent) : null,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(_isConnected ? 'Disconnect' : 'Connect'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Auto Failover блок
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.autorenew, color: AppTheme.neonGreen, size: 20),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Auto Failover', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text('Auto-switch config if connection drops', style: TextStyle(color: Colors.white54, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                Switch(
                  value: _autoFailover,
                  activeColor: AppTheme.neonGreen,
                  onChanged: (val) => setState(() => _autoFailover = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Выбор активного конфига
          const Text('Select a Config', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<VpnConfig>(
                value: _currentConfig,
                dropdownColor: AppTheme.cardBg,
                isExpanded: true,
                hint: const Text('Choose a V2Ray config...', style: TextStyle(color: Colors.white30, fontSize: 12)),
                items: _configs.map((cfg) {
                  return DropdownMenuItem<VpnConfig>(
                    value: cfg,
                    child: Text('${cfg.name} (${cfg.protocol.name.toUpperCase()})', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _currentConfig = val;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
