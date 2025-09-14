import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscountTagWidget extends StatelessWidget {
  final double? discount;
  final String? discountType;
  final double fromTop;
  final double fromLeft;
  final double? fontSize;
  final bool? freeDelivery;
  final bool isProductBottomSheet;
  final double paddingHorizontal;
  final double paddingVertical;
  const DiscountTagWidget({super.key, required this.discount, required this.discountType, this.fromTop = 10, this.fontSize, this.freeDelivery = false,
    this.isProductBottomSheet = false, this.fromLeft = 0, this.paddingHorizontal = 10, this.paddingVertical = 10});

  @override
  Widget build(BuildContext context) {
    bool isRightSide = Get.find<SplashController>().configModel!.currencySymbolDirection == 'right';
    String currencySymbol = Get.find<SplashController>().configModel!.currencySymbol!;

    return !isProductBottomSheet ? (discount! > 0 || freeDelivery!) ? Positioned(
      top: 12, left: 8,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radiusXExtraLarge)
        ),
        padding: EdgeInsets.only(left:8,right:8,top:6,bottom:6),
        margin: EdgeInsets.only(left: 6),
        child: Align(
          child: Text(
            discount! > 0 ? '${(isRightSide || discountType == 'percent') ? '' : currencySymbol}$discount${discountType == 'percent' ? '%'
                : isRightSide ? currencySymbol : ''} ${'off'.tr}' : 'free_delivery'.tr,
            style: robotoMedium.copyWith(
              color: Colors.black,
              fontSize: fontSize ?? (ResponsiveHelper.isMobile(context) ? 8 : 10),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ) : const SizedBox() : (discount! > 0 || freeDelivery!) ? Positioned(
      bottom: 0,  left: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius:  BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
          color: Colors.white

          // gradient: LinearGradient(colors: [
          //   Theme.of(context).primaryColor,
          //   Colors.black.withOpacity(0.0),
          // ], begin: Alignment.centerLeft, end: Alignment.centerRight),
        ),
        child: Text(
          discount! > 0 ? '${(isRightSide || discountType == 'percent') ? '' : currencySymbol}$discount${discountType == 'percent' ? '%'
              : isRightSide ? currencySymbol : ''} ${'off'.tr}' : 'free_delivery'.tr,
          style: robotoMedium.copyWith(
            color: Colors.black,
            fontSize: fontSize ?? (ResponsiveHelper.isMobile(context) ? 14 : 16),
          ),
          textAlign: TextAlign.start,
        ),
      ),
    ) : const SizedBox();
  }
}

class LabelPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw the pill-shaped label background
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    RRect roundedRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.height / 2),
    );

    canvas.drawRRect(roundedRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
