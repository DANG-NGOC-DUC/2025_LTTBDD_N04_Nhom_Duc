import 'package:flutter/material.dart';
import 'package:my_app/widgets/bottom_nav.dart';
import 'package:my_app/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  String _language = 'Tiếng Việt';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale') ?? 'vi';
    setState(() {
      _language = savedLocale == 'vi' ? 'Tiếng Việt' : 'English';
    });
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('confirm'.tr(),
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text('confirm_logout'.tr(), style: GoogleFonts.poppins()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text('cancel'.tr())),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (r) => false);
            },
            child: Text('logout'.tr(),
                style: GoogleFonts.poppins(color: Colors.red)),
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
        title: Text('settings'.tr()),
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
                    _buildProfileCard(),
                    const SizedBox(height: 20),
                    _buildSectionTitle('general_settings'.tr()),
                    const SizedBox(height: 8),
                    _buildSettingsCard(),
                    const SizedBox(height: 20),
                    _buildSectionTitle('support'.tr()),
                    const SizedBox(height: 8),
                    _buildSupportCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary,
            child: Text('DN',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Đặng Ngọc Đức',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('MSV: 23010803',
                    style: GoogleFonts.poppins(
                        color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          ),
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.pushNamed(context, '/profile')),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13));
  }

  Widget _buildSettingsCard() {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SwitchListTile(
            title: Text('notifications'.tr(), style: GoogleFonts.poppins()),
            subtitle: Text('notifications_desc'.tr(),
                style: GoogleFonts.poppins(fontSize: 12)),
            value: _notifications,
            activeThumbColor: AppColors.primary,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: Text('dark_mode'.tr(), style: GoogleFonts.poppins()),
            subtitle: Text('dark_mode_desc'.tr(),
                style: GoogleFonts.poppins(fontSize: 12)),
            value: _darkMode,
            activeThumbColor: AppColors.primary,
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          const Divider(height: 1),
          ListTile(
            title: Text('language'.tr(), style: GoogleFonts.poppins()),
            subtitle: Text(_language, style: GoogleFonts.poppins(fontSize: 12)),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showLanguagePicker,
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker() async {
    final Locale? chosen = await showModalBottomSheet<Locale>(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Tiếng Việt'),
            trailing: context.locale.languageCode == 'vi'
                ? Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () => Navigator.pop(ctx, const Locale('vi')),
          ),
          ListTile(
            title: const Text('English'),
            trailing: context.locale.languageCode == 'en'
                ? Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () => Navigator.pop(ctx, const Locale('en')),
          ),
        ],
      ),
    );

    if (chosen != null && chosen.languageCode != context.locale.languageCode) {
      await context.setLocale(chosen);

      // Lưu ngôn ngữ vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('locale', chosen.languageCode);

      setState(() {
        _language = chosen.languageCode == 'vi' ? 'Tiếng Việt' : 'English';
      });
    }
  }

  Widget _buildSupportCard() {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text('privacy_policy'.tr(), style: GoogleFonts.poppins()),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('version'.tr(), style: GoogleFonts.poppins()),
            trailing: Text('1.0.0',
                style: GoogleFonts.poppins(color: Colors.grey[600])),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.logout),
        label: Text('logout'.tr(), style: GoogleFonts.poppins(fontSize: 16)),
        onPressed: _confirmLogout,
      ),
    );
  }
}
