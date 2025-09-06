import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:stackfood_multivendor/features/cart/screens/cart_screen.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/congratulation_dialogue.dart';
import 'package:stackfood_multivendor/features/dashboard/widgets/registration_success_bottom_sheet.dart';
import 'package:stackfood_multivendor/features/home/screens/home_screen.dart';
import 'package:stackfood_multivendor/features/menu/screens/menu_screen.dart';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/screens/order_screen.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/dashboard/controllers/dashboard_controller.dart';
import 'package:stackfood_multivendor/features/dashboard/widgets/address_bottom_sheet.dart';
import 'package:stackfood_multivendor/features/dashboard/widgets/bottom_nav_item.dart';
import 'package:stackfood_multivendor/features/dashboard/widgets/running_order_view_widget.dart';
import 'package:stackfood_multivendor/features/favourite/screens/favourite_screen.dart';
import 'package:stackfood_multivendor/features/loyalty/controllers/loyalty_controller.dart';
import 'package:stackfood_multivendor/features/wallet/screens/wallet_screen.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/cart_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_dialog_widget.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  final bool fromSplash;
  const DashboardScreen(
      {super.key, required this.pageIndex, this.fromSplash = false});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;
  late bool _isLogin;
  bool active = false;

  @override
  void initState() {
    super.initState();

    _isLogin = Get.find<AuthController>().isLoggedIn();

    _showRegistrationSuccessBottomSheet();

    if (_isLogin) {
      if (Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 &&
          Get.find<LoyaltyController>().getEarningPint().isNotEmpty &&
          !ResponsiveHelper.isDesktop(Get.context)) {
        Future.delayed(
            const Duration(seconds: 1),
            () => showAnimatedDialog(
                Get.context!, const CongratulationDialogue()));
      }
      _suggestAddressBottomSheet();
      Get.find<OrderController>().getRunningOrders(1, notify: false);
    }

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      const FavouriteScreen(),
      const WalletScreen(),
      const CartScreen(fromNav: true),
      const OrderScreen(),
      const MenuScreen()
    ];

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  _showRegistrationSuccessBottomSheet() {
    bool canShowBottomSheet =
        Get.find<DashboardController>().getRegistrationSuccessfulSharedPref();
    if (canShowBottomSheet) {
      Future.delayed(const Duration(seconds: 1), () {
        ResponsiveHelper.isDesktop(Get.context)
            ? Get.dialog(const Dialog(child: RegistrationSuccessBottomSheet()))
                .then((value) {
                Get.find<DashboardController>()
                    .saveRegistrationSuccessfulSharedPref(false);
                Get.find<DashboardController>()
                    .saveIsRestaurantRegistrationSharedPref(false);
                setState(() {});
              })
            : showModalBottomSheet(
                context: Get.context!,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (con) => const RegistrationSuccessBottomSheet(),
              ).then((value) {
                Get.find<DashboardController>()
                    .saveRegistrationSuccessfulSharedPref(false);
                Get.find<DashboardController>()
                    .saveIsRestaurantRegistrationSharedPref(false);
                setState(() {});
              });
      });
    }
  }

  Future<void> _suggestAddressBottomSheet() async {
    active = await Get.find<DashboardController>().checkLocationActive();
    if (widget.fromSplash &&
        Get.find<DashboardController>().showLocationSuggestion &&
        active) {
      Future.delayed(const Duration(seconds: 1), () {
        showModalBottomSheet(
          context: Get.context!,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          showDragHandle: true,
          enableDrag: false,
          builder: (con) => const AddressBottomSheet(),
        ).then((value) {
          Get.find<DashboardController>().hideSuggestedLocation();
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) async {
        debugPrint('$_canExit');
        if (_pageIndex != 0) {
          _setPage(0);
        } else {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            }
          }
          if (!ResponsiveHelper.isDesktop(context)) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr,
                  style: const TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            ));
          }
          _canExit = true;

          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton:
            GetBuilder<OrderController>(builder: (orderController) {
          return ResponsiveHelper.isDesktop(context) || keyboardVisible
              ? const SizedBox()
              : (orderController.showBottomSheet &&
                      orderController.runningOrderList != null &&
                      orderController.runningOrderList!.isNotEmpty &&
                      _isLogin)
                  ? const SizedBox.shrink()
                  : Material(
                      elevation: 3,
                      color: Theme.of(context).primaryColor,
                      shape: const CircleBorder(),
                      child: FloatingActionButton(
                        backgroundColor: _pageIndex == 2
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColor,
                        onPressed: () {
                          // _setPage(2);
                          Get.toNamed(RouteHelper.getCartRoute());
                        },
                        child: CartWidget(
                            color: _pageIndex == 2
                                ? Theme.of(context).cardColor
                                : Theme.of(context).cardColor,
                            size: 30),
                      ),
                    );
        }),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: ResponsiveHelper.isDesktop(context)
            ? const SizedBox()
            : GetBuilder<OrderController>(builder: (orderController) {
                return (orderController.showBottomSheet &&
                        (orderController.runningOrderList != null &&
                            orderController.runningOrderList!.isNotEmpty &&
                            _isLogin))
                    ? const SizedBox()
                    : BottomAppBar(
                        elevation: 5,
                        notchMargin: 8,
                        height: 64,
                        clipBehavior: Clip.antiAlias,
                        shape: const CircularNotchedRectangle(),
                        shadowColor: Theme.of(context).disabledColor,
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeExtraSmall),
                          child: Row(children: [
                            SizedBox(
                              width: 12,
                            ),
                            KBottomNavItem(
                              imageAsset: 'assets/image/home.png',
                              selectedImage: 'assets/image/home_filled.png',

                              label: 'Home'.tr,
                              isSelected: _pageIndex == 0,
                              onTap: () => _setPage(0),
                            ),
                            Spacer(),
                            KBottomNavItem(
                              imageAsset: 'assets/image/my_order.png',
                              selectedImage: 'assets/image/order_filled.png',
                              label: 'my_orders'.tr,
                              isSelected: _pageIndex == 4,
                              onTap: () => _setPage(4),
                            ),
                            Spacer(),
                            // const Expanded(child: SizedBox()),
                            KBottomNavItem(
                              imageAsset: 'assets/image/wallet_bottom.png',
                              selectedImage: 'assets/image/wallet_bottom.png',
                              label: 'wallet'.tr,
                              isSelected: _pageIndex == 2,
                              onTap: () => _setPage(2),
                            ),
                            Spacer(),
                            KBottomNavItem(
                              imageAsset: 'assets/image/fav.png',
                              selectedImage: 'assets/image/fav_filled.png',
                              label: 'Favorites'.tr,
                              isSelected: _pageIndex == 1,
                              onTap: () => _setPage(1),
                            ),
                            Spacer(),
                            KBottomNavItem(
                              imageAsset: 'assets/image/person.png',
                              selectedImage: 'assets/image/person_filled.png',
                              label: 'Profile'.tr,
                              isSelected: _pageIndex == 5,
                              onTap: () => _setPage(5),
                            ),
                            SizedBox(
                              width: 12,
                            )
                          ],
                          ),
                        ),
                      );
              }),
        body: GetBuilder<OrderController>(builder: (orderController) {
          List<OrderModel> runningOrder =
              orderController.runningOrderList != null
                  ? orderController.runningOrderList!
                  : [];

          List<OrderModel> reversOrder = List.from(runningOrder.reversed);
          return ExpandableBottomSheet(
            background: PageView.builder(
              controller: _pageController,
              itemCount: _screens.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _screens[index];
              },
            ),
            persistentContentHeight: 120,
            onIsContractedCallback: () {
              if (!orderController.showOneOrder) {
                orderController.showOrders();
              }
            },
            onIsExtendedCallback: () {
              if (orderController.showOneOrder) {
                orderController.showOrders();
              }
            },
            enableToggle: true,
            expandableContent: (ResponsiveHelper.isDesktop(context) ||
                !_isLogin ||
                orderController.runningOrderList == null ||
                orderController.runningOrderList!.isEmpty ||
                !orderController.showBottomSheet)
                ? const SizedBox()
                : Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                if (orderController.showBottomSheet) {
                  orderController.showRunningOrders();
                }
              },
              child: Stack(
                children: [
                  RunningOrderViewWidget(
                    reversOrder: reversOrder,
                    onMoreClick: () {
                      if (orderController.showBottomSheet) {
                        orderController.showRunningOrders();
                      }
                      _setPage(3);
                    },
                  ),
                  // Positioned(
                  //   top: 0,
                  //   left: 0,
                  //   right: 0,
                  //   child: IconButton(
                  //     icon: Icon(Icons.close),
                  //     onPressed: () {
                  //       if (orderController.showBottomSheet) {
                  //         orderController.showRunningOrders();
                  //       }
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> _setPage(int pageIndex) async {
    if (await Vibration.hasVibrator() ?? false) {
    Vibration.vibrate(duration: AppConstants.vibrationDuration); // 100ms vibration
    }
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}

class KBottomNavItem extends StatelessWidget {
  final String? imageAsset;
  final String? selectedImage;
  final String? label;
  final IconData? iconData;
  final bool isSelected;
  final VoidCallback onTap;

  const KBottomNavItem({
    super.key,
    this.imageAsset,
    this.selectedImage,
    this.label,
    this.iconData,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageAsset != null
              ?
          isSelected ? Image.asset(
            selectedImage!,
            height: 24,
            width: 24,

          ) : Image.asset(
                  imageAsset!,
                  height: 24,
                  width: 24,
            color: Colors.grey,

                )
              : Icon(
                  iconData,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
          if (label != null)
            Text(
              label!,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
