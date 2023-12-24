//widget
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hey_amy/services/setting_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _textFieldController = TextEditingController();
  final SettingService _settingService = SettingService();
  String _inputText = '';

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    await _settingService.readAPIkey();
    setState(() {
      _inputText=_settingService.openAIAPIkey.isEmpty ?
      'Enter Your API key' : _settingService.openAIAPIkey;
    });
  }

  Future<File> onWriteAPIkey() async {
    // Write the variable as a string to the file.

    return await _settingService.writeAPIkey(_inputText);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _textFieldController,
            // decoration: const InputDecoration(labelText: 'Enter Text'),
            decoration: InputDecoration(labelText: _inputText
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () async {
            _inputText = _textFieldController.text;
            ;
            await onWriteAPIkey();
            setState(() {
              _inputText=_settingService.openAIAPIkey.isEmpty ?
              'Enter Your API key' : _settingService.openAIAPIkey;
            });
          },
          child: const Text('Save'),
        ),
      ]
    );
  }
}