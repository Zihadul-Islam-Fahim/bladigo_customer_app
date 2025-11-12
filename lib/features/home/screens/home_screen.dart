import 'package:flutter/rendering.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/features/home/controllers/advertisement_controller.dart';
import 'package:stackfood_multivendor/features/home/widgets/cashback_dialog_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/cashback_logo_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/highlight_widget_view.dart';
import 'package:stackfood_multivendor/features/home/widgets/home/home_screen_header.dart';
import 'package:stackfood_multivendor/features/home/widgets/refer_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/features/product/controllers/campaign_controller.dart';
import 'package:stackfood_multivendor/features/home/controllers/home_controller.dart';
import 'package:stackfood_multivendor/features/home/screens/web_home_screen.dart';
import 'package:stackfood_multivendor/features/home/widgets/all_restaurant_filter_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/all_restaurants_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/bad_weather_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/banner_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/best_review_item_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/cuisine_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/enjoy_off_banner_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/order_again_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/popular_foods_nearby_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/popular_restaurants_view_widget.dart';
import 'package:stackfood_multivendor/features/home/screens/theme1_home_screen.dart';
import 'package:stackfood_multivendor/features/home/widgets/today_trends_view_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/notification/controllers/notification_controller.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/common/widgets/customizable_space_bar_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/features/address/controllers/address_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/cuisine/controllers/cuisine_controller.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/product/controllers/product_controller.dart';
import 'package:stackfood_multivendor/features/review/controllers/review_controller.dart';
import 'package:stackfood_multivendor/features/wallet/widgets/wallet_card_widget.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/auth_helper.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../splash/controllers/theme_controller.dart';
import '../widgets/services_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Future<void> loadData(bool reload) async {
    Get.find<HomeController>().getBannerList(reload);
    Get.find<CategoryController>().getCategoryList(reload);
    Get.find<CuisineController>().getCuisineList();
    Get.find<AdvertisementController>().getAdvertisementList();
    if (Get.find<SplashController>().configModel!.popularRestaurant == 1) {
      Get.find<RestaurantController>()
          .getPopularRestaurantList(reload, 'all', false);
    }
    Get.find<CampaignController>().getItemCampaignList(reload);
    if (Get.find<SplashController>().configModel!.popularFood == 1) {
      Get.find<ProductController>().getPopularProductList(reload, 'all', false);
    }
    if (Get.find<SplashController>().configModel!.newRestaurant == 1) {
      Get.find<RestaurantController>()
          .getLatestRestaurantList(reload, 'all', false);
    }
    if (Get.find<SplashController>().configModel!.mostReviewedFoods == 1) {
      Get.find<ReviewController>().getReviewedProductList(reload, 'all', false);
    }
    Get.find<RestaurantController>().getRestaurantList(1, reload);
    if (Get.find<AuthController>().isLoggedIn()) {
      await Get.find<ProfileController>().getUserInfo();
      Get.find<RestaurantController>()
          .getRecentlyViewedRestaurantList(reload, 'all', false);
      Get.find<RestaurantController>().getOrderAgainRestaurantList(reload);
      Get.find<NotificationController>().getNotificationList(reload);
      Get.find<OrderController>().getRunningOrders(1, notify: false);
      Get.find<AddressController>().getAddressList();
      Get.find<HomeController>().getCashBackOfferList();
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final ConfigModel? _configModel = Get.find<SplashController>().configModel;
  bool _isLogin = false;

  @override
  void initState() {
    super.initState();

    _isLogin = Get.find<AuthController>().isLoggedIn();
    HomeScreen.loadData(false).then((value) {
      Get.find<SplashController>().getReferBottomSheetStatus();

      if ((Get.find<ProfileController>().userInfoModel?.isValidForDiscount ??
              false) &&
          Get.find<SplashController>().showReferBottomSheet) {
        Future.delayed(
            const Duration(milliseconds: 500), () => _showReferBottomSheet());
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (Get.find<HomeController>().showFavButton) {
          Get.find<HomeController>().changeFavVisibility();
          Future.delayed(const Duration(milliseconds: 800),
              () => Get.find<HomeController>().changeFavVisibility());
        }
      } else {
        if (Get.find<HomeController>().showFavButton) {
          Get.find<HomeController>().changeFavVisibility();
          Future.delayed(const Duration(milliseconds: 800),
              () => Get.find<HomeController>().changeFavVisibility());
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showReferBottomSheet() {
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
                child: const ReferBottomSheetWidget(),
              );
            },
          ).then((value) =>
            Get.find<SplashController>().saveReferBottomSheetStatus(false));
  }

  @override
  Widget build(BuildContext context) {
    double scrollPoint = 0.0;

    return GetBuilder<HomeController>(builder: (homeController) {
      return GetBuilder<LocalizationController>(
          builder: (localizationController) {
        return Scaffold(

          endDrawer: const MenuDrawerWidget(),
          endDrawerEnableOpenDragGesture: false,
          backgroundColor: Theme.of(context).cardColor,
          body: SafeArea(
            top: (Get.find<SplashController>().configModel!.theme == 2),
            child: RefreshIndicator(
                onRefresh: () async {
                  await Get.find<HomeController>().getBannerList(true);
                  await Get.find<CategoryController>().getCategoryList(true);
                  await Get.find<CuisineController>().getCuisineList();
                  Get.find<AdvertisementController>().getAdvertisementList();
                  await Get.find<RestaurantController>()
                      .getPopularRestaurantList(true, 'all', false);
                  await Get.find<CampaignController>()
                      .getItemCampaignList(true);
                  await Get.find<ProductController>()
                      .getPopularProductList(true, 'all', false);
                  await Get.find<RestaurantController>()
                      .getLatestRestaurantList(true, 'all', false);
                  await Get.find<ReviewController>()
                      .getReviewedProductList(true, 'all', false);
                  await Get.find<RestaurantController>()
                      .getRestaurantList(1, true);
                  if (Get.find<AuthController>().isLoggedIn()) {
                    await Get.find<ProfileController>().getUserInfo();
                    await Get.find<NotificationController>()
                        .getNotificationList(true);
                    await Get.find<RestaurantController>()
                        .getRecentlyViewedRestaurantList(true, 'all', false);
                    await Get.find<RestaurantController>()
                        .getOrderAgainRestaurantList(true);
                  }
                },
                child:  (Get.find<SplashController>().configModel!.theme == 2)
                        ? Theme1HomeScreen(
                            scrollController: _scrollController,
                          )
                        : SingleChildScrollView(child: _mainContents(context))
                // : _buildCustomScrollView(context, scrollPoint),
                ),
          ),
          floatingActionButton: AuthHelper.isLoggedIn() &&
                  homeController.cashBackOfferList != null &&
                  homeController.cashBackOfferList!.isNotEmpty
              ? homeController.showFavButton
                  ? Padding(
                      padding: EdgeInsets.only(
                          bottom:  0,
                          right:  0),
                      child: InkWell(
                        onTap: () => Get.dialog(const CashBackDialogWidget()),
                        child: const CashBackLogoWidget(),
                      ),
                    )
                  : null
              : null,
        );
      });
    });
  }

  CustomScrollView _buildCustomScrollView(
      BuildContext context, double scrollPoint) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        /// App Bar
        SliverAppBar(
          pinned: true,
          toolbarHeight: 10,
          expandedHeight: ResponsiveHelper.isTab(context)
              ? 72
              : GetPlatform.isWeb
                  ? 72
                  : 194,
          floating: false,
          elevation: 0,
          /*automaticallyImplyLeading: false,*/
          backgroundColor:  Theme.of(context).primaryColor,
          flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              centerTitle: true,
              expandedTitleScale: 1,
              title: CustomizableSpaceBarWidget(
                builder: (context, scrollingRate) {
                  scrollPoint = scrollingRate;
                  return Center(
                      child: Container(
                    width: Dimensions.webMaxWidth,
                    color: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.only(top: 30),
                    child: Opacity(
                      opacity: 1 - scrollPoint,
                      child: Row(children: [
                        Expanded(
                            child: Transform.translate(
                          offset: Offset(0, -(scrollingRate * 20)),
                          child: InkWell(
                            onTap: () => Get.toNamed(
                                RouteHelper.getAccessLocationRoute('home')),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall),
                              child: GetBuilder<LocationController>(
                                  builder: (locationController) {
                                return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (scrollingRate < 0.2)
                                        Row(children: [
                                          AuthHelper.isLoggedIn()
                                              ? Icon(
                                                  AddressHelper.getAddressFromSharedPref()!
                                                              .addressType ==
                                                          'home'
                                                      ? Icons.home_filled
                                                      : AddressHelper.getAddressFromSharedPref()!
                                                                  .addressType ==
                                                              'office'
                                                          ? Icons.work
                                                          : Icons.location_on,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Icon(
                                                      Icons.location_on,
                                                      size: 24,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                          const SizedBox(
                                              width: Dimensions
                                                  .paddingSizeExtraSmall),
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
                                              color:
                                                  Theme.of(context).cardColor,
                                              fontSize: Dimensions
                                                  .fontSizeDefault /* - (scrollingRate * Dimensions.fontSizeDefault)*/,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ]),
                                      SizedBox(
                                          height:
                                              (scrollingRate < 0.15) ? 5 : 0),
                                      if (scrollingRate < 0.8)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Row(
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
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    fontSize: Dimensions
                                                        .fontSizeSmall /* - (scrollingRate * Dimensions.fontSizeSmall)*/,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color:
                                                    Theme.of(context).cardColor,
                                                size:
                                                    16 /*- (scrollingRate * 16)*/,
                                              ),
                                            ],
                                          ),
                                        ),
                                    ]);
                              }),
                            ),
                          ),
                        )),
                        Transform.translate(
                          offset: Offset(0, -(scrollingRate * 10)),
                          child: InkWell(
                            child: GetBuilder<NotificationController>(
                                builder: (notificationController) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .cardColor
                                      .withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeExtraSmall),
                                child: Stack(children: [
                                  Transform.translate(
                                    offset: Offset(0, -(scrollingRate * 10)),
                                    child: Icon(Icons.notifications_outlined,
                                        size: 25, color: Colors.grey),
                                  ),
                                  notificationController.hasNotification
                                      ? Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .cardColor),
                                            ),
                                          ))
                                      : const SizedBox(),
                                ]),
                              );
                            }),
                            onTap: () =>
                                Get.toNamed(RouteHelper.getNotificationRoute()),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                      ]),
                    ),
                  ));
                },
              )),
          actions: const [SizedBox()],
        ),

        // Search Button
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverDelegate(
              height: 65,
              child: Center(
                  child: Stack(
                children: [
                  Container(
                    transform: Matrix4.translationValues(0, -1, 0),
                    height: 65,
                    width: Dimensions.webMaxWidth,
                    color: Colors.transparent,
                    // color: Theme.of(context)
                    //     .colorScheme
                    //     .surface,
                    child: Column(children: [
                      Expanded(
                          child:
                              Container(color: Theme.of(context).primaryColor)),
                      Expanded(child: Container(color: Colors.transparent)),
                    ]),
                  ),
                  // _searchBar(context)
                ],
              ))),
        ),

        SliverToBoxAdapter(
          child: _mainContents(context),
        ),

        SliverPersistentHeader(
          pinned: true,
          delegate: SliverDelegate(
            height: 85,
            child: const AllRestaurantFilterWidget(),
          ),
        ),

        SliverToBoxAdapter(
          child: Center(
            child: FooterViewWidget(
              child: Padding(
                padding:  const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeOverLarge),
                child:
                    AllRestaurantsWidget(scrollController: _scrollController),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _mainContents(BuildContext context) {
    final tooltipController = JustTheController();
    return Center(
        child: SizedBox(
      width: Dimensions.webMaxWidth,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        HomeScreenHeaderWidget(
          isSecondScreen: false,
        ),
        SizedBox(
          height: 16,
        ),
        _searchBar(context),
        const BannerViewWidget(),
        _isLogin ?  WalletSection(tooltipController, context) : const SizedBox(),
        ServicesSection(),
        // const WhatOnYourMindViewWidget(),
        _configModel!.popularFood == 1
            ? const PopularFoodNearbyViewWidget()
            : const SizedBox(),
        _configModel.popularRestaurant == 1
            ? const PopularRestaurantsViewWidget()
            : const SizedBox(),
        const BadWeatherWidget(),
        const TodayTrendsViewWidget(),
      //  const LocationBannerViewWidget(),
        const HighlightWidgetView(),
        _isLogin ? const OrderAgainViewWidget() : const SizedBox(),
        _configModel.mostReviewedFoods == 1
            ? const BestReviewItemViewWidget(isPopular: false)
            : const SizedBox(),
        const CuisineViewWidget(),
        // _configModel.popularRestaurant == 1
        //     ? const PopularRestaurantsViewWidget()
        //     : const SizedBox(),
        // const ReferBannerViewWidget(),
        _isLogin
            ? const PopularRestaurantsViewWidget(isRecentlyViewed: true)
            : const SizedBox(),
        // _configModel.popularFood == 1
        //     ? const PopularFoodNearbyViewWidget()
        //     : const SizedBox(),
        // _configModel.newRestaurant == 1
        //     ? const NewOnStackFoodViewWidget(isLatest: true)
        //     : const SizedBox(),
        const PromotionalBannerViewWidget(),
      ]),
    ));
  }

  Widget WalletSection(JustTheController tooltipController, BuildContext context) {
    return Get.find<AuthController>().isLoggedIn() ? Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 55,
              child: WalletCardWidget(tooltipController: tooltipController),
          ),
          // SizedBox(width: 10,),
          Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 ? 
          Expanded(
            flex: 25,
            child: GetBuilder<ProfileController>(
                        builder: (profileController) {
            return Container(
              height: 70,
              margin: EdgeInsets.only(top:  Dimensions.paddingSizeExtraSmall,left: 4),
              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                // image: DecorationImage(image: AssetImage(Images.homeWallet),fit: BoxFit.scaleDown,),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.grey.shade200),
            
                color: Get.find<ThemeController>().darkTheme ? Colors.white60 : Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(Images.loyal,width: 32,height: 32,),
                  SizedBox(width: 5,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('loyalty_points'.tr,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black),overflow: TextOverflow.ellipsis,),
                      Text(profileController.userInfoModel?.loyaltyPoint != null ? profileController.userInfoModel!.loyaltyPoint.toString() : '0',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge1, color: Colors.black,fontWeight: FontWeight.bold),
                      )
                    ],
             )
          ],
       ),
     );
   }),
     ) : const SizedBox(),
          SizedBox(width: 12,)
          // Expanded(flex: 12,
          //   child: Container(
          //     height: 70,
          //     child: Center(
          //       child: InkWell(
          //         onTap: () => Get.toNamed(RouteHelper.getCategoryRoute()),
          //         child: Text("see_all".tr,style: TextStyle(color: Theme.of(context).primaryColor),),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ) : SizedBox.shrink();
  }

  Widget _searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: InkWell(
        onTap: () => Get.toNamed(RouteHelper.getSearchRoute()),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                transform: Matrix4.translationValues(0, -3, 0),
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                 // border: Border.all(color: Theme.of(context).primaryColor,)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 2, right: 2, top: 16, bottom: 16),
                  child: Row(children: [
                    Image.asset(Images.searchIconNew, width: 16, height: 16),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Expanded(
                        child: Text("What_you_like_to".tr,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold
                            ),
                        ),
                    ),
                  ]),
                ),
              ),
            ),
            // SizedBox(
            //   width: 12,
            // ),
            // Expanded(
            //   flex: 1,
            //   child: Container(
            //       transform: Matrix4.translationValues(0, -3, 0),
            //       padding: const EdgeInsets.symmetric(
            //           horizontal: Dimensions.paddingSizeSmall),
            //       decoration: BoxDecoration(
            //         color: Colors.grey.withOpacity(0.18),
            //         borderRadius: BorderRadius.circular(8),
            //         border: Border.all(color: Theme.of(context).primaryColor)
            //       ),
            //       child: Padding(
            //         padding: const EdgeInsets.only(
            //             left: 2, right: 2, top: 16, bottom: 16),
            //         child:
            //             Image.asset(Images.filterIcon, width: 16, height: 16),
            //       )),
            // )
          ],
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;

  SliverDelegate({required this.child, this.height = 50});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height ||
        oldDelegate.minExtent != height ||
        child != oldDelegate.child;
  }
}
