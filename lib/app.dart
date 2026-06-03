import 'package:flutter/material.dart';

import 'screens/dashboard_screen.dart';
import 'utils/constants.dart';

class SmartRationBoxApp extends StatelessWidget {
  const SmartRationBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.primaryColor),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
