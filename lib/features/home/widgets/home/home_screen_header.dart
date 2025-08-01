import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stackfood_multivendor/common/widgets/app_gradient_bg.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/notification/controllers/notification_controller.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/auth_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class HomeScreenHeaderWidget extends StatelessWidget {
   const HomeScreenHeaderWidget({
    this.isSecondScreen = true,
    super.key,
  });

  final bool isSecondScreen;





  @override
  Widget build(BuildContext context) {





    return Stack(
      alignment: Alignment.topLeft,
      children: [
        // AppGradientBackground(height: isSecondScreen ? 210 : 220),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 4, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: InkWell(
                    onTap: () =>
                        Get.toNamed(RouteHelper.getAccessLocationRoute('home')),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall),
                      child: GetBuilder<LocationController>(
                          builder: (locationController) {
                        return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(children: [
                                // AuthHelper.isLoggedIn()
                                    // ? Image.asset(
                                    //     AddressHelper.getAddressFromSharedPref()!
                                    //                 .addressType ==
                                    //             'home'
                                    //         ? Images.restLocation
                                    //         : AddressHelper.getAddressFromSharedPref()!
                                    //                     .addressType ==
                                    //                 'office'
                                    //             ? Icons.work
                                    //             : Icons.location_on,
                                    //     size: 20,
                                    //     color: Theme.of(context).primaryColor,
                                    //   )
                                    // :
                                Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Image.asset(
                                           Images.locationRounded,
                                            width: 27,
                                          ),
                                        ),
                                      ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (AuthHelper.isLoggedIn() &&
                                                AddressHelper
                                                            .getAddressFromSharedPref()!
                                                        .addressType !=
                                                    'others')
                                            ? AddressHelper
                                                    .getAddressFromSharedPref()!
                                                .addressType!
                                                .tr
                                            : 'Deliver To'.tr,
                                        style: robotoMedium.copyWith(
                                          color: Colors.black,
                                          fontSize: Dimensions
                                              .fontSizeDefault /* - (scrollingRate * Dimensions.fontSizeDefault)*/,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              AddressHelper
                                                      .getAddressFromSharedPref()!
                                                  .address!,
                                              style: robotoRegular.copyWith(
                                                color: Colors.black,
                                                fontSize: Dimensions
                                                    .fontSizeSmall /* - (scrollingRate * Dimensions.fontSizeSmall)*/,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: Theme.of(context).cardColor,
                                            size: 16 /*- (scrollingRate * 16)*/,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ]);
                      }),
                    ),
                  ),
                ),
                Get.find<AuthController>().isLoggedIn() ? InkWell(
                  onTap: () {
                    debugPrint("click");
                    Get.toNamed(RouteHelper.getNotificationRoute());
                  },
                  child: GetBuilder<NotificationController>(
                      builder: (notificationController) {
                    return CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Stack(children: [
                        Image.asset(Images.notification,
                            width: 35, ),
                        notificationController.hasNotification
                            ? Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1,
                                        color: Theme.of(context).cardColor),
                                  ),
                                ))
                            : const SizedBox(),
                      ]),
                    );
                  }),
                ) :
                ElevatedButton(
                  onPressed: () async {
                    await Get.toNamed(
                        RouteHelper.getSignInRoute(Get.currentRoute));
                  },
                  child: Text('SIGN UP'.tr),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      textStyle: TextStyle(fontSize: 9),
                      padding: EdgeInsets.only(
                          left: 2, right: 2, top: 4, bottom: 4),
                      backgroundColor: Color(0xff2B9430),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // Makes the button rectangular
                      ),
                      maximumSize: Size(80, 32),
                      minimumSize: Size(80, 32)),
                )

              ],
            ),
          ),
        ),
        // isSecondScreen
        //     ? Positioned(
        //         bottom: 24,
        //         left: 16,
        //         child: RichText(
        //           text: TextSpan(
        //             children: [
        //               TextSpan(
        //                 text: 'Hey there ! \nTime to order?\n',
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 18,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //               TextSpan(
        //                 text: 'Just',
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 24,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //               TextSpan(
        //                 text: ' Bladigo ',
        //                 style: TextStyle(
        //                   color: Colors.greenAccent.withOpacity(0.8),
        //                   fontSize: 24,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //               TextSpan(
        //                 text: 'it?',
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 18,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ))
        //     :

        // GetBuilder<LocalizationController>(
        //   builder: (controller) {
        //     return Positioned(
        //             bottom: 8,
        //             left: controller.isLtr ? 12 : 250,
        //
        //             child: Column(
        //               mainAxisSize: MainAxisSize.min,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 SizedBox(
        //                   height: 48,
        //                 ),
        //                AuthHelper.isLoggedIn() ?
        //                Column(
        //                  crossAxisAlignment: CrossAxisAlignment.start,
        //                  children: [
        //                    Text(
        //                       'Fresh'.tr,
        //                       style: GoogleFonts.montserratAlternates(
        //                         color: Colors.white,
        //                         fontSize: 25,
        //                         fontWeight: FontWeight.bold,
        //                       ),
        //                     ),
        //                    Text(
        //                      'Delicious'.tr,
        //                      style: GoogleFonts.montserratAlternates(
        //                        color: Colors.white,
        //                        fontSize: 25,
        //                        fontWeight: FontWeight.bold,
        //                      ),
        //                    ),
        //                    Text(
        //                       'Quick'.tr,
        //                       style: GoogleFonts.montserratAlternates(
        //                         color: Colors.white,
        //                         fontSize: 25,
        //                         fontWeight: FontWeight.bold,
        //                       ),
        //                     ),
        //                  ],
        //                ) :
        //                Column(
        //                  crossAxisAlignment: CrossAxisAlignment.start,
        //                  children: [
        //                    Text(
        //                      'hey_there'.tr,
        //                      style: GoogleFonts.montserratAlternates(
        //                        color: Colors.white,
        //                        fontSize: 18,
        //                        fontWeight: FontWeight.bold,
        //                      ),
        //                    ),
        //                    Text(
        //                      'Login_or_create'.tr,
        //                      style: GoogleFonts.poppins(
        //                        color: Colors.white,
        //                        fontSize: 11,
        //                        fontWeight: FontWeight.w400,
        //                      ),
        //                    ),
        //                    Text(
        //                      'for_a_faster'.tr,
        //                      style: GoogleFonts.poppins(
        //                        color: Colors.white,
        //                        fontSize: 11,
        //                        fontWeight: FontWeight.w400,
        //                      ),
        //                    ),
        //
        //                  ],
        //                )
        //                 ,
        //
        //
        //                 !Get.find<AuthController>().isLoggedIn() ?
        //                 ElevatedButton(
        //                   onPressed: () async {
        //                     await Get.toNamed(
        //                         RouteHelper.getSignInRoute(Get.currentRoute));
        //                   },
        //                   child: Text('SIGN UP'.tr),
        //                   style: ElevatedButton.styleFrom(
        //                       elevation: 8,
        //                       textStyle: TextStyle(fontSize: 9),
        //                       padding: EdgeInsets.only(
        //                           left: 2, right: 2, top: 4, bottom: 4),
        //                       backgroundColor: Color(0xff2B9430),
        //                       foregroundColor: Colors.white,
        //                       shape: RoundedRectangleBorder(
        //                         borderRadius: BorderRadius.circular(
        //                             8), // Makes the button rectangular
        //                       ),
        //                       maximumSize: Size(80, 32),
        //                       minimumSize: Size(80, 32)),
        //                 ):
        //                     SizedBox()
        //               ],
        //             ),
        //           );
        //   }
        // ),
        // Positioned(
        //   bottom: -20,
        //   right: 0,
        //   child: isSecondScreen
        //       ? Image.asset(
        //           'assets/image/icon_new.png',
        //           height: 160,
        //           width: 200,
        //         )
        //       : Image.asset(
        //           Images.handAssetsImage,
        //           height: 150,
        //           width: 200,
        //         ),
        // ),
      ],
    );
  }
}
