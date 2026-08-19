import 'package:flutter/material.dart';

class SettingsTabItem {
  final String title;
  final IconData icon;

  const SettingsTabItem({required this.title, required this.icon});
}

const settingsTabs = [
  SettingsTabItem(title: 'General', icon: Icons.settings_outlined),
  SettingsTabItem(title: 'Downloads', icon: Icons.download_outlined),
  SettingsTabItem(title: 'Browser', icon: Icons.language_outlined),
];
