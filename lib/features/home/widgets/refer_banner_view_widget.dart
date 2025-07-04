import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferBannerViewWidget extends StatelessWidget {
  final bool fromTheme1;
  const ReferBannerViewWidget({super.key, this.fromTheme1 = false});

  @override
  Widget build(BuildContext context) {
    double rightValue = (MediaQuery.of(context).size.width*0.7);
    return (Get.find<SplashController>().configModel!.refEarningStatus == 1 ) ? Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.isMobile(context) ? fromTheme1 ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeDefault : 0,
        vertical: ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge,
      ),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 0 : Dimensions.paddingSizeLarge),
        height: ResponsiveHelper.isMobile(context) ? 95 : 147,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          // gradient: LinearGradient(colors:[
          //   Theme.of(context).colorScheme.tertiaryContainer,
          //   Theme.of(context).colorScheme.tertiary,
          // ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Stack(
          children: [
            Positioned(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  child: Image.asset(Images.referBg, height: ResponsiveHelper.isMobile(context) ? 95 : 147,fit: BoxFit.cover,)),
            ),
            Positioned(
              top: 0,bottom: 0,right: 20,
              child: Column(mainAxisAlignment: MainAxisAlignment.center,

                children: [


                  InkWell(
                    onTap: (){Get.toNamed(RouteHelper.getReferAndEarnRoute());},
                    child: Container(
                      // height: 35,
                      width: 90,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white
                      ),
                      child: Center(
                        child: Text("refer_now".tr,style: TextStyle(color: Theme.of(context).primaryColor),),
                      ),
                    ),
                  ),

                  // CustomButtonWidget(buttonText: 'refer_now'.tr, width: ResponsiveHelper.isMobile(context) ? 90 : 120, height: ResponsiveHelper.isMobile(context) ? 35 : 40, isBold: true, fontSize: Dimensions.fontSizeSmall, textColor: Theme.of(context).primaryColor,
                  //     radius: Dimensions.radiusSmall, color: Theme.of(context).cardColor,
                  //     onPressed: ()=> Get.toNamed(RouteHelper.getReferAndEarnRoute())
                  // ),
                ],
              ),
            ),
            Row(
              children: [
              SizedBox(
                width: Get.width * 0.6,
                child: Row(children: [
                  SizedBox(width: ResponsiveHelper.isDesktop(context) ? 180 : ResponsiveHelper.isMobile(context) ? 145 : 200),

                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${'earn'.tr} ',
                                style: robotoMedium.copyWith(fontSize: ResponsiveHelper.isMobile(context) ? Dimensions.fontSizeSmall : Dimensions.fontSizeLarge, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                              TextSpan(
                                text: PriceConverter.convertPrice(Get.find<SplashController>().configModel!.refEarningExchangeRate),
                                style: robotoBold.copyWith(fontSize: ResponsiveHelper.isMobile(context) ? Dimensions.fontSizeDefault : Dimensions.fontSizeOverLarge, color: Colors.white),
                              ),
                              TextSpan(
                                text: ' ${'when_you'.tr} ',
                                style: robotoMedium.copyWith(fontSize: ResponsiveHelper.isMobile(context) ? Dimensions.fontSizeSmall : Dimensions.fontSizeLarge, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                              TextSpan(
                                text: 'refer_an_friend'.tr,
                                style: robotoRegular.copyWith(fontSize: ResponsiveHelper.isMobile(context) ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),

             SizedBox(width: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeSmall : 0),
            ],
            ),
          ],
        ),
      ),
    ) : const SizedBox();
  }
}