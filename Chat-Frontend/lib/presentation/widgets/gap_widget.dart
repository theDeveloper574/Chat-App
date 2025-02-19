import 'package:flutter/material.dart';

class GapWidget extends StatelessWidget {
  final double height;
  final double width;
  const GapWidget({
    super.key,
    this.height = 0.0,
    this.width = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16 + width,
      height: 16 + height,
    );
  }
}
