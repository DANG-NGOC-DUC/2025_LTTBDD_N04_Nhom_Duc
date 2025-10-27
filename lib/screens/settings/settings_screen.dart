import 'package:flutter/material.dart';
import 'package:my_app/widgets/bottom_nav.dart';
import 'package:my_app/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  String _language = 'Tiếng Việt';

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Xác nhận',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Bạn có chắc muốn đăng xuất?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Hủy', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (r) => false,
              );
            },
            child: Text(
              'Đăng xuất',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Cài đặt'),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    // Profile card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              'DN',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Đặng Ngọc Đức',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'MSV: 23010803',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/profile'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Settings section
                    Text(
                      'Cài đặt chung',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: Text(
                              'Thông báo',
                              style: GoogleFonts.poppins(),
                            ),
                            subtitle: Text(
                              'Bật/tắt thông báo',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                            value: _notifications,
                            activeThumbColor: AppColors.primary,
                            onChanged: (v) =>
                                setState(() => _notifications = v),
                          ),
                          const Divider(height: 1),
                          SwitchListTile(
                            title: Text(
                              'Chế độ tối',
                              style: GoogleFonts.poppins(),
                            ),
                            subtitle: Text(
                              'Thay đổi giao diện',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                            value: _darkMode,
                            activeThumbColor: AppColors.primary,
                            onChanged: (v) => setState(() => _darkMode = v),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            title: Text(
                              'Ngôn ngữ',
                              style: GoogleFonts.poppins(),
                            ),
                            subtitle: Text(
                              _language,
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: ['Tiếng Việt', 'English']
                                      .map(
                                        (l) => ListTile(
                                          title: Text(l),
                                          onTap: () {
                                            setState(() => _language = l);
                                            Navigator.pop(ctx);
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // About
                    Text(
                      'Hỗ trợ',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.privacy_tip_outlined),
                            title: Text(
                              'Chính sách bảo mật',
                              style: GoogleFonts.poppins(),
                            ),
                            onTap: () {},
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.info_outline),
                            title: Text(
                              'Phiên bản',
                              style: GoogleFonts.poppins(),
                            ),
                            trailing: Text(
                              '1.0.0',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                              ),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Logout button
              Padding(
                padding: const EdgeInsets.only(bottom: 12, top: 6),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: Text(
                      'Đăng xuất',
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    onPressed: _confirmLogout,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }
}
