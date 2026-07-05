import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/theme_controller.dart';
import 'dashboard_screen.dart';
import 'family_inventory_screen.dart';
import 'shopping_list_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

/// Main home screen with bottom navigation (5 tabs)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const FamilyInventoryScreen(),
    const ShoppingListScreen(),
    const ProgressScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Rebuild the current page (with fresh colours) when the theme is toggled,
    // without losing the selected tab.
    ThemeController.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeController.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The KeyedSubtree forces the active page to rebuild from scratch when
      // the theme changes, so widgets re-read AppTheme's palette-backed colours.
      body: KeyedSubtree(
        key: ValueKey(ThemeController.instance.isPremiumDark),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.darkCharcoal,
        selectedItemColor: AppTheme.gold,
        unselectedItemColor: AppTheme.lightGray,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_rounded),
            activeIcon: Icon(Icons.inventory_2_rounded),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_rounded),
            activeIcon: Icon(Icons.shopping_cart_rounded),
            label: 'Shopping',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_rounded),
            activeIcon: Icon(Icons.trending_up_rounded),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            activeIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
