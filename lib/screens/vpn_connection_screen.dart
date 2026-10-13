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
    with TickerProviderStateMixin {
  bool _isConnected = false;
  bool _autoFailover = true;
  
  List<VpnConfig> _configs = [];
  VpnConfig? _currentConfig;

  // Контроллеры для анимации дыхания и RGB-перелива
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  late AnimationController _rgbController;

  @override
  void initState() {
    super.initState();
    _loadConfigs();

    // Анимация пульсации (дыхание)
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 6.0, _end: 22.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Контроллер для полного RGB-перелива цветов
    _rgbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  Future<void> _loadConfigs() async {
    final loaded = await ConfigStorage.loadConfigs();
    setState(() {
      _configs = loaded;
      if (widget.selectedConfig != null) {
        _currentConfig = widget.selectedConfig;
      } else if (_configs.isNotEmpty && _currentConfig == null) {
        _currentConfig = _configs.first;
      }
    });
  }

  @override
  void didUpdateWidget(covariant VpnConnectionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedConfig != null) {
      setState(() {
        _currentConfig = widget.selectedConfig;
      });
    }
    _loadConfigs();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _rgbController.dispose();
    super.dispose();
  }

  void _toggleConnection() {
    setState(() {
      _isConnected = !_isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Заголовок
                const Text(
                  'MEMENTO VPN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Cyberpunk Xray Core Client',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 32),

                // Выпадающий список конфигов (выровненный и симметричный)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.cardBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<VpnConfig>(
                      value: _currentConfig,
                      dropdownColor: AppTheme.cardBg,
                      isExpanded: true,
                      hint: const Text(
                        'Select a configuration...',
                        style: TextStyle(color: Colors.white30, fontSize: 13),
                      ),
                      items: _configs.map((cfg) {
                        return DropdownMenuItem<VpnConfig>(
                          value: cfg,
                          child: Text(
                            '${cfg.name} (${cfg.protocol.name.toUpperCase()})',
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                          ),
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
                const SizedBox(height: 48),

                // ИДЕАЛЬНО КРУГЛАЯ RGB / НЕОНОВАЯ КНОПКА ПОДКЛЮЧЕНИЯ
                AnimatedBuilder(
                  animation: Listenable.merge([_glowAnimation, _rgbController]),
                  builder: (context, child) {
                    // Вычисляем текущий цвет для Full RGB перелива
                    final double hue = _rgbController.value * 360;
                    final Color rgbColor = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
                    
                    final activeColor = _isConnected ? rgbColor : AppTheme.neonGreen;

                    return GestureDetector(
                      onTap: _currentConfig == null ? null : _toggleConnection,
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.cardBg,
                          border: Border.all(
                            color: _isConnected ? activeColor : AppTheme.cardBorder,
                            width: 3.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (_isConnected ? activeColor : Colors.white24).withOpacity(0.6),
                              blurRadius: _glowAnimation.value,
                              spreadRadius: _glowAnimation.value / 2.5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              _isConnected ? Icons.power_settings_new : Icons.shield_outlined,
                              size: 52,
                              color: _isConnected ? activeColor : Colors.white70,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _isConnected ? 'ACTIVE' : 'CONNECT',
                              style: TextStyle(
                                color: _isConnected ? activeColor : Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 48),

                // Auto Failover блок (ровный и аккуратный)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.cardBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.autorenew, color: AppTheme.neonGreen, size: 22),
                          SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Auto Failover', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                              SizedBox(height: 2),
                              Text('Switch config on network drop', style: TextStyle(color: Colors.white54, fontSize: 11)),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
