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

      if (mounted)
