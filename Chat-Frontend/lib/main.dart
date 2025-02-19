import 'dart:developer';

import 'package:chatapp/core/routes.dart';
import 'package:chatapp/core/ui.dart';
import 'package:chatapp/logic/cubits/chat/chats_cubit.dart';
import 'package:chatapp/logic/cubits/user/user_cubit.dart';
import 'package:chatapp/logic/cubits/users/users_cubit.dart';
import 'package:chatapp/logic/services/preferences.dart';
import 'package:chatapp/presentation/screens/home/chat_nav_bar.dart';
import 'package:chatapp/presentation/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'firebase_options.dart';
import 'logic/cubits/singleChat/singleChat_cubit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  bool isToken = await Preferences.isUserAuthenticated();
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );
    runApp(MyApp(
      isAuthenticated: isToken,
      navigatorKey: navigatorKey,
    ));
  });
}

class MyApp extends StatefulWidget {
  final bool isAuthenticated;
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({
    super.key,
    required this.isAuthenticated,
    required this.navigatorKey,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(create: (context) => UserCubit()),
        BlocProvider<UsersCubit>(create: (context) => UsersCubit()),
        BlocProvider<ChatsCubit>(create: (context) => ChatsCubit()),
        BlocProvider<SingleChatCubit>(create: (context) => SingleChatCubit()),
      ],
      child: MaterialApp(
        navigatorKey: widget.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'konect',
        onGenerateRoute: Routes.routeSettings,
        initialRoute:
            widget.isAuthenticated ? ChatNavBar.routeName : Splash.routeName,
        theme: Themes.defaultTheme,
      ),
    );
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    log("Created: $bloc");
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    log("Change in bloc: $bloc : $change");
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log("Change in transition: $bloc $transition");
    super.onTransition(bloc, transition);
  }

  @override
  void onClose(BlocBase bloc) {
    log("Closed: $bloc");
    super.onClose(bloc);
  }
}
