import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../data/mock_data.dart';
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
              title: const Text(
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
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppTheme.gold.withOpacity(0.2),
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
                                  const Text(
                                    'Raj Kumar',
                                    style: TextStyle(
                                      color: AppTheme.lighterGray,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'raj@example.com',
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
                    },
                  ),
                  const SizedBox(height: 10),
                  _SettingToggle(
                    icon: Icons.email,
                    label: 'Email Notifications',
                    value: emailNotifications,
                    onChanged: (val) {
                      setState(() => emailNotifications = val);
                    },
                  ),
                  const SizedBox(height: 10),
                  _SettingToggle(
                    icon: Icons.warning_amber,
                    label: 'Low Stock Alerts',
                    value: lowStockAlerts,
                    onChanged: (val) {
                      setState(() => lowStockAlerts = val);
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
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  _SettingItem(
                    icon: Icons.sync,
                    label: 'Sync Data',
                    value: 'Last sync: 2 min ago',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),

                  // Family Management
                  _SectionTitle(title: 'Family Management'),
                  const SizedBox(height: 12),
                  ...MockData.familyMembers.map((member) {
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
                                color: AppTheme.gold.withOpacity(0.15),
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
                                    style: const TextStyle(
                                      color: AppTheme.lighterGray,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    member.role,
                                    style: const TextStyle(
                                      color: AppTheme.lightGray,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton(
                              color: AppTheme.darkCharcoal,
                              itemBuilder: (_) => [
                                const PopupMenuItem(
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: AppTheme.lighterGray,
                                    ),
                                  ),
                                ),
                                if (!member.isAdmin)
                                  const PopupMenuItem(
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(
                                        color: AppTheme.errorRed,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 24),

                  // Theme Settings
                  _SectionTitle(title: 'Appearance'),
                  const SizedBox(height: 12),
                  _SettingItem(
                    icon: Icons.dark_mode,
                    label: 'Theme',
                    value: 'Dark (Premium)',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),

                  // Account Settings
                  _SectionTitle(title: 'Account'),
                  const SizedBox(height: 12),
                  _SettingItem(
                    icon: Icons.security,
                    label: 'Privacy & Security',
                    value: 'Manage settings',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  _SettingItem(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    value: 'Get help',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  _SettingItem(
                    icon: Icons.info_outline,
                    label: 'About',
                    value: 'v1.0.0',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),

                  // Logout Button
                  ElevatedButton.icon(
                    onPressed: () {},
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
      style: const TextStyle(
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
              color: AppTheme.gold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.gold, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.lighterGray,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.gold,
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
    return GestureDetector(
      onTap: onTap,
      child: LuxuryCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.gold.withOpacity(0.15),
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
                    style: const TextStyle(
                      color: AppTheme.lighterGray,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
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
      ),
    );
  }
}
