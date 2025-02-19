import 'package:chatapp/logic/services/preferences.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../../../core/api.dart';

class ChatProvider with ChangeNotifier {
  ChatProvider() {
    _loadUserData();
  }
  String? _userId;
  String? _username;
  String? get userId => _userId;
  String? get username => _username;

  Future<void> _loadUserData() async {
    bool isToken = await Preferences.isUserAuthenticated();
    if (isToken) {
      final token = await Preferences.getToken();
      if (token != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        _userId = decodedToken['id'];
        _username = decodedToken['userName'];
        ZegoUIKitPrebuiltCallInvitationService().init(
          appID: zogoAppId,
          appSign: zogoAppSign,
          userID: userId!,
          userName: username!,
          plugins: [ZegoUIKitSignalingPlugin()],
          notificationConfig: ZegoCallInvitationNotificationConfig(
            androidNotificationConfig: ZegoCallAndroidNotificationConfig(
              showFullScreen: true,
            ),
          ),
        );
        notifyListeners();
      }
    }
  }
}
