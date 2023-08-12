import 'package:flutter/material.dart';
import 'package:learning_state_management/providers/settings_screen_notifier.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Consumer<SettingsScreenNotifier>(
            builder: (context, notifier, child) => SwitchListTile(
              title: const Text('Dark Mode'),
              value: notifier.isDarkModeEnabled,
              secondary: const Icon(
                Icons.dark_mode,
                color: Color(0xFF642ef3),
              ),
              onChanged: (value) {
                notifier.toggleApplicationTheme(value);
              },
            ),
          )
        ],
      ),
    );
  }
}
