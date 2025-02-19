import 'package:chatapp/core/ui.dart';
import 'package:flutter/cupertino.dart';

class LinkButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  const LinkButton({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        style: TextStyles.body3.copyWith(color: AppColors.text).copyWith(
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}
