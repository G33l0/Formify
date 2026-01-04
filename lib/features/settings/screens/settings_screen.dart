import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/premium_provider.dart';
import '../../../providers/settings_provider.dart';
import 'paywall_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Premium status card
          if (!isPremium)
            Card(
              margin: const EdgeInsets.all(16),
              color: AppTheme.primaryColor,
              child: ListTile(
                leading: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 32,
                ),
                title: const Text(
                  'Upgrade to Premium',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Remove watermarks, unlimited documents & more',
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PaywallScreen()),
                  );
                },
              ),
            )
          else
            Card(
              margin: const EdgeInsets.all(16),
              color: Colors.green,
              child: const ListTile(
                leading: Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 32,
                ),
                title: Text(
                  'Premium Active',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Thank you for your support!',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),

          // Appearance Section
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Appearance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.palette_rounded),
            title: const Text('Theme'),
            subtitle: Text(_getThemeModeText(themeMode)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () => _showThemeDialog(context, ref),
          ),

          const Divider(),

          // Regional Settings
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Regional Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money_rounded),
            title: const Text('Currency'),
            subtitle: Text(currency),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () => _showCurrencyDialog(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: const Text('Language'),
            subtitle: const Text('English (Coming soon)'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Multi-language support coming soon'),
                ),
              );
            },
          ),

          const Divider(),

          // Data & Privacy
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Data & Privacy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.cloud_upload_rounded),
            title: const Text('Backup & Sync'),
            subtitle: Text(isPremium ? 'Available' : 'Premium feature'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () {
              if (!isPremium) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaywallScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cloud sync coming soon')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_rounded),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.open_in_new_rounded, size: 16),
            onTap: () => _launchURL(AppConstants.privacyPolicyUrl),
          ),
          ListTile(
            leading: const Icon(Icons.description_rounded),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.open_in_new_rounded, size: 16),
            onTap: () => _launchURL(AppConstants.termsOfServiceUrl),
          ),

          const Divider(),

          // Support
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Support',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.email_rounded),
            title: const Text('Contact Support'),
            subtitle: Text(AppConstants.supportEmail),
            trailing: const Icon(Icons.open_in_new_rounded, size: 16),
            onTap: () => _launchEmail(),
          ),
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: const Text('About'),
            subtitle: Text('Version ${AppConstants.appVersion}'),
          ),

          const SizedBox(height: 16),

          // Debug: Reset premium (only for testing)
          if (isPremium)
            Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton(
                onPressed: () {
                  ref.read(isPremiumProvider.notifier).setPremium(false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Premium status reset')),
                  );
                },
                child: const Text('Reset Premium (Debug)'),
              ),
            ),
        ],
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System default';
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('Light'),
                value: ThemeMode.light,
                groupValue: ref.read(themeModeProvider),
                onChanged: (value) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Dark'),
                value: ThemeMode.dark,
                groupValue: ref.read(themeModeProvider),
                onChanged: (value) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('System Default'),
                value: ThemeMode.system,
                groupValue: ref.read(themeModeProvider),
                onChanged: (value) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCurrencyDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Currency'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: AppConstants.supportedCurrencies.length,
              itemBuilder: (context, index) {
                final currency = AppConstants.supportedCurrencies[index];
                final symbol = AppConstants.currencySymbols[currency];
                return ListTile(
                  title: Text(currency),
                  subtitle: Text(symbol ?? ''),
                  selected: currency == ref.read(currencyProvider),
                  onTap: () {
                    ref.read(currencyProvider.notifier).setCurrency(currency);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchEmail() async {
    final uri = Uri.parse('mailto:${AppConstants.supportEmail}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
