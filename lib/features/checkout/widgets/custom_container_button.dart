import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class CustomContainerCard extends StatelessWidget {
  final String svgAsset;
  final Color boxColor;
  final Color textColor;
  final String text;
  final VoidCallback? onTap;
  final Color? iconColor;

  const CustomContainerCard({
    super.key,
    required this.svgAsset,
    required this.text,
    this.onTap,
    required this.boxColor,
    required this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: Get.height * .09,
        // width: Get.width * .42,

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                svgAsset,
                height: 32,
                width: 32,
                color: iconColor,
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),
              Text(
                text,
                style: robotoMedium.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
