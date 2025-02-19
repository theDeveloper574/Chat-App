import 'package:chatapp/presentation/screens/chat/show_users.dart';
import 'package:chatapp/presentation/screens/home/chat_nav_bar.dart';
import 'package:chatapp/presentation/screens/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../presentation/screens/auth/create_account.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/provider/create_account_provider.dart';
import '../presentation/screens/auth/provider/logIn_provider.dart';
import '../presentation/screens/auth/update_profile.dart';
import '../presentation/screens/chat/single_chat.dart';
import '../presentation/screens/home/provider/chat_provider.dart';

class Routes {
  static Route? routeSettings(RouteSettings route) {
    switch (route.name) {
      case Splash.routeName:
        return CupertinoPageRoute(builder: (context) => const Splash());

      case CreateAccount.routeName:
        return CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => CreateAccProvider(context),
            child: const CreateAccount(),
          ),
        );

      case LoginScreen.routeName:
        return CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => LogInProvider(context),
            child: const LoginScreen(),
          ),
        );
      case ChatNavBar.routeName:
        return CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider(
            lazy: false,
            create: (context) => ChatProvider(),
            child: const ChatNavBar(),
          ),
        );
      case SingleChat.routeName:
        final args = route.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider(
            lazy: false,
            create: (context) => ChatProvider(),
            child: SingleChat(
              userName: args["userName"] as String,
              userId: args["userId"] as String,
              chatRoomId: args["chatRoomId"] as String,
            ),
          ),
        );
      case ShowUsers.routeName:
        return CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => ChangeNotifierProvider(
            lazy: false,
            create: (context) => ChatProvider(),
            child: const ShowUsers(),
          ),
        );
      case UpdateProfile.routeName:
        return CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (context) => CreateAccProvider(context)),
              ChangeNotifierProvider(create: (context) => ChatProvider()),
            ],
            child: UpdateProfile(),
          ),
        );
      default:
        return null;
    }
  }
}
