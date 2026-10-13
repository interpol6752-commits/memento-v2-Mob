enum ProxyProtocol { vless, vmess, trojan, shadowsocks, unknown }

class VpnConfig {
  final String id;
  final String name;
  final ProxyProtocol protocol;
  final String address;
  final int port;
  final String rawUrl;
  int? ping;
  bool isValid;

  VpnConfig({
    required this.id,
    required this.name,
    required this.protocol,
    required this.address,
    required this.port,
    required this.rawUrl,
    this.ping,
    this.isValid = true,
  });

  // Преобразование в Map для локального сохранения
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'protocol': protocol.toString(),
        'address': address,
        'port': port,
        'rawUrl': rawUrl,
        'ping': ping,
        'isValid': isValid,
      };

  // Чтение из Map
  factory VpnConfig.fromJson(Map<String, dynamic> json) => VpnConfig(
        id: json['id'] as String,
        name: json['name'] as String,
        protocol: ProxyProtocol.values.firstWhere(
          (e) => e.toString() == json['protocol'],
          orElse: () => ProxyProtocol.unknown,
        ),
        address: json['address'] as String,
        port: json['port'] as int,
        rawUrl: json['rawUrl'] as String,
        ping: json['ping'] as int?,
        isValid: json['isValid'] as bool? ?? true,
      );
}
