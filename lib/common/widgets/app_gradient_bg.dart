import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';

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


        image:  DecorationImage(image: Get.find<LocalizationController>().isLtr ? AssetImage("assets/image/header_bg.jpeg",)
            : AssetImage("assets/image/image_header_flipped.jpg",),fit: BoxFit.cover),
        // gradient: RadialGradient(
        //   center: Alignment(-0.6, -0.3),
        //   radius: 1.0,
        //   colors: [
        //     Color(0xFF56B83D).withOpacity(0.8),
        //     Color(0xFF30A94F),
        //   ],
        // ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child ?? SizedBox.shrink(),
    );
  }
}
