import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('student_info'.tr())),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'MSV: ${'student_id'.tr()}\n${'name'.tr(namedArgs: {'name': 'student_name'.tr()})}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 16),
            IconButton(
              icon: const Icon(
                Icons.arrow_circle_right,
                size: 40,
                color: Color(0xFF333333),
              ),
              tooltip: 'home'.tr(),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}
