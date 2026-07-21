import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.language_outlined),
            title: Text('Language'),
          ),
          ListTile(
            leading: Icon(Icons.cloud_outlined),
            title: Text('Google Drive'),
          ),
          ListTile(
            leading: Icon(Icons.tune_outlined),
            title: Text('Backup profile'),
          ),
        ],
      ),
    );
  }
}
