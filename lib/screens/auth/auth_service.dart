import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';

  static const String testUsername = 'admin';
  static const String testPassword = '123456';

  /// Dang ky
  static Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_passwordKey, password);
    return true;
  }

  /// Dang nhap
  static Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString(_usernameKey);
    final savedPassword = prefs.getString(_passwordKey);

    // Check tài khoản mặc định
    if (username == testUsername && password == testPassword) {
      return true;
    }

    // Check tài khoản đã đăng ký
    if (savedUsername != null && savedPassword != null) {
      if (username == savedUsername && password == savedPassword) {
        return true;
      }
    }

    return false;
  }
}
