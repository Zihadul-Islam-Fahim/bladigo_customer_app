import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/auth/screens/new_sign_in_with_otp_screen.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/language/widgets/language_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/features/menu/widgets/portion_widget.dart';
import 'package:stackfood_multivendor/features/order/screens/new_order_tracking_screen.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/profile/widgets/profile_button_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/features/auth/screens/sign_in_screen.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/helper/auth_helper.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../profile/widgets/profile_card_widget.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {

    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    final bool showWalletCard = Get.find<SplashController>().configModel!.customerWalletStatus == 1
        || Get.find<SplashController>().configModel!.loyaltyPointStatus == 1;


    return Scaffold(

      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<ProfileController>(builder: (profileController) {

        final bool isLoggedIn = Get.find<AuthController>().isLoggedIn();

        return Column(children: [
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: Padding(
              padding: const EdgeInsets.only(
                left: Dimensions.paddingSizeOverLarge,
                right: Dimensions.paddingSizeOverLarge,
                top: 60,
                bottom: Dimensions.paddingSizeSmall,
              ),
              child: Row(children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(1),
                  child: ClipOval(
                      child: CustomImageWidget(
                    placeholder: isLoggedIn
                        ? Images.profilePlaceholder
                        : Images.guestIcon,
                    image:
                        '${(profileController.userInfoModel != null && isLoggedIn) ? profileController.userInfoModel!.imageFullUrl : ''}',
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    imageColor: isLoggedIn ? Theme.of(context).hintColor : null,
                  )),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isLoggedIn && profileController.userInfoModel == null
                            ? Shimmer(
                                duration: const Duration(seconds: 2),
                                enabled: true,
                                child: Container(
                                  height: 16,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[
                                        Get.find<ThemeController>().darkTheme
                                            ? 700
                                            : 200],
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                  ),
                                ),
                              )
                            : Text(
                                isLoggedIn
                                    ? '${profileController.userInfoModel?.fName} ${profileController.userInfoModel?.lName}'
                                    : 'guest_user'.tr,
                                style: robotoBold.copyWith(
                                    fontSize: Dimensions.fontSizeExtraLarge,
                                    color: Colors.black),
                              ),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        isLoggedIn && profileController.userInfoModel != null
                            ? Text(
                                DateConverter.containTAndZToUTCFormat(
                                    profileController
                                        .userInfoModel!.createdAt!),
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: Colors.black),
                              )
                            : InkWell(
                                onTap: () async {
                                  if (!ResponsiveHelper.isDesktop(context)) {
                                    Get.toNamed(RouteHelper.getSignInRoute(
                                            Get.currentRoute))
                                        ?.then((value) {
                                      if (AuthHelper.isLoggedIn()) {
                                        profileController.getUserInfo();
                                      }
                                    });
                                  } else {
                                    Get.dialog(const SignInScreen(
                                            exitFromApp: true,
                                            backFromThis: true))
                                        .then((value) {
                                      if (AuthHelper.isLoggedIn()) {
                                        profileController.getUserInfo();
                                      }
                                    });
                                  }
                                },
                                child: Text(
                                  'login_to_view_all_feature'.tr,
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context).cardColor),
                                ),
                              ),
                      ]),
                ),
              ]),
            ),
          ),

          (showWalletCard && isLoggedIn) ? Padding(
            padding: const EdgeInsets.only(top: 16,left: 16,right: 16),
            child: Row(children: [

              Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 ? Expanded(child: ProfileCardWidget(
                image: Images.loyaltyIcon,
                data: profileController.userInfoModel?.loyaltyPoint != null ? profileController.userInfoModel!.loyaltyPoint.toString() : '0',
                title: 'loyalty_points'.tr,
              )) : const SizedBox(),

              SizedBox(width: Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 ? Dimensions.paddingSizeSmall : 0),

              isLoggedIn ?  Expanded(child: ProfileCardWidget(
                image: Images.shoppingBagIcon,
                data: profileController.userInfoModel?.orderCount != null ? profileController.userInfoModel!.orderCount.toString() : '0',
                title: 'total_order'.tr,
              )) : const SizedBox(),

              SizedBox(width: Get.find<SplashController>().configModel!.customerWalletStatus == 1 ? Dimensions.paddingSizeSmall : 0),

              Get.find<SplashController>().configModel!.customerWalletStatus == 1 ? Expanded(child: ProfileCardWidget(
                image: Images.walletProfile,
                data: PriceConverter.convertPrice(profileController.userInfoModel?.walletBalance != null ? profileController.userInfoModel!.walletBalance : 0),
                title: 'wallet_balance'.tr,
              )) : const SizedBox(),

            ]),
          ) : const SizedBox(),


          Expanded(
              child: SingleChildScrollView(
            child: Ink(
              color: Get.find<ThemeController>().darkTheme
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).cardColor,
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
              child: Column(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: Dimensions.paddingSizeDefault),
                  //   child: Text(
                  //     'general'.tr,
                  //     style: robotoMedium.copyWith(
                  //         fontSize: Dimensions.fontSizeLarge,
                  //         color:
                  //             Theme.of(context).primaryColor.withOpacity(0.5)),
                  //   ),
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault),
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: Colors.grey.withOpacity(0.1),
                      //       spreadRadius: 1,
                      //       blurRadius: 10,
                      //       offset: const Offset(0, 1))
                      // ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeLarge,
                        vertical: Dimensions.paddingSizeDefault),
                    margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Column(children: [
                      PortionWidget(
                          icon: Images.profileIcon,
                          title: 'profile'.tr,
                          route: RouteHelper.getProfileRoute()),
                      PortionWidget(
                          icon: Images.addressIcon,
                          title: 'my_address'.tr,
                          route: RouteHelper.getAddressRoute()),
                      PortionWidget(
                          icon: Images.languageIcon,
                          title: 'language'.tr,
                          onTap: () => _manageLanguageFunctionality(),
                          route: ''),

                      PortionWidget(
                          icon: Images.couponIcon,
                          title: 'coupon'.tr,
                          route:
                          RouteHelper.getCouponRoute(fromCheckout: false)),
                      (Get.find<SplashController>()
                          .configModel!
                          .loyaltyPointStatus ==
                          1)
                          ? PortionWidget(
                        icon: Images.pointIcon,
                        title: 'loyalty_points'.tr,
                        route: RouteHelper.getLoyaltyRoute(),
                        hideDivider: Get.find<SplashController>()
                            .configModel!
                            .customerWalletStatus ==
                            1
                            ? false
                            : true,
                        suffix: !isLoggedIn
                            ? null
                            : '${profileController.userInfoModel?.loyaltyPoint != null ? Get.find<ProfileController>().userInfoModel!.loyaltyPoint.toString() : '0'} ${'points'.tr}',
                      )
                          : const SizedBox(),
                      (Get.find<SplashController>()
                          .configModel!
                          .customerWalletStatus ==
                          1)
                          ? PortionWidget(
                        icon: Images.walletIcon,
                        title: 'my_wallet'.tr,
                        hideDivider: false,
                        route: RouteHelper.getWalletRoute(
                            fromMenuPage: true),
                        suffix: !isLoggedIn
                            ? null
                            : PriceConverter.convertPrice(
                            profileController.userInfoModel != null
                                ? Get.find<ProfileController>()
                                .userInfoModel!
                                .walletBalance
                                : 0),
                      )
                          : const SizedBox(),
                      (Get.find<SplashController>().configModel!.refEarningStatus ==
                          1) ||
                          (Get.find<SplashController>()
                              .configModel!
                              .toggleDmRegistration! &&
                              !ResponsiveHelper.isDesktop(context)) ||
                          (Get.find<SplashController>()
                              .configModel!
                              .toggleRestaurantRegistration! &&
                              !ResponsiveHelper.isDesktop(context))
                          ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: Dimensions.paddingSizeDefault),
                            //   child: Text(
                            //     'earnings'.tr,
                            //     style: robotoMedium.copyWith(
                            //         fontSize: Dimensions.fontSizeLarge,
                            //         color: Theme.of(context)
                            //             .primaryColor
                            //             .withOpacity(0.5)),
                            //   ),
                            // ),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusDefault),
                                // boxShadow: [
                                //   BoxShadow(
                                //       color: Colors.grey.withOpacity(0.1),
                                //       spreadRadius: 1,
                                //       blurRadius: 10,
                                //       offset: const Offset(0, 1))
                                // ],
                              ),
                              // padding: const EdgeInsets.symmetric(
                              //     horizontal: Dimensions.paddingSizeLarge,
                              //     vertical: Dimensions.paddingSizeDefault),
                              // margin: const EdgeInsets.all(
                              //     Dimensions.paddingSizeDefault),
                              child: Column(children: [
                                (Get.find<SplashController>()
                                    .configModel!
                                    .refEarningStatus ==
                                    1)
                                    ? PortionWidget(
                                  icon: Images.referIcon,
                                  title: 'refer_and_earn'.tr,
                                  route:
                                  RouteHelper.getReferAndEarnRoute(),
                                )
                                    : const SizedBox(),
                                // (Get.find<SplashController>()
                                //             .configModel!
                                //             .toggleDmRegistration! &&
                                //         !ResponsiveHelper.isDesktop(context))
                                //     ? PortionWidget(
                                //         icon: Images.dmIcon,
                                //         title: 'join_as_a_delivery_man'.tr,
                                //         route: RouteHelper
                                //             .getDeliverymanRegistrationRoute(),
                                //       )
                                //     : const SizedBox(),
                                // (Get.find<SplashController>()
                                //             .configModel!
                                //             .toggleRestaurantRegistration! &&
                                //         !ResponsiveHelper.isDesktop(context))
                                //     ? PortionWidget(
                                //         icon: Images.storeIcon,
                                //         title: 'open_store'.tr,
                                //         hideDivider: true,
                                //         route: RouteHelper
                                //             .getRestaurantRegistrationRoute(),
                                //       )
                                //     : const SizedBox(),
                              ]),
                            )
                          ])
                          : const SizedBox(),

                      // ProfileButtonWidget(
                      //   icon: Icons.tonality_outlined,
                      //   title: 'dark_mode'.tr,
                      //   isButtonActive: Get.isDarkMode,
                      //   isThemeSwitchButton: true,
                      //   onTap: () {
                      //     Get.find<ThemeController>().toggleTheme();
                      //   },
                      // ),
                    ]),
                  ),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: Dimensions.paddingSizeDefault),
                  //   child: Text(
                  //     'promotional_activity'.tr,
                  //     style: robotoMedium.copyWith(
                  //         fontSize: Dimensions.fontSizeLarge,
                  //         color:
                  //             Theme.of(context).primaryColor.withOpacity(0.5)),
                  //   ),
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault),
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: Colors.grey.withOpacity(0.1),
                      //       spreadRadius: 1,
                      //       blurRadius: 10,
                      //       offset: const Offset(0, 1))
                      // ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeLarge,
                        vertical: Dimensions.paddingSizeDefault),
                    margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Column(children: [
                      // PortionWidget(
                      //     icon: Images.couponIcon,
                      //     title: 'coupon'.tr,
                      //     route:
                      //         RouteHelper.getCouponRoute(fromCheckout: false)),
                      // (Get.find<SplashController>()
                      //             .configModel!
                      //             .loyaltyPointStatus ==
                      //         1)
                      //     ? PortionWidget(
                      //         icon: Images.pointIcon,
                      //         title: 'loyalty_points'.tr,
                      //         route: RouteHelper.getLoyaltyRoute(),
                      //         hideDivider: Get.find<SplashController>()
                      //                     .configModel!
                      //                     .customerWalletStatus ==
                      //                 1
                      //             ? false
                      //             : true,
                      //         suffix: !isLoggedIn
                      //             ? null
                      //             : '${profileController.userInfoModel?.loyaltyPoint != null ? Get.find<ProfileController>().userInfoModel!.loyaltyPoint.toString() : '0'} ${'points'.tr}',
                      //       )
                      //     : const SizedBox(),
                      // (Get.find<SplashController>()
                      //             .configModel!
                      //             .customerWalletStatus ==
                      //         1)
                      //     ? PortionWidget(
                      //         icon: Images.walletIcon,
                      //         title: 'my_wallet'.tr,
                      //         hideDivider: true,
                      //         route: RouteHelper.getWalletRoute(
                      //             fromMenuPage: true),
                      //         suffix: !isLoggedIn
                      //             ? null
                      //             : PriceConverter.convertPrice(
                      //                 profileController.userInfoModel != null
                      //                     ? Get.find<ProfileController>()
                      //                         .userInfoModel!
                      //                         .walletBalance
                      //                     : 0),
                      //       )
                      //     : const SizedBox(),
                    ]),
                  )
                ]),
                // (Get.find<SplashController>().configModel!.refEarningStatus ==
                //             1) ||
                //         (Get.find<SplashController>()
                //                 .configModel!
                //                 .toggleDmRegistration! &&
                //             !ResponsiveHelper.isDesktop(context)) ||
                //         (Get.find<SplashController>()
                //                 .configModel!
                //                 .toggleRestaurantRegistration! &&
                //             !ResponsiveHelper.isDesktop(context))
                //     ? Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //             // Padding(
                //             //   padding: const EdgeInsets.symmetric(
                //             //       horizontal: Dimensions.paddingSizeDefault),
                //             //   child: Text(
                //             //     'earnings'.tr,
                //             //     style: robotoMedium.copyWith(
                //             //         fontSize: Dimensions.fontSizeLarge,
                //             //         color: Theme.of(context)
                //             //             .primaryColor
                //             //             .withOpacity(0.5)),
                //             //   ),
                //             // ),
                //             Container(
                //               decoration: BoxDecoration(
                //                 color: Theme.of(context).cardColor,
                //                 borderRadius: BorderRadius.circular(
                //                     Dimensions.radiusDefault),
                //                 // boxShadow: [
                //                 //   BoxShadow(
                //                 //       color: Colors.grey.withOpacity(0.1),
                //                 //       spreadRadius: 1,
                //                 //       blurRadius: 10,
                //                 //       offset: const Offset(0, 1))
                //                 // ],
                //               ),
                //               // padding: const EdgeInsets.symmetric(
                //               //     horizontal: Dimensions.paddingSizeLarge,
                //               //     vertical: Dimensions.paddingSizeDefault),
                //               // margin: const EdgeInsets.all(
                //               //     Dimensions.paddingSizeDefault),
                //               child: Column(children: [
                //                 (Get.find<SplashController>()
                //                             .configModel!
                //                             .refEarningStatus ==
                //                         1)
                //                     ? PortionWidget(
                //                         icon: Images.referIcon,
                //                         title: 'refer_and_earn'.tr,
                //                         route:
                //                             RouteHelper.getReferAndEarnRoute(),
                //                       )
                //                     : const SizedBox(),
                //                 // (Get.find<SplashController>()
                //                 //             .configModel!
                //                 //             .toggleDmRegistration! &&
                //                 //         !ResponsiveHelper.isDesktop(context))
                //                 //     ? PortionWidget(
                //                 //         icon: Images.dmIcon,
                //                 //         title: 'join_as_a_delivery_man'.tr,
                //                 //         route: RouteHelper
                //                 //             .getDeliverymanRegistrationRoute(),
                //                 //       )
                //                 //     : const SizedBox(),
                //                 // (Get.find<SplashController>()
                //                 //             .configModel!
                //                 //             .toggleRestaurantRegistration! &&
                //                 //         !ResponsiveHelper.isDesktop(context))
                //                 //     ? PortionWidget(
                //                 //         icon: Images.storeIcon,
                //                 //         title: 'open_store'.tr,
                //                 //         hideDivider: true,
                //                 //         route: RouteHelper
                //                 //             .getRestaurantRegistrationRoute(),
                //                 //       )
                //                 //     : const SizedBox(),
                //               ]),
                //             )
                //           ])
                //     : const SizedBox(),


                const SizedBox(height: Dimensions.paddingSizeOverLarge)
              ]),
            ),
          )),
        ]);
      }),
    );
  }

  _manageLanguageFunctionality() {
    Get.find<LocalizationController>().saveCacheLanguage(null);
    Get.find<LocalizationController>().searchSelectedLanguage();

    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      context: Get.context!,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge),
            topRight: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: const LanguageBottomSheetWidget(),
        );
      },
    ).then((value) => Get.find<LocalizationController>().setLanguage(
        Get.find<LocalizationController>().getCacheLocaleFromSharedPref()));
  }
}
