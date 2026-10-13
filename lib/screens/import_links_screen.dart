import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/config_model.dart';
import '../services/config_parser.dart';
import '../services/config_storage.dart';

class ImportLinksScreen extends StatefulWidget {
  const ImportLinksScreen({super.key});

  @override
  State<ImportLinksScreen> createState() => _ImportLinksScreenState();
}

class _ImportLinksScreenState extends State<ImportLinksScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;

  // Функция сохранения и добавления конфигов
  Future<void> _processAndSave(String rawText) async {
    if (rawText.trim().isEmpty) return;

    setState(() => _isLoading = true);

    final newConfigs = ConfigParser.parseBulk(rawText);
    if (newConfigs.isNotEmpty) {
      final existingConfigs = await ConfigStorage.loadConfigs();
      existingConfigs.addAll(newConfigs);
      await ConfigStorage.saveConfigs(existingConfigs);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Успешно импортировано: ${newConfigs.length} конфигов!'),
            backgroundColor: AppTheme.neonGreen,
          ),
        );
        _textController.clear();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Не найдено валидных конфигов (vless://, trojan:// и др.)'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  // Вставка из буфера обмена
  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      _textController.text = data.text!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Шапка
          const Text(
            'Import Links',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bring your V2Ray configs into MEMENTO from text, clipboard, or subscription URL.',
            style: TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Быстрые кнопки (Clipboard)
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _pasteFromClipboard,
                icon: const Icon(Icons.paste, size: 16),
                label: const Text('Clipboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.cardBg,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: AppTheme.cardBorder),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Поле ручного ввода
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12),
                      decoration: const InputDecoration(
                        hintText: 'vless://...\ntrojan://...\nss://...',
                        hintStyle: TextStyle(color: Colors.white30),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _processAndSave(_textController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.neonGreen,
                        foregroundColor: Colors.black,
                      ),
                      child: _isLoading
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('+ Import', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
