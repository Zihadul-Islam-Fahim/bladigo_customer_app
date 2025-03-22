import 'package:flutter/material.dart';

class AppGradientBackground extends StatelessWidget {
  const AppGradientBackground(
      {super.key, this.child, this.borderRadius = 0, this.height = 180});

  final Widget? child;
  final double borderRadius;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: height,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.6, -0.3),
          radius: 1.0,
          colors: [
            Color(0xFF56B83D).withOpacity(0.8),
            Color(0xFF30A94F),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child ?? SizedBox.shrink(),
    );
  }
}
