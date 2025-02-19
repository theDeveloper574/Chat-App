import 'package:chatapp/core/ui.dart';
import 'package:chatapp/logic/cubits/user/user_cubit.dart';
import 'package:chatapp/logic/cubits/user/user_state.dart';
import 'package:chatapp/logic/services/preferences.dart';
import 'package:chatapp/presentation/screens/auth/provider/logIn_provider.dart';
import 'package:chatapp/presentation/widgets/ButtonWidget.dart';
import 'package:chatapp/presentation/widgets/gap_widget.dart';
import 'package:chatapp/presentation/widgets/textField_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../../core/api.dart';
import '../../widgets/link_button.dart';
import '../home/chat_nav_bar.dart';
import 'create_account.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = "loginscreen";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final userPro = Provider.of<LogInProvider>(context);
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) async {
        if (state is UserLoggedState) {
          // if (userPro.isRemember) {
          await Preferences.saveToken(state.userModel.token.toString());
          // }
          // print('token saved');
          ZegoUIKitPrebuiltCallInvitationService().init(
            appID: zogoAppId,
            appSign: zogoAppSign,
            userID: state.userModel.sId!,
            userName: state.userModel.name!,
            plugins: [ZegoUIKitSignalingPlugin()],
            notificationConfig: ZegoCallInvitationNotificationConfig(
              androidNotificationConfig: ZegoCallAndroidNotificationConfig(
                showFullScreen: true,
              ),
            ),
          );
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacementNamed(context, ChatNavBar.routeName);
        }
        if (state is UserErrorState) {
          toast(message: "Error: ${userPro.error.toString()}");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.circleColor,
          centerTitle: true,
          title: Text(
            "konect",
            style: TextStyles.heading4.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: userPro.key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GapWidget(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                Text(
                  "Log In",
                  style: TextStyles.heading3.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyles.body1.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    LinkButton(
                      text: "Create Account",
                      onTap: () {
                        Navigator.pushNamed(context, CreateAccount.routeName);
                      },
                    ),
                  ],
                ),
                const GapWidget(),
                TextFieldWidget(
                  keyboardType: TextInputType.emailAddress,
                  buttonAction: TextInputAction.next,
                  hintText: "Email Or Username",
                  controller: userPro.emailCon,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Please Enter email/username";
                    }
                    return null;
                  },
                ),
                const GapWidget(),
                TextFieldWidget(
                  onSubmit: (val) => userPro.login,
                  obscure: userPro.isShowPass,
                  buttonAction: TextInputAction.done,
                  controller: userPro.passCon,
                  maxLines: 1,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Please Enter Password";
                    }
                    if (val.length < 5) {
                      return "Password cannot be less then 5";
                    }
                    return null;
                  },
                  hintText: "Password",
                  preFix: InkWell(
                    onTap: userPro.onShowPass,
                    child: Icon(
                      userPro.isShowPass
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.text,
                    ),
                  ),
                ),
                CheckboxListTile(
                  activeColor: AppColors.circleColor,
                  side: const BorderSide(color: AppColors.text),
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    "Remember Me",
                    style: TextStyle(color: AppColors.text),
                  ),
                  value: userPro.isRemember,
                  onChanged: userPro.onChanged,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const GapWidget(),
                ButtonWidget(
                  text: "Log In",
                  isShowLoading: userPro.isSignIn,
                  onPressed: userPro.login,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
