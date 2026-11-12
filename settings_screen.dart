import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedTheme = 'System';
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Appearance', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
          ),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme'),
            subtitle: Text(_selectedTheme),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: const Text('Select Theme'),
                  children: ['Light', 'Dark', 'System'].map((t) => SimpleDialogOption(
                    onPressed: () {
                      setState(() => _selectedTheme = t);
                      Navigator.pop(context);
                    },
                    child: Text(t),
                  )).toList(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(_selectedLanguage),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: const Text('Select Language'),
                  children: ['English', 'Español', 'Français', 'Deutsch', 'हिन्दी', '日本語', 'العربية'].map((l) => SimpleDialogOption(
                    onPressed: () {
                      setState(() => _selectedLanguage = l);
                      Navigator.pop(context);
                    },
                    child: Text(l),
                  )).toList(),
                ),
              );
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('Security & Privacy', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
          ),
          ListTile(
            leading: const Icon(Icons.security, color: Colors.green),
            title: const Text('100% Private Offline Processing'),
            subtitle: const Text('Zero telemetry • Documents never leave device'),
            onTap: () {},
          ),
          const Divider(),
          const ListTile(
            title: Text('About', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Smart Scanner PDF'),
            subtitle: Text('Version 2.4.0 (Production Release)'),
          ),
        ],
      ),
    );
  }
}
