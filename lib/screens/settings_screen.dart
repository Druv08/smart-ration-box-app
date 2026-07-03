import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../data/mock_data.dart';
import '../models/family_member.dart';
import '../widgets/common/luxury_card.dart';

/// Settings screen with profile, notifications, device, family, and account options
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool emailNotifications = true;
  bool lowStockAlerts = true;

  // Editable profile.
  String profileName = 'Raj Kumar';
  String profileEmail = 'raj@example.com';

  // Local, mutable copy so members can be edited / removed at runtime.
  final List<FamilyMember> _familyMembers = List.of(MockData.familyMembers);

  // Device settings state.
  String _lastSyncLabel = 'Last sync: 2 min ago';
  bool _isSyncing = false;

  // Appearance. Label is derived from the live app theme mode.
  String get _themeLabel =>
      AppTheme.mode.value == AppThemeMode.light ? 'Light' : 'Dark (Premium)';

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _editProfile() async {
    final nameCtrl = TextEditingController(text: profileName);
    final emailCtrl = TextEditingController(text: profileEmail);

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: TextStyle(color: AppTheme.lighterGray),
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: AppTheme.lighterGray),
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (saved == true && mounted) {
      setState(() {
        profileName = nameCtrl.text.trim().isEmpty
            ? profileName
            : nameCtrl.text.trim();
        profileEmail = emailCtrl.text.trim().isEmpty
            ? profileEmail
            : emailCtrl.text.trim();
      });
      _showSnack('Profile updated');
    }
  }

  void _showConnectedDevices() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.darkCharcoal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connected Devices',
              style: TextStyle(
                color: AppTheme.lighterGray,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _deviceTile('Rice Box', 'ESP32 • Online', true),
            const SizedBox(height: 10),
            _deviceTile('Dal Box', 'ESP32 • Online', true),
          ],
        ),
      ),
    );
  }

  Widget _deviceTile(String name, String subtitle, bool online) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.gold.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.inventory_2, color: AppTheme.gold, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: AppTheme.lighterGray,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: AppTheme.lightGray, fontSize: 11),
              ),
            ],
          ),
        ),
        Icon(
          Icons.circle,
          color: online ? AppTheme.successGreen : AppTheme.errorRed,
          size: 10,
        ),
      ],
    );
  }

  Future<void> _syncData() async {
    if (_isSyncing) return;
    setState(() {
      _isSyncing = true;
      _lastSyncLabel = 'Syncing…';
    });
    _showSnack('Syncing data…');

    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isSyncing = false;
      _lastSyncLabel = 'Last sync: just now';
    });
    _showSnack('Data synced successfully');
  }

  Future<void> _editMember(FamilyMember member) async {
    final nameCtrl = TextEditingController(text: member.name);
    String role = member.role;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Edit Member'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                style: TextStyle(color: AppTheme.lighterGray),
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: role,
                dropdownColor: AppTheme.darkCharcoal,
                style: TextStyle(color: AppTheme.lighterGray),
                decoration: const InputDecoration(labelText: 'Role'),
                items: const ['Admin', 'Member', 'Guest']
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => setLocal(() => role = v ?? role),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (saved == true && mounted) {
      final index = _familyMembers.indexOf(member);
      if (index != -1) {
        setState(() {
          _familyMembers[index] = FamilyMember(
            id: member.id,
            name: nameCtrl.text.trim().isEmpty ? member.name : nameCtrl.text.trim(),
            role: role,
            email: member.email,
            profileImage: member.profileImage,
            joinedDate: member.joinedDate,
            isActive: member.isActive,
          );
        });
      }
      _showSnack('Member updated');
    }
  }

  Future<void> _removeMember(FamilyMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text(
          'Remove ${member.name} from your family group?',
          style: TextStyle(color: AppTheme.lighterGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _familyMembers.remove(member));
      _showSnack('${member.name} removed');
    }
  }

  Future<void> _changeTheme() async {
    const options = <String, AppThemeMode>{
      'Dark (Premium)': AppThemeMode.dark,
      'Light': AppThemeMode.light,
    };
    final selected = await showDialog<AppThemeMode>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Theme'),
        backgroundColor: AppTheme.darkCharcoal,
        children: options.entries
            .map(
              (entry) => ListTile(
                title: Text(
                  entry.key,
                  style: TextStyle(color: AppTheme.lighterGray),
                ),
                trailing: entry.value == AppTheme.mode.value
                    ? const Icon(Icons.check, color: AppTheme.gold)
                    : null,
                onTap: () => Navigator.pop(ctx, entry.value),
              ),
            )
            .toList(),
      ),
    );

    if (selected != null && mounted) {
      AppTheme.mode.value = selected;
      setState(() {}); // refresh the label on this screen
      _showSnack('Theme set to ${selected == AppThemeMode.light ? 'Light' : 'Dark'}');
    }
  }

  void _showInfoDialog(String title, String body) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(
          body,
          style: TextStyle(color: AppTheme.lighterGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: AppTheme.lighterGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _showSnack('Logged out');
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppTheme.darkCharcoal,
              elevation: 0,
              title: Text(
                'Settings',
                style: TextStyle(
                  color: AppTheme.lighterGray,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              floating: true,
              snap: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Profile Section
                  _SectionTitle(title: 'Profile'),
                  const SizedBox(height: 12),
                  LuxuryCard(
                    onTap: _editProfile,
                    padding: const EdgeInsets.all(14),
                    child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppTheme.gold.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: AppTheme.gold,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profileName,
                                      style: TextStyle(
                                        color: AppTheme.lighterGray,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      profileEmail,
                                      style: TextStyle(
                                        color: AppTheme.lightGray,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: AppTheme.gold,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Notifications Section
                  _SectionTitle(title: 'Notifications'),
                  const SizedBox(height: 12),
                  _SettingToggle(
                    icon: Icons.notifications_active,
                    label: 'Push Notifications',
                    value: notificationsEnabled,
                    onChanged: (val) {
                      setState(() => notificationsEnabled = val);
                      _showSnack(
                        val
                            ? 'Push notifications enabled'
                            : 'Push notifications disabled',
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _SettingToggle(
                    icon: Icons.email,
                    label: 'Email Notifications',
                    value: emailNotifications,
                    onChanged: (val) {
                      setState(() => emailNotifications = val);
                      _showSnack(
                        val
                            ? 'Email notifications enabled'
                            : 'Email notifications disabled',
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _SettingToggle(
                    icon: Icons.warning_amber,
                    label: 'Low Stock Alerts',
                    value: lowStockAlerts,
                    onChanged: (val) {
                      setState(() => lowStockAlerts = val);
                      _showSnack(
                        val ? 'Low stock alerts enabled' : 'Low stock alerts disabled',
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Device Settings
                  _SectionTitle(title: 'Device Settings'),
                  const SizedBox(height: 12),
                  _SettingItem(
                    icon: Icons.inventory_2,
                    label: 'Connected Devices',
                    value: '2 devices',
                    onTap: _showConnectedDevices,
                  ),
                  const SizedBox(height: 10),
                  _SettingItem(
                    icon: Icons.sync,
                    label: 'Sync Data',
                    value: _lastSyncLabel,
                    onTap: _syncData,
                  ),
                  const SizedBox(height: 24),

                  // Family Management
                  _SectionTitle(title: 'Family Management'),
                  const SizedBox(height: 12),
                  ..._familyMembers.map((member) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: LuxuryCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppTheme.gold.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: AppTheme.gold,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.name,
                                    style: TextStyle(
                                      color: AppTheme.lighterGray,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    member.role,
                                    style: TextStyle(
                                      color: AppTheme.lightGray,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              color: AppTheme.darkCharcoal,
                              icon: Icon(
                                Icons.more_vert,
                                color: AppTheme.lightGray,
                              ),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _editMember(member);
                                } else if (value == 'remove') {
                                  _removeMember(member);
                                }
                              },
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(color: AppTheme.lighterGray),
                                  ),
                                ),
                                if (!member.isAdmin)
                                  const PopupMenuItem(
                                    value: 'remove',
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(color: AppTheme.errorRed),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),

                  // Theme Settings
                  _SectionTitle(title: 'Appearance'),
                  const SizedBox(height: 12),
                  _SettingItem(
                    icon: Icons.dark_mode,
                    label: 'Theme',
                    value: _themeLabel,
                    onTap: _changeTheme,
                  ),
                  const SizedBox(height: 24),

                  // Account Settings
                  _SectionTitle(title: 'Account'),
                  const SizedBox(height: 12),
                  _SettingItem(
                    icon: Icons.security,
                    label: 'Privacy & Security',
                    value: 'Manage settings',
                    onTap: () => _showInfoDialog(
                      'Privacy & Security',
                      'Your data is stored securely on your device. '
                          'Manage app permissions, two-factor authentication, '
                          'and data sharing preferences here.',
                    ),
                  ),
                  const SizedBox(height: 10),
                  _SettingItem(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    value: 'Get help',
                    onTap: () => _showInfoDialog(
                      'Help & Support',
                      'Need help with your Smart Ration Box?\n\n'
                          'Email: support@dazcan.com\n'
                          'Phone: +91 98765 43210\n\n'
                          'We typically respond within 24 hours.',
                    ),
                  ),
                  const SizedBox(height: 10),
                  _SettingItem(
                    icon: Icons.info_outline,
                    label: 'About',
                    value: 'v1.0.0',
                    onTap: () => showAboutDialog(
                      context: context,
                      applicationName: 'Smart Ration Box',
                      applicationVersion: 'v1.0.0',
                      applicationIcon: const Icon(
                        Icons.inventory_2,
                        color: AppTheme.gold,
                      ),
                      children: [
                        Text(
                          'Smart ration monitoring for every household. '
                          'Track stock, get low-stock alerts, and manage your '
                          'family in one place.',
                          style: TextStyle(color: AppTheme.lighterGray),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Logout Button
                  ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorRed,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppTheme.lighterGray,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _SettingToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingToggle({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LuxuryCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.gold, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.lighterGray,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.gold,
            inactiveThumbColor: AppTheme.lightGray,
            inactiveTrackColor: AppTheme.darkerCharcoal,
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _SettingItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LuxuryCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.gold, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.lighterGray,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: AppTheme.lightGray,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: AppTheme.gold, size: 14),
        ],
      ),
    );
  }
}
