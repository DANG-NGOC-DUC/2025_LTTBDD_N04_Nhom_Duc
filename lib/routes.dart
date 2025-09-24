import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/transactions/transaction_list_screen.dart';
import 'screens/transactions/add_transaction_screen.dart';
import 'screens/budget/budget_screen.dart';
import 'screens/reports/report_screen.dart';
import 'screens/settings/settings_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/transactions': (context) => const TransactionListScreen(),
  '/add-transaction': (context) => const AddTransactionScreen(),
  '/budget': (context) => const BudgetScreen(),
  '/reports': (context) => const ReportScreen(),
  '/settings': (context) => const SettingsScreen(),
};