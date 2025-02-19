import 'package:chatapp/core/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color? buttonColor;
  final void Function()? onPressed;
  final bool isShowLoading;
  final double? width;
  const ButtonWidget({
    super.key,
    required this.text,
    this.buttonColor,
    this.width,
    this.isShowLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.sizeOf(context).width,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: buttonColor ?? AppColors.circleColor,
        onPressed: onPressed,
        child: isShowLoading
            ? LoadingAnimationWidget.dotsTriangle(
                color: AppColors.text,
                size: 30,
              )
            : Text(text),
      ),
    );
  }
}
