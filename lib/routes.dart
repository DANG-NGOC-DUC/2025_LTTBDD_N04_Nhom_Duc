import 'package:flutter/material.dart';
import 'package:my_app/screens/plan/plan_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/reports/report_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/profile/profile.dart';
import 'screens/add/add_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/home': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/plan': (context) => const PlanScreen(),
  '/add': (context) => const AddTransactionScreen(),
  '/reports': (context) => const ReportScreen(),
  '/settings': (context) => const SettingsScreen(),
};
