import 'package:chatapp/logic/cubits/user/user_cubit.dart';
import 'package:chatapp/logic/cubits/user/user_state.dart';
import 'package:chatapp/presentation/screens/auth/login_screen.dart';
import 'package:chatapp/presentation/screens/auth/provider/create_account_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../core/ui.dart';
import '../../widgets/ButtonWidget.dart';
import '../../widgets/gap_widget.dart';
import '../../widgets/image_pick_widget.dart';
import '../../widgets/link_button.dart';
import '../../widgets/textField_widget.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});
  static const routeName = "createAccountScreen";
  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    final userPro = Provider.of<CreateAccProvider>(context);
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserErrorState) {
          toast(message: "Error: ${userPro.message.toString()}");
        }
        if (state is UserLoggedState) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          toast(message: "User Created Please LogIn");
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: userPro.key,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const GapWidget(
                  height: 58,
                ),
                const ImagePickWidget(),
                const GapWidget(height: 12),
                Text(
                  "Create New Account",
                  style: TextStyles.heading4.copyWith(
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
                      text: "Log In",
                      onTap: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushNamed(context, LoginScreen.routeName);
                      },
                    ),
                  ],
                ),
                const GapWidget(),
                TextFieldWidget(
                  keyboardType: TextInputType.name,
                  controller: userPro.nameCon,
                  hintText: "Full Name Optional",
                ),
                const GapWidget(),
                TextFieldWidget(
                  keyboardType: TextInputType.name,
                  controller: userPro.userName,
                  hintText: "user name",
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Please Enter Username";
                    }
                    if (val.length < 4) {
                      return "username cannot be less then 4";
                    }
                    return null;
                  },
                ),
                const GapWidget(),
                TextFieldWidget(
                  keyboardType: TextInputType.emailAddress,
                  buttonAction: TextInputAction.next,
                  hintText: "Email",
                  controller: userPro.emailCon,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Please Enter email";
                    }
                    if (!EmailValidator.validate(val)) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),
                const GapWidget(),
                TextFieldWidget(
                  obscure: userPro.isShowPass,
                  buttonAction: TextInputAction.next,
                  controller: userPro.passwordCon,
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
                const GapWidget(),
                TextFieldWidget(
                  buttonAction: TextInputAction.done,
                  obscure: userPro.isShowPass,
                  controller: userPro.againPasswordCon,
                  maxLines: 1,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Please Enter Password";
                    }
                    if (userPro.passwordCon.text !=
                        userPro.againPasswordCon.text) {
                      return "Password do not match";
                    }
                    return null;
                  },
                  hintText: "Repeat Password",
                ),
                const GapWidget(),
                ButtonWidget(
                  text: "Create Account",
                  isShowLoading: userPro.isCreateAccount,
                  onPressed: userPro.signUp,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
