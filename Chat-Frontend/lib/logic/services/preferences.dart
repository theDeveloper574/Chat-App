import 'package:chatapp/core/ui.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class Preferences {
  static const String _tokenKey = "token";

  /// Save token in local storage
  static Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Get token from local storage
  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Check if token exists and is valid
  static Future<bool> isUserAuthenticated() async {
    final token = await getToken();
    if (token == null) return false;
    if (JwtDecoder.isExpired(token)) {
      await clearUser();
      ZegoUIKitPrebuiltCallInvitationService().uninit();
      toast(message: "User Session is expired");
      return false;
    }
    return true;
  }

  static Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
