import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/cart/widgets/cart_product_widget.dart';
import 'package:stackfood_multivendor/features/cart/widgets/cart_suggested_item_view_widget.dart';
import 'package:stackfood_multivendor/features/cart/widgets/checkout_button_widget.dart';
import 'package:stackfood_multivendor/features/cart/widgets/pricing_view_widget.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/custom_container_button.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/delivery_man_tips_section.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_constrained_box.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  final bool fromNav;
  final bool fromReorder;

  const CartScreen(
      {super.key, required this.fromNav, this.fromReorder = false});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ScrollController scrollController = ScrollController();
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();

  final GlobalKey _widgetKey = GlobalKey();
  double _height = 0;

  @override
  void initState() {
    super.initState();

    initCall();
  }

  Future<void> initCall() async {
    _initialBottomSheetShowHide();
    Get.find<RestaurantController>().makeEmptyRestaurant(willUpdate: false);
    Get.find<CartController>().setAvailableIndex(-1, willUpdate: false);
    Get.find<CheckoutController>().setInstruction(-1, willUpdate: false);
    await Get.find<CartController>().getCartDataOnline();
    if (Get.find<CartController>().cartList.isNotEmpty) {
      await Get.find<RestaurantController>().getRestaurantDetails(
          Restaurant(
              id: Get.find<CartController>().cartList[0].product!.restaurantId,
              name: null),
          fromCart: true);
      Get.find<CartController>().calculationCart();
      if (Get.find<CartController>().addCutlery) {
        Get.find<CartController>().updateCutlery(isUpdate: false);
      }
      if (Get.find<CartController>().needExtraPackage) {
        Get.find<CartController>().toggleExtraPackage(willUpdate: false);
      }
      Get.find<RestaurantController>().getCartRestaurantSuggestedItemList(
          Get.find<CartController>().cartList[0].product!.restaurantId);
      showReferAndEarnSnackBar();
    }
  }

  void _initialBottomSheetShowHide() {
    Future.delayed(const Duration(milliseconds: 600), () {
      key.currentState!.expand();
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          key.currentState!.contract();
        });
      });
    });
  }

  void _getExpandedBottomSheetHeight() {
    // Use the key to get the context and the size of the widget
    final RenderBox renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox;
    final size = renderBox.size;

    setState(() {
      _height = size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBarWidget(
          title: 'my_cart'.tr,
          isBackButtonExist: (isDesktop || !widget.fromNav)),
      endDrawer: const MenuDrawerWidget(),
      endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<RestaurantController>(builder: (restaurantController) {
        return GetBuilder<CartController>(
          builder: (cartController) {
            bool isRestaurantOpen = true;

            if (restaurantController.restaurant != null) {
              isRestaurantOpen = restaurantController.isRestaurantOpenNow(
                  restaurantController.restaurant!.active!,
                  restaurantController.restaurant!.schedules);
            }

            bool suggestionEmpty =
                (restaurantController.suggestedItems != null &&
                    restaurantController.suggestedItems!.isEmpty);
            return (cartController.isLoading && widget.fromReorder)
                ? const Center(
                    child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator()),
                  )
                : cartController.cartList.isNotEmpty
                    ? Column(
                        children: [
                          Expanded(
                            child: ExpandableBottomSheet(
                              key: key,
                              // persistentHeader: isDesktop
                              //     ? const SizedBox()
                              //     : InkWell(
                              //         onTap: () {
                              //           if (cartController.isExpanded) {
                              //             cartController.setExpanded(false);
                              //             setState(() {
                              //               key.currentState!.contract();
                              //             });
                              //           } else {
                              //             cartController.setExpanded(true);
                              //             setState(() {
                              //               key.currentState!.expand();
                              //             });
                              //           }
                              //         },
                              //         child: Container(
                              //           color: Theme.of(context).cardColor,
                              //           child: Container(
                              //             constraints:
                              //                 const BoxConstraints.expand(
                              //                     height: 30),
                              //             decoration: BoxDecoration(
                              //               color: Theme.of(context)
                              //                   .disabledColor
                              //                   .withOpacity(0.5),
                              //               borderRadius: const BorderRadius
                              //                   .only(
                              //                   topLeft: Radius.circular(
                              //                       Dimensions.radiusDefault),
                              //                   topRight: Radius.circular(
                              //                       Dimensions.radiusDefault)),
                              //             ),
                              //             child: Icon(Icons.drag_handle,
                              //                 color:
                              //                     Theme.of(context).hintColor,
                              //                 size: 25),
                              //           ),
                              //         ),
                              //       ),
                              background: Column(
                                children: [
                                  WebScreenTitleWidget(title: 'my_cart'.tr),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      padding: isDesktop
                                          ? const EdgeInsets.only(
                                              top: Dimensions.paddingSizeSmall)
                                          : EdgeInsets.only(
                                              top: 8, left: 12, right: 12),
                                      child: FooterViewWidget(
                                        child: Center(
                                          child: SizedBox(
                                            width: Dimensions.webMaxWidth,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // _buildTopButton(context),
                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          flex: 6,
                                                          child: Column(
                                                              children: [
                                                                Container(
                                                                  decoration: isDesktop
                                                                      ? BoxDecoration(
                                                                          borderRadius: const BorderRadius
                                                                              .all(
                                                                              Radius.circular(Dimensions.radiusDefault)),
                                                                          color:
                                                                              Theme.of(context).cardColor,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                color: Colors.grey.withOpacity(0.1),
                                                                                spreadRadius: 1,
                                                                                blurRadius: 10,
                                                                                offset: const Offset(0, 1))
                                                                          ],
                                                                        )
                                                                      : const BoxDecoration(),
                                                                  child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        WebConstrainedBox(
                                                                          dataLength: cartController
                                                                              .cartList
                                                                              .length,
                                                                          minLength:
                                                                              5,
                                                                          minHeight: suggestionEmpty
                                                                              ? 0.6
                                                                              : 0.3,
                                                                          child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                !isRestaurantOpen && restaurantController.restaurant != null
                                                                                    ? !isDesktop
                                                                                        ? Center(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                                                                                              child: RichText(
                                                                                                textAlign: TextAlign.center,
                                                                                                text: TextSpan(children: [
                                                                                                  TextSpan(text: 'currently_the_restaurant_is_unavailable_the_restaurant_will_be_available_at'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                                                                                                  const TextSpan(text: ' '),
                                                                                                  TextSpan(
                                                                                                    text: restaurantController.restaurant!.restaurantOpeningTime == 'closed' ? 'tomorrow'.tr : DateConverter.timeStringToTime(restaurantController.restaurant!.restaurantOpeningTime!),
                                                                                                    style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                                                                                                  ),
                                                                                                ]),
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        : Container(
                                                                                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                                                            decoration: BoxDecoration(
                                                                                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                                                                                              borderRadius: const BorderRadius.only(
                                                                                                topLeft: Radius.circular(Dimensions.radiusDefault),
                                                                                                topRight: Radius.circular(Dimensions.radiusDefault),
                                                                                              ),
                                                                                            ),
                                                                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                                              RichText(
                                                                                                textAlign: TextAlign.start,
                                                                                                text: TextSpan(children: [
                                                                                                  TextSpan(text: 'currently_the_restaurant_is_unavailable_the_restaurant_will_be_available_at'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                                                                                                  const TextSpan(text: ' '),
                                                                                                  TextSpan(
                                                                                                    text: restaurantController.restaurant!.restaurantOpeningTime == 'closed' ? 'tomorrow'.tr : DateConverter.timeStringToTime(restaurantController.restaurant!.restaurantOpeningTime!),
                                                                                                    style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                                                                                                  ),
                                                                                                ]),
                                                                                              ),
                                                                                              !isRestaurantOpen
                                                                                                  ? Align(
                                                                                                      alignment: Alignment.center,
                                                                                                      child: InkWell(
                                                                                                        onTap: () {
                                                                                                          cartController.clearCartOnline();
                                                                                                        },
                                                                                                        child: Container(
                                                                                                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                                                                          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: Theme.of(context).cardColor,
                                                                                                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                                                                                            border: Border.all(width: 1, color: Theme.of(context).disabledColor.withOpacity(0.3)),
                                                                                                          ),
                                                                                                          child: !cartController.isClearCartLoading
                                                                                                              ? Row(mainAxisSize: MainAxisSize.min, children: [
                                                                                                                  Icon(CupertinoIcons.delete_solid, color: Theme.of(context).colorScheme.error, size: 20),
                                                                                                                  const SizedBox(width: Dimensions.paddingSizeSmall),
                                                                                                                  Text(
                                                                                                                    cartController.cartList.length > 1 ? 'remove_all_from_cart'.tr : 'remove_from_cart'.tr,
                                                                                                                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.7)),
                                                                                                                  ),
                                                                                                                ])
                                                                                                              : const SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                  : const SizedBox(),
                                                                                            ]),
                                                                                          )
                                                                                    : const SizedBox(),
                                                                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                                                                ConstrainedBox(
                                                                                  constraints: BoxConstraints(maxHeight: isDesktop ? MediaQuery.of(context).size.height * 0.4 : double.infinity),
                                                                                  child: Card(
                                                                                    color: Theme.of(context).scaffoldBackgroundColor,
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        // const SizedBox(height: Dimensions.paddingSizeSmall),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(left: 15, right: 8),
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              Text(
                                                                                                "Your Order",
                                                                                                style: robotoMedium.copyWith(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                                                                                              ),
                                                                                              TextButton(onPressed: () {}, child: Text("Clear Cart", style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: 13, fontWeight: FontWeight.w600)))
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Divider(
                                                                                          height: 0,
                                                                                          color: Colors.grey.withOpacity(.2),
                                                                                        ),
                                                                                        SizedBox(height: 12),
                                                                                        ListView.separated(
                                                                                          physics: isDesktop ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                                                                                          shrinkWrap: true,
                                                                                          padding: const EdgeInsets.only(
                                                                                            left: 4,
                                                                                            right: 4,
                                                                                            // top: Dimensions.paddingSizeDefault,
                                                                                          ),
                                                                                          separatorBuilder: (context, index) => Divider(
                                                                                            height: 0,
                                                                                            color: Colors.grey.withOpacity(.2),
                                                                                          ),
                                                                                          itemCount: cartController.cartList.length,
                                                                                          itemBuilder: (context, index) {
                                                                                            return CartProductWidget(
                                                                                              cart: cartController.cartList[index],
                                                                                              cartIndex: index,
                                                                                              addOns: cartController.addOnsList[index],
                                                                                              isAvailable: cartController.availableList[index],
                                                                                              isRestaurantOpen: isRestaurantOpen,
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                        Divider(
                                                                                          height: 8,
                                                                                          color: Colors.grey.withOpacity(.2),
                                                                                        ),

                                                                                        Container(
                                                                                          alignment: Alignment.centerLeft,
                                                                                          // color: Theme.of(context).cardColor.withOpacity(0.6),
                                                                                          child: TextButton.icon(
                                                                                            onPressed: () {
                                                                                              if (isRestaurantOpen) {
                                                                                                Get.toNamed(
                                                                                                  RouteHelper.getRestaurantRoute(cartController.cartList[0].product!.restaurantId),
                                                                                                  arguments: RestaurantScreen(restaurant: Restaurant(id: cartController.cartList[0].product!.restaurantId)),
                                                                                                );
                                                                                              } else {
                                                                                                Get.offAllNamed(RouteHelper.getInitialRoute(fromSplash: true));
                                                                                              }
                                                                                            },
                                                                                            icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
                                                                                            label: Text(
                                                                                              isRestaurantOpen ? 'add_more_items'.tr : 'add_from_another_restaurants'.tr,
                                                                                              style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                !isRestaurantOpen
                                                                                    ? !isDesktop
                                                                                        ? Align(
                                                                                            alignment: Alignment.center,
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                                                                              child: CustomInkWellWidget(
                                                                                                onTap: () {
                                                                                                  cartController.clearCartOnline();
                                                                                                },
                                                                                                child: Container(
                                                                                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: Theme.of(context).cardColor,
                                                                                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                                                                                    border: Border.all(width: 1, color: Theme.of(context).disabledColor.withOpacity(0.3)),
                                                                                                  ),
                                                                                                  child: !cartController.isClearCartLoading
                                                                                                      ? Row(mainAxisSize: MainAxisSize.min, children: [
                                                                                                          Icon(CupertinoIcons.delete_solid, color: Theme.of(context).colorScheme.error, size: 20),
                                                                                                          const SizedBox(width: Dimensions.paddingSizeSmall),
                                                                                                          Text(cartController.cartList.length > 1 ? 'remove_all_from_cart'.tr : 'remove_from_cart'.tr, style: robotoMedium.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeSmall)),
                                                                                                        ])
                                                                                                      : const SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        : const SizedBox()
                                                                                    : const SizedBox(),

                                                                                // !isDesktop ? const SizedBox(height: Dimensions.paddingSizeLarge): const SizedBox(),

                                                                                // !isDesktop ? Container(height: 1, color: Theme.of(context).disabledColor.withOpacity(0.3)) : const SizedBox(),

                                                                                SizedBox(height: isDesktop ? 40 : 0),

                                                                                SizedBox(height: !isDesktop ? 0 : 8),

                                                                                !isDesktop ? CartSuggestedItemViewWidget(cartList: cartController.cartList) : const SizedBox(),
                                                                              ]),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                Dimensions.paddingSizeSmall),

                                                                        // !isDesktop ? PricingViewWidget(cartController: cartController, isRestaurantOpen: isRestaurantOpen,) : const SizedBox(),
                                                                      ]),
                                                                ),
                                                                const SizedBox(
                                                                    height: Dimensions
                                                                        .paddingSizeSmall),
                                                                isDesktop
                                                                    ? CartSuggestedItemViewWidget(
                                                                        cartList:
                                                                            cartController.cartList)
                                                                    : const SizedBox(),
                                                              ]),
                                                        ),
                                                        SizedBox(
                                                            width: isDesktop
                                                                ? Dimensions
                                                                    .paddingSizeLarge
                                                                : 0),
                                                        isDesktop
                                                            ? Expanded(
                                                                flex: 4,
                                                                child:
                                                                    PricingViewWidget(
                                                                  cartController:
                                                                      cartController,
                                                                  isRestaurantOpen:
                                                                      isRestaurantOpen,
                                                                ))
                                                            : const SizedBox(),
                                                      ]),
                                                  // Card(
                                                  //   elevation: 0,
                                                  //   shape:
                                                  //       RoundedRectangleBorder(
                                                  //           borderRadius:
                                                  //               BorderRadius
                                                  //                   .circular(
                                                  //                       10)),
                                                  //   child: Padding(
                                                  //     padding: const EdgeInsets
                                                  //         .symmetric(
                                                  //         horizontal: 16,
                                                  //         vertical: 12),
                                                  //     child: Row(
                                                  //       mainAxisAlignment:
                                                  //           MainAxisAlignment
                                                  //               .spaceBetween,
                                                  //       children: [
                                                  //         Text(
                                                  //           'Add Coupon',
                                                  //           style: TextStyle(
                                                  //             fontWeight:
                                                  //                 FontWeight
                                                  //                     .bold,
                                                  //             fontSize: 16,
                                                  //           ),
                                                  //         ),
                                                  //         GestureDetector(
                                                  //           onTap: () {},
                                                  //           child: Text(
                                                  //             'View all',
                                                  //             style: TextStyle(
                                                  //               color: Colors
                                                  //                   .green,
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .bold,
                                                  //               fontSize: 14,
                                                  //             ),
                                                  //           ),
                                                  //         ),
                                                  //       ],
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  // Card(
                                                  //   elevation: 2,
                                                  //   shape:
                                                  //       RoundedRectangleBorder(
                                                  //           borderRadius:
                                                  //               BorderRadius
                                                  //                   .circular(
                                                  //                       10)),
                                                  //   child: Padding(
                                                  //     padding:
                                                  //         const EdgeInsets.all(
                                                  //             16.0),
                                                  //     child: Column(
                                                  //       crossAxisAlignment:
                                                  //           CrossAxisAlignment
                                                  //               .start,
                                                  //       children: [
                                                  //         Text(
                                                  //           'Tip Delivery Partner',
                                                  //           style: TextStyle(
                                                  //             fontWeight:
                                                  //                 FontWeight
                                                  //                     .bold,
                                                  //             fontSize: 16,
                                                  //           ),
                                                  //         ),
                                                  //         const SizedBox(
                                                  //             height: 8),
                                                  //         Text(
                                                  //           'Helping Your Delivery Partner By Adding Tip.',
                                                  //           style: TextStyle(
                                                  //             color: Colors
                                                  //                 .grey[600],
                                                  //             fontSize: 14,
                                                  //           ),
                                                  //         ),
                                                  //         Divider(
                                                  //           color: Colors.grey
                                                  //               .withOpacity(
                                                  //                   .2),
                                                  //         ),
                                                  //         const SizedBox(
                                                  //             height: 8),
                                                  //         Row(
                                                  //           mainAxisAlignment:
                                                  //               MainAxisAlignment
                                                  //                   .spaceEvenly,
                                                  //           children: [
                                                  //             _buildTipButton(
                                                  //                 amount:
                                                  //                     '\$10'),
                                                  //             _buildTipButton(
                                                  //                 amount:
                                                  //                     '\$20'),
                                                  //             _buildTipButton(
                                                  //                 amount:
                                                  //                     '\$30'),
                                                  //             _buildTipButton(
                                                  //                 amount:
                                                  //                     '\$40'),
                                                  //             _buildTipButton(
                                                  //                 amount:
                                                  //                     'Other',
                                                  //                 isOther:
                                                  //                     true),
                                                  //           ],
                                                  //         ),
                                                  //       ],
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: _height),
                                ],
                              ),
                              // onIsExtendedCallback: () {
                              //   ///Don't remove this print.
                              //   print('======= expandableContent open');
                              //   _getExpandedBottomSheetHeight();
                              // },
                              // onIsContractedCallback: () {
                              //   ///Don't remove this print.
                              //   print('======= expandableContent close');
                              //   setState(() {
                              //     _height = 0;
                              //   });
                              // },
                              expandableContent: isDesktop
                                  ? const SizedBox()
                                  : Container(
                                      width: context.width,
                                      key:
                                          _widgetKey, // Assign the GlobalKey to the widget
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(
                                                Dimensions.radiusDefault),
                                            topRight: Radius.circular(
                                                Dimensions.radiusDefault)),
                                      ),
                                      child: Column(children: [
                                        // Container(
                                        //   padding: const EdgeInsets.only(
                                        //     left: Dimensions.paddingSizeDefault,
                                        //     right:
                                        //         Dimensions.paddingSizeDefault,
                                        //     top: Dimensions.paddingSizeSmall,
                                        //   ),
                                        //   decoration: BoxDecoration(
                                        //     color: Theme.of(context).cardColor,
                                        //     borderRadius: const BorderRadius
                                        //         .only(
                                        //         topLeft: Radius.circular(
                                        //             Dimensions.radiusDefault),
                                        //         topRight: Radius.circular(
                                        //             Dimensions.radiusDefault)),
                                        //   ),
                                        //   child: Column(children: [
                                        //     Row(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment
                                        //                 .spaceBetween,
                                        //         children: [
                                        //           Text('item_price'.tr,
                                        //               style: robotoRegular),
                                        //           PriceConverter
                                        //               .convertAnimationPrice(
                                        //                   cartController
                                        //                       .itemPrice,
                                        //                   textStyle:
                                        //                       robotoRegular),
                                        //         ]),
                                        //     SizedBox(
                                        //         height: cartController
                                        //                     .variationPrice >
                                        //                 0
                                        //             ? Dimensions
                                        //                 .paddingSizeSmall
                                        //             : 0),
                                        //     cartController.variationPrice > 0
                                        //         ? Row(
                                        //             mainAxisAlignment:
                                        //                 MainAxisAlignment
                                        //                     .spaceBetween,
                                        //             children: [
                                        //               Text('variations'.tr,
                                        //                   style: robotoRegular),
                                        //               Text(
                                        //                   '(+) ${PriceConverter.convertPrice(cartController.variationPrice)}',
                                        //                   style: robotoRegular,
                                        //                   textDirection:
                                        //                       TextDirection
                                        //                           .ltr),
                                        //             ],
                                        //           )
                                        //         : const SizedBox(),
                                        //     const SizedBox(
                                        //         height: Dimensions
                                        //             .paddingSizeSmall),
                                        //     Row(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment
                                        //                 .spaceBetween,
                                        //         children: [
                                        //           Text('discount'.tr,
                                        //               style: robotoRegular),
                                        //           restaurantController
                                        //                       .restaurant !=
                                        //                   null
                                        //               ? Row(children: [
                                        //                   Text('(-)',
                                        //                       style:
                                        //                           robotoRegular),
                                        //                   PriceConverter
                                        //                       .convertAnimationPrice(
                                        //                           cartController
                                        //                               .itemDiscountPrice,
                                        //                           textStyle:
                                        //                               robotoRegular),
                                        //                 ])
                                        //               : Text('calculating'.tr,
                                        //                   style: robotoRegular),
                                        //         ]),
                                        //     const SizedBox(
                                        //         height: Dimensions
                                        //             .paddingSizeSmall),
                                        //     Row(
                                        //       mainAxisAlignment:
                                        //           MainAxisAlignment
                                        //               .spaceBetween,
                                        //       children: [
                                        //         Text('addons'.tr,
                                        //             style: robotoRegular),
                                        //         Row(children: [
                                        //           Text('(+)',
                                        //               style: robotoRegular),
                                        //           PriceConverter
                                        //               .convertAnimationPrice(
                                        //                   cartController.addOns,
                                        //                   textStyle:
                                        //                       robotoRegular),
                                        //         ]),
                                        //       ],
                                        //     ),
                                        //   ]),
                                        // ),
                                      ]),
                                    ),
                            ),
                          ),
                          isDesktop
                              ? const SizedBox.shrink()
                              : CheckoutButtonWidget(
                                  cartController: cartController,
                                  availableList: cartController.availableList,
                                  isRestaurantOpen: isRestaurantOpen),
                        ],
                      )
                    : SingleChildScrollView(
                        child: FooterViewWidget(
                            child: NoDataScreen(
                                isEmptyCart: true,
                                title: 'you_have_not_add_to_cart_yet'.tr)));
          },
        );
      }),
    );
  }

  Widget _buildTipButton({required String amount, bool isOther = false}) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isOther ? Colors.black : Colors.green,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTopButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomContainerCard(
            svgAsset: Images.rider,
            text: "Order Now",
            onTap: () {},
            boxColor: Theme.of(context).primaryColor,
            textColor: Theme.of(context).cardColor,
          ),
          CustomContainerCard(
            svgAsset: Images.pickUp,
            text: "Pick Up",
            onTap: () {},
            boxColor: Theme.of(context).cardColor,
            textColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Future<void> showReferAndEarnSnackBar() async {
    String text = 'your_referral_discount_added_on_your_first_order'.tr;
    if (Get.find<ProfileController>().userInfoModel != null &&
        Get.find<ProfileController>().userInfoModel!.isValidForDiscount!) {
      showCustomSnackBar(text, isError: false);
    }
  }
}
