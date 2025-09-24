import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý tài chính')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Giao dịch'),
            onTap: () => Navigator.pushNamed(context, '/transactions'),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Thêm giao dịch'),
            onTap: () => Navigator.pushNamed(context, '/add-transaction'),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Ngân sách'),
            onTap: () => Navigator.pushNamed(context, '/budget'),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Báo cáo'),
            onTap: () => Navigator.pushNamed(context, '/reports'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Cài đặt'),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
    );
  }
}