import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/profile/widgets/account_deletion_bottom_sheet.dart';
import 'package:stackfood_multivendor/features/profile/widgets/notification_status_change_bottom_sheet.dart';
import 'package:stackfood_multivendor/features/profile/widgets/profile_button_widget.dart';
import 'package:stackfood_multivendor/features/profile/widgets/profile_card_widget.dart';
import 'package:stackfood_multivendor/features/profile/widgets/web_profile_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/auth/widgets/auth_dialog_widget.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/confirmation_dialog_widget.dart';
import '../../../helper/auth_helper.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../favourite/controllers/favourite_controller.dart';
import '../../menu/widgets/portion_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _initCall();
  }

  void _initCall() {
    if(Get.find<AuthController>().isLoggedIn() && Get.find<ProfileController>().userInfoModel == null) {
      Get.find<ProfileController>().getUserInfo();
    }
    if(Get.find<AuthController>().isLoggedIn() && Get.find<OrderController>().runningOrderList == null){
      Get.find<OrderController>().getRunningOrders(1, notify: false, limit: 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    final bool showWalletCard = Get.find<SplashController>().configModel!.customerWalletStatus == 1
        || Get.find<SplashController>().configModel!.loyaltyPointStatus == 1;

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'profile'.tr),
      endDrawer: isDesktop ? const MenuDrawerWidget() : null,
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: isDesktop ? Theme.of(context).colorScheme.surface : Theme.of(context).cardColor,
      body: GetBuilder<OrderController>(builder: (orderController) {
        return GetBuilder<ProfileController>(builder: (profileController) {
          if ((isLoggedIn && profileController.userInfoModel == null && (orderController.runningOrderList == null))) {
            return const Center(
            child: CircularProgressIndicator(),
          );
          } else {
            return (isLoggedIn && isDesktop) ? WebProfileWidget(profileController: profileController, orderController: orderController) : isLoggedIn ?
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // Profile Header Section
                          Container(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            child: Column(
                              children: [
                                SizedBox(
                                  // height: 120,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeExtraLarge,
                                      vertical: Dimensions.paddingSizeOverLarge,
                                    ),
                                    child: Row(children: [
                                      ClipOval(
                                        child: CustomImageWidget(
                                          placeholder: isLoggedIn
                                              ? Images.profilePlaceholder
                                              : Images.guestIcon,
                                          image: '${(profileController.userInfoModel != null && isLoggedIn) ? profileController.userInfoModel!.imageFullUrl : ''}',
                                          height: 70, width: 70, fit: BoxFit.cover,
                                          imageColor: isLoggedIn ? Theme.of(context).hintColor : null,
                                        ),
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeDefault),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              isLoggedIn
                                                  ? '${profileController.userInfoModel?.fName ?? ''} ${profileController.userInfoModel?.lName ?? ''}'
                                                  : 'guest_user'.tr,
                                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                                            ),
                                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                            isLoggedIn
                                                ? Text(
                                              profileController.userInfoModel?.createdAt != null
                                                  ? '${'joined'.tr} ${DateConverter.containTAndZToUTCFormat(profileController.userInfoModel!.createdAt!)}'
                                                  : '',
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeSmall,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            )
                                                : InkWell(
                                              onTap: () async {
                                                if (!isDesktop) {
                                                  await Get.toNamed(RouteHelper.getSignInRoute(Get.currentRoute));
                                                } else {
                                                  Get.dialog(const Center(
                                                    child: AuthDialogWidget(exitFromApp: false, backFromThis: false),
                                                  )).then((value) {
                                                    _initCall();
                                                    setState(() {});
                                                  });
                                                }
                                              },
                                              child: Text(
                                                'login_to_view_all_feature'.tr,
                                                style: robotoMedium.copyWith(
                                                  fontSize: Dimensions.fontSizeSmall,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      isLoggedIn
                                          ? InkWell(
                                        onTap: () => Get.toNamed(RouteHelper.getUpdateProfileRoute()),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).cardColor,
                                            boxShadow: Get.isDarkMode
                                                ? null
                                                : [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.2),
                                                blurRadius: 3,
                                                spreadRadius: 1,
                                                offset: const Offset(0, 1),
                                              )
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: Icon(Icons.edit_outlined,
                                              size: 24, color: Theme.of(context).primaryColor),
                                        ),
                                      )
                                          : InkWell(
                                        onTap: () async {
                                          if (!isDesktop) {
                                            await Get.toNamed(RouteHelper.getSignInRoute(Get.currentRoute));
                                          } else {
                                            Get.dialog(const Center(
                                              child: AuthDialogWidget(exitFromApp: false, backFromThis: false),
                                            )).then((value) {
                                              _initCall();
                                              setState(() {});
                                            });
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: Dimensions.paddingSizeSmall,
                                            horizontal: Dimensions.paddingSizeLarge,
                                          ),
                                          child: Text(
                                            'login'.tr,
                                            style: robotoMedium.copyWith(color: Theme.of(context).cardColor),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Profile Body Section
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(Dimensions.radiusExtraLarge),
                              ),
                              color: Theme.of(context).cardColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeLarge,
                              vertical: Dimensions.paddingSizeSmall,
                            ),
                            child: Column(
                              children: [

                                isLoggedIn
                                    ? GetBuilder<AuthController>(builder: (authController) {
                                  return ProfileButtonWidget(
                                    icon: Icons.notifications,
                                    title: 'notification'.tr,
                                    isButtonActive: authController.notification,
                                    onTap: () {
                                      Get.bottomSheet(const NotificationStatusChangeBottomSheet());
                                    },
                                  );
                                })
                                    : const SizedBox(),
                                SizedBox(height: isLoggedIn ? Dimensions.paddingSizeSmall : 0),

                                isLoggedIn
                                    ? ProfileButtonWidget(
                                  icon: Icons.lock,
                                  title: 'change_password'.tr,
                                  onTap: () {
                                    Get.toNamed(RouteHelper.getResetPasswordRoute('', '', 'password-change'));
                                  },
                                )
                                    : const SizedBox(),
                                SizedBox(height: isLoggedIn ? Dimensions.paddingSizeSmall : 0),

                                isLoggedIn
                                    ? ProfileButtonWidget(
                                  icon: Icons.delete,
                                  iconImage: Images.profileDelete,
                                  title: 'delete_account'.tr,
                                  onTap: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      useRootNavigator: true,
                                      context: Get.context!,
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(Dimensions.radiusExtraLarge),
                                          topRight: Radius.circular(Dimensions.radiusExtraLarge),
                                        ),
                                      ),
                                      builder: (context) {
                                        return ConstrainedBox(
                                          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                                          child: AccountDeletionBottomSheet(
                                            profileController: profileController,
                                            isRunningOrderAvailable: orderController.runningOrderList != null &&
                                                orderController.runningOrderList!.isNotEmpty,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                )
                                    : const SizedBox(),
                                SizedBox(height: isLoggedIn ? Dimensions.paddingSizeLarge : 0),

                                Text(
                                  'help_and_support'.tr,
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                                  ),
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeLarge,
                                    vertical: Dimensions.paddingSizeDefault,
                                  ),
                                  child: Column(children: [
                                    // PortionWidget(icon: Images.chatIcon, title: 'live_chat'.tr, route: RouteHelper.getConversationRoute()),
                                    PortionWidget(icon: Images.helpIcon, title: 'help_and_support'.tr, route: RouteHelper.getSupportRoute()),
                                    PortionWidget(icon: Images.aboutIcon, title: 'about_us'.tr, route: RouteHelper.getHtmlRoute('about-us')),
                                    PortionWidget(icon: Images.termsIcon, title: 'terms_conditions'.tr, route: RouteHelper.getHtmlRoute('terms-and-condition')),
                                    PortionWidget(icon: Images.privacyIcon, title: 'privacy_policy'.tr, route: RouteHelper.getHtmlRoute('privacy-policy')),

                                    if (Get.find<SplashController>().configModel!.refundPolicyStatus == 1)
                                      PortionWidget(icon: Images.refundIcon, title: 'refund_policy'.tr, route: RouteHelper.getHtmlRoute('refund-policy')),

                                    if (Get.find<SplashController>().configModel!.cancellationPolicyStatus == 1)
                                      PortionWidget(icon: Images.cancelationIcon, title: 'cancellation_policy'.tr, route: RouteHelper.getHtmlRoute('cancellation-policy')),

                                    if (Get.find<SplashController>().configModel!.shippingPolicyStatus == 1)
                                      PortionWidget(icon: Images.shippingIcon, title: 'shipping_policy'.tr, route: RouteHelper.getHtmlRoute('shipping-policy')),

                                    InkWell(
                                      onTap: () async {
                                        if (Get.find<AuthController>().isLoggedIn()) {
                                          Get.dialog(
                                            ConfirmationDialogWidget(
                                              icon: Images.support,
                                              description: 'are_you_sure_to_logout'.tr,
                                              isLogOut: true,
                                              onYesPressed: () async {
                                                Get.find<ProfileController>().setForceFullyUserEmpty();
                                                Get.find<AuthController>().socialLogout();
                                                Get.find<CartController>().clearCartList();
                                                Get.find<FavouriteController>().removeFavourites();
                                                await Get.find<AuthController>().clearSharedData();
                                                Get.offAllNamed(RouteHelper.getInitialRoute());
                                              },
                                            ),
                                            useSafeArea: false,
                                          );
                                        } else {
                                          Get.find<FavouriteController>().removeFavourites();
                                          await Get.toNamed(RouteHelper.getSignInRoute(Get.currentRoute));
                                          if (AuthHelper.isLoggedIn()) {
                                            await Get.find<FavouriteController>().getFavouriteList();
                                            profileController.getUserInfo();
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                              child: Icon(Icons.power_settings_new_sharp,
                                                  size: 14, color: Theme.of(context).cardColor),
                                            ),
                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                            Text(
                                              Get.find<AuthController>().isLoggedIn() ? 'logout'.tr : 'sign_in'.tr,
                                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge1),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),

                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${'version'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                    Text(AppConstants.appVersion.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
 : SizedBox(
              width: Dimensions.webMaxWidth, height: context.height - 87,
              child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                  ClipOval(child: CustomImageWidget(
                    placeholder: isLoggedIn ? Images.profilePlaceholder : Images.guestIcon,
                    image: '${(profileController.userInfoModel != null && isLoggedIn) ? profileController.userInfoModel!.imageFullUrl : ''}',
                    height: 70, width: 70, fit: BoxFit.cover, imageColor: isLoggedIn ? Theme.of(context).hintColor : null,
                  )),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(
                    'guest_user'.tr,
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  SizedBox(
                    width: context.width * 0.6,
                    child: Text(
                      'currently_you_are_in_guest_mode_please_login_to_view_all_the_features'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeOverLarge),

                  CustomButtonWidget(
                    buttonText: 'login'.tr,
                    width: 150,
                    onPressed: () async {
                      if(!isDesktop) {
                        await Get.toNamed(RouteHelper.getSignInRoute(Get.currentRoute))?.then((value) {
                          _initCall();
                          setState(() {});
                        });
                      }else{
                        Get.dialog(const Center(child: AuthDialogWidget(exitFromApp: false, backFromThis: false))).then((value) {
                          _initCall();
                          setState(() {});
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 50),

                ]),
              ),
            );
          }
        });
      }),
    );
  }
}
