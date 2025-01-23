import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  String _selectedTheme = 'System';
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        children: [
          _buildSection(
            'Account Settings',
            [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Profile'),
                subtitle: const Text('Edit your profile information'),
                onTap: () {
                  // TODO: Navigate to profile edit screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.password_outlined),
                title: const Text('Change Password'),
                subtitle: const Text('Update your password'),
                onTap: () {
                  // TODO: Show change password dialog
                },
              ),
            ],
          ),
          _buildSection(
            'Notifications',
            [
              SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined),
                title: const Text('Push Notifications'),
                subtitle: const Text('Receive push notifications'),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              SwitchListTile(
                secondary: const Icon(Icons.email_outlined),
                title: const Text('Email Notifications'),
                subtitle: const Text('Receive email updates'),
                value: _emailNotificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _emailNotificationsEnabled = value;
                  });
                },
              ),
            ],
          ),
          _buildSection(
            'Appearance',
            [
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('Theme'),
                subtitle: Text(_selectedTheme),
                onTap: () => _showThemeSelector(),
              ),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: const Text('Language'),
                subtitle: Text(_selectedLanguage),
                onTap: () => _showLanguageSelector(),
              ),
            ],
          ),
          _buildSection(
            'Data Management',
            [
              ListTile(
                leading: const Icon(Icons.cloud_upload_outlined),
                title: const Text('Backup Data'),
                subtitle: const Text('Backup your attendance records'),
                onTap: () {
                  // TODO: Implement backup functionality
                },
              ),
              ListTile(
                leading: const Icon(Icons.cloud_download_outlined),
                title: const Text('Restore Data'),
                subtitle: const Text('Restore from backup'),
                onTap: () {
                  // TODO: Implement restore functionality
                },
              ),
            ],
          ),
          _buildSection(
            'About',
            [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('App Information'),
                subtitle: const Text('Version 1.0.0'),
                onTap: () {
                  // TODO: Show app info dialog
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                subtitle: const Text('Get help with the app'),
                onTap: () {
                  // TODO: Navigate to help screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy Policy'),
                onTap: () {
                  // TODO: Show privacy policy
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  void _showThemeSelector() {
    final themes = ['System', 'Light', 'Dark'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: themes.map((theme) {
              return RadioListTile(
                title: Text(theme),
                value: theme,
                groupValue: _selectedTheme,
                onChanged: (value) {
                  setState(() {
                    _selectedTheme = value.toString();
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showLanguageSelector() {
    final languages = ['English', 'Spanish', 'French', 'German'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((language) {
              return RadioListTile(
                title: Text(language),
                value: language,
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value.toString();
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
