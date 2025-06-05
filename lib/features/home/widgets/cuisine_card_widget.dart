import 'package:stackfood_multivendor/features/cuisine/widgets/cuisine_custom_shape_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CuisineCardWidget extends StatelessWidget {
  final String image;
  final String name;
  final bool fromCuisinesPage;
  final bool fromSearchPage;
  const CuisineCardWidget({super.key, required this.image, required this.name, this.fromCuisinesPage = false, this.fromSearchPage = false});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context) ? ClipRRect(
      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault)),
      child: Stack(
        children: [
          Positioned(bottom: ResponsiveHelper.isMobile(context) ? -75 : -55, left: 0, right: ResponsiveHelper.isMobile(context) ? -17 : 0,
            child: Transform.rotate(
              angle: 40,
              child: Container(
                height: ResponsiveHelper.isMobile(context) ? 132 : 120, width: ResponsiveHelper.isMobile(context) ? 150 : 120,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(decoration: BoxDecoration( color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(50)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CustomImageWidget(image: image,
                    fit: BoxFit.cover, height: 100, width: 100),
              ),
            ),
          ),

          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              alignment: Alignment.center,
              height: 30, width: 120,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]!, spreadRadius: 0.5, blurRadius: 0.5)],
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault)),
              ),
              child: Text( name, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.white),
                maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    ) :

    // Card(
    //   color:  Color(0xffE8F5E9),  // Color.fromRGBO(255, 255, 255, 1.0),
    //   shape: CircleBorder(),
    //   elevation: 0,
    //   child: Container(
    //     decoration: BoxDecoration(
    //       //  color: Colors.black.withOpacity(0.065),
    //       shape: BoxShape.circle,
    //     ),
    //     child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           ClipRRect(
    //             borderRadius: BorderRadius.circular(50),
    //             child: CustomImageWidget(
    //               image: image,
    //               height: ResponsiveHelper.isMobile(context) ? 50 : 70,
    //               width: ResponsiveHelper.isMobile(context) ? 50 : 100,
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //
    //           SizedBox(
    //               height: ResponsiveHelper.isMobile(context)
    //                   ? Dimensions.paddingSizeDefault - 10
    //                   : Dimensions.paddingSizeLarge),
    //           Text(
    //             name,
    //             style: robotoMedium.copyWith(
    //               fontSize: Dimensions.fontSizeDefault,
    //             ),
    //             maxLines: 1,
    //             overflow: TextOverflow.ellipsis,
    //             textAlign: TextAlign.center,
    //           ),
    //         ]
    //     ),
    //   ),
    // );





    Column(
      children: [

        // Positioned(
        //   bottom: 25, left: 0, right: 0,
        //   child: CustomPaint(
        //     size: const Size(150, 50),
        //     painter: MyPainter(),
        //   ),
        // ),

        Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                image: image,
                fit: BoxFit.cover, height: fromSearchPage || fromCuisinesPage ? 80 : 90, width: fromSearchPage || fromCuisinesPage ? 80 : 90,
              ),
            ),
          ),
        ),

        Container(
          alignment: Alignment.center,
          height: 25, width: 120,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
            color: Colors.transparent,
          //  boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]!, spreadRadius: 0.5, blurRadius: 0.5)],
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault)),
          ),
          child: Text( name, style: robotoMedium.copyWith(fontSize: 18,color: fromSearchPage || fromCuisinesPage? Colors.black : Colors.black),
            maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
          ),
        ),

      ],
    );
  }
}