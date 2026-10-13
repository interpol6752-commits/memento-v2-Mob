import '../models/config_model.dart';

class ConfigParser {
  static VpnConfig? parseUrl(String rawUrl) {
    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty) return null;

    try {
      final uri = Uri.parse(trimmed);
      final scheme = uri.scheme.toLowerCase();

      ProxyProtocol protocol;
      switch (scheme) {
        case 'vless':
          protocol = ProxyProtocol.vless;
          break;
        case 'vmess':
          protocol = ProxyProtocol.vmess;
          break;
        case 'trojan':
          protocol = ProxyProtocol.trojan;
          break;
        case 'ss':
          protocol = ProxyProtocol.shadowsocks;
          break;
        default:
          return null;
      }

      String name = uri.fragment.isNotEmpty
          ? Uri.decodeComponent(uri.fragment)
          : '${protocol.name.toUpperCase()}_${uri.host}';

      return VpnConfig(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
        protocol: protocol,
        address: uri.host,
        port: uri.port != 0 ? uri.port : 443,
        rawUrl: trimmed,
      );
    } catch (e) {
      return null;
    }
  }

  // Массовый парсинг текста (построчно)
  static List<VpnConfig> parseBulk(String rawText) {
    final lines = rawText.split(RegExp(r'[\r\n]+'));
    final List<VpnConfig> parsed = [];

    for (final line in lines) {
      final config = parseUrl(line);
      if (config != null) {
        parsed.add(config);
      }
    }
    return parsed;
  }
}
