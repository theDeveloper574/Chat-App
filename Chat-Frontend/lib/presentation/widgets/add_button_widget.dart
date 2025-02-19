import 'package:flutter/material.dart';

import '../../core/ui.dart';

class AddButtonWidget extends StatelessWidget {
  final Function() onTap;
  const AddButtonWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: AppColors.circleColor,
      shape: const CircleBorder(),
      child: const Icon(
        Icons.add,
        size: 24,
      ),
    );
  }
}
