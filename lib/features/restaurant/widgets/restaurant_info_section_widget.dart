import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stackfood_multivendor/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/widgets/coupon_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/customizable_space_bar_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/widgets/info_view_widget.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import '../../../common/widgets/custom_asset_image_widget.dart';
import '../../../common/widgets/custom_favourite_widget.dart';
import '../../../common/widgets/custom_snackbar_widget.dart';
import '../../../helper/price_converter.dart';
import '../../../helper/route_helper.dart';
import '../../../util/app_constants.dart';
import '../../address/domain/models/address_model.dart';
import '../../favourite/controllers/favourite_controller.dart';
import '../../splash/controllers/splash_controller.dart';

class RestaurantInfoSectionWidget extends StatelessWidget {
  final Restaurant restaurant;
  final RestaurantController restController;
  final bool hasCoupon;
  const RestaurantInfoSectionWidget({super.key, required this.restaurant, required this.restController, required this.hasCoupon});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    final double xyz = MediaQuery.of(context).size.width-1170;
    final double realSpaceNeeded = xyz/2;

    return SliverAppBar(
      expandedHeight: isDesktop ? 350 : hasCoupon ? 300 : 300,
      toolbarHeight: isDesktop ? 150 : 90,
      pinned: true, floating: false, elevation: 0.5,
      backgroundColor: Theme.of(context).cardColor,
      leadingWidth: 80,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Column(
            children: [
              GetBuilder<FavouriteController>(builder: (favouriteController) {
                bool isWished = favouriteController.wishRestIdList.contains(restaurant.id);
                return CustomFavouriteWidget(
                  isWished: isWished,
                  isRestaurant: true,
                  restaurant: restaurant,
                  size: 24  ,
                );
              }),
              SizedBox(height: 4,),

              AppConstants.webHostedUrl.isNotEmpty ? InkWell(
                onTap: (){
                  if(isDesktop) {
                    // String? hostname = html.window.location.hostname;
                    // String protocol = html.window.location.protocol;
                    // String shareUrl = '$protocol//$hostname${restController.filteringUrl(restaurant.slug ?? '')}';
                    String shareUrl = '${AppConstants.webHostedUrl}${restController.filteringUrl(restaurant.slug ?? '')}';
                    Clipboard.setData(ClipboardData(text: shareUrl));
                    showCustomSnackBar('restaurant_url_copied'.tr, isError: false);
                  } else {
                    String shareUrl = '${AppConstants.webHostedUrl}${restController.filteringUrl(restaurant.slug ?? '')}';
                    Share.share(shareUrl);
                  }
                },
                child: CustomAssetImageWidget( Images.share , height: 20, width: 20),
              ) : const SizedBox(),
            ],
          ),


        ],
      ),
      leading: !isDesktop ? IconButton(
        icon:Container(
          width: 50, // Adjust size as needed
          height: 50,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            // Rounded corners
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24,
          ),
        ),
        onPressed: () => Get.back(),
      ) : const SizedBox(),


      flexibleSpace: GetBuilder<CouponController>(
        builder: (couponController) {
          bool hasCoupons = couponController.couponList != null && couponController.couponList!.isNotEmpty;
          return Container(
            margin: isDesktop ? EdgeInsets.symmetric(horizontal: realSpaceNeeded) : EdgeInsets.zero,
            child: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              centerTitle: true,
              expandedTitleScale: isDesktop ? 1 : 1.1,
              title: CustomizableSpaceBarWidget(
                builder: (context, scrollingRate) {
                  print(scrollingRate);

                  return !isDesktop ? Container(
                    color: Theme.of(context).cardColor.withOpacity(scrollingRate),
                    padding: EdgeInsets.only(
                      bottom: 0,
                      left: Get.find<LocalizationController>().isLtr ? 40 * scrollingRate : 0,
                      right: Get.find<LocalizationController>().isLtr ? 0 : 40 * scrollingRate,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        height: (hasCoupon ? 160 : 160) - (scrollingRate * 25),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          //boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1 - (0.1 * scrollingRate)), blurRadius: 10)]
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: Dimensions.paddingSizeSmall),
                        padding: EdgeInsets.only(
                       ///   left: Get.find<LocalizationController>().isLtr ? 20 : 0,
                          right: Get.find<LocalizationController>().isLtr ? 0 : 20,
                          top: scrollingRate * (context.height * 0.035)
                        ),

                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 0),
                          child: Stack(
                                  //mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Positioned(
                                      top:  scrollingRate == 0.0  ? 30 : 10 ,
                                      left:  scrollingRate == 0.0 ? 25 : Get.find<LocalizationController>().isLtr ? 30 : 50,
                                      child: !isDesktop
                                          ? Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.transparent,
                                                    width: 2),
                                              ),
                                              padding: const EdgeInsets.all(2),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Stack(children: [
                                                  CustomImageWidget(
                                                    image:
                                                        '${restaurant.logoFullUrl}',
                                                    height: 80 -
                                                        (scrollingRate * 25),
                                                    width: 80 -
                                                        (scrollingRate * 25),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  restController
                                                          .isRestaurantOpenNow(
                                                              restaurant
                                                                  .active!,
                                                              restaurant
                                                                  .schedules)
                                                      ? const SizedBox()
                                                      : Positioned(
                                                          left: 0,
                                                          right: 0,
                                                          bottom: 0,
                                                          child: Container(
                                                            height: 30,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: const BorderRadius
                                                                  .vertical(
                                                                  bottom: Radius
                                                                      .circular(
                                                                          Dimensions
                                                                              .radiusSmall)),
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6),
                                                            ),
                                                            child: Text(
                                                              'closed_now'.tr,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: robotoRegular.copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeSmall),
                                                            ),
                                                          ),
                                                        ),
                                                ]),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ),

                                    Positioned(
                                      top: scrollingRate == 0.0  ? 80 : 20,
                                      left: 115,
                                      child: SizedBox(
                                        width: Get.width * 0.57,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                restaurant.name!,
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions.fontSizeOverLarge -
                                                        (scrollingRate * 7),
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .color),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeExtraSmall),
                                        Row(children: [
                                              Text('start_from'.tr, style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeExtraSmall , color: Theme.of(context).disabledColor,
                                              )),
                                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                              Text(
                                                PriceConverter.convertPrice(restaurant.minimumOrder), textDirection: TextDirection.ltr,
                                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * 2), color: Theme.of(context).primaryColor),
                                              ),
                                            ]),

                                            ]),
                                      ),
                                    ),

                                    Positioned(
                                      top: 135,
                                      child: Container(
                                        width: Get.width, // full width
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Row(

                                          children: [
                                            /// Delivery Time
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                decoration: BoxDecoration(
                                                 // color: Colors.red,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Image.asset("assets/image/restro_time.png", width: 20),
                                                    const SizedBox(width: 4),
                                                    Flexible(
                                                      child: Text(
                                                        restaurant.deliveryTime!,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: robotoRegular.copyWith(
                                                          fontSize: Dimensions.fontSizeDefault -
                                                              (scrollingRate *
                                                                  (isDesktop
                                                                      ? 2
                                                                      : Dimensions.fontSizeSmall)),
                                                          color: Theme.of(context).textTheme.bodyLarge!.color,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 8),

                                            /// Location
                                            Expanded(
                                              child: InkWell(
                                                onTap: () => Get.toNamed(RouteHelper.getMapRoute(
                                                  AddressModel(
                                                    id: restaurant.id,
                                                    address: restaurant.address,
                                                    latitude: restaurant.latitude,
                                                    longitude: restaurant.longitude,
                                                    contactPersonNumber: '',
                                                    contactPersonName: '',
                                                    addressType: '',
                                                  ),
                                                  'restaurant',
                                                  restaurantName: restaurant.name,
                                                )),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    // color: Colors.red,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset(Images.restLocation, width: 20),
                                                      const SizedBox(width: 4),
                                                      Flexible(
                                                        child: Text(
                                                          'location'.tr,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: robotoRegular.copyWith(
                                                            fontSize: Dimensions.fontSizeDefault -
                                                                (scrollingRate *
                                                                    (isDesktop
                                                                        ? 2
                                                                        : Dimensions.fontSizeSmall)),
                                                            color:
                                                            Theme.of(context).textTheme.bodyLarge!.color,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // const SizedBox(width: 8),

                                            /// Rating
                                            Expanded(
                                              child: InkWell(
                                                onTap: () => Get.toNamed(RouteHelper.getRestaurantReviewRoute(
                                                  restaurant.id,
                                                  restaurant.name,
                                                  restaurant,
                                                )),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    // color: Colors.red,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset("assets/image/restro-rating.png", width: 20),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        restaurant.avgRating!.toStringAsFixed(1),
                                                        style: robotoMedium.copyWith(
                                                          fontSize: Dimensions.fontSizeDefault -
                                                              (scrollingRate *
                                                                  (isDesktop
                                                                      ? 2
                                                                      : Dimensions.fontSizeSmall)),
                                                          color: Theme.of(context).textTheme.bodyLarge!.color,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                             SizedBox(width: Get.find<LocalizationController>().isLtr ?  8 : 42),
                                          ],
                                        ),
                                      ),
                                    ),




                                    // InfoViewWidget(
                                    //     restaurant: restaurant,
                                    //     restController: restController,
                                    //     scrollingRate: scrollingRate),
                                    // SizedBox(
                                    //     height: Dimensions.paddingSizeLarge -
                                    //         (scrollingRate *
                                    //             (isDesktop
                                    //                 ? 2
                                    //                 : Dimensions
                                    //                     .paddingSizeLarge))),

                                     // scrollingRate < 0.8 ? CouponViewWidget(scrollingRate: scrollingRate) : const SizedBox(),
                                  ]),
                        ),
                      ),
                    ),
                  ) : Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: restaurant.announcementActive! ? 200 : 160,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                      ),
                      margin: EdgeInsets.symmetric(horizontal: hasCoupons ? Dimensions.paddingSizeDefault : 200, vertical: Dimensions.paddingSizeSmall),
                      child: Column(
                        children: [
                          restaurant.announcementActive != null && restaurant.announcementActive! && restaurant.announcementMessage != null ? Container(
                            height: 40 - (scrollingRate * 40),
                            padding: EdgeInsets.only(
                              left: Get.find<LocalizationController>().isLtr ? 250 : 20,
                              right: Get.find<LocalizationController>().isLtr ? 20 : 250,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                            ),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Image.asset(Images.announcement, height: 26, width: 26),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Flexible(
                                child: Marquee(
                                  text: restaurant.announcementMessage!,
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                                  blankSpace: 20.0,
                                  velocity: 100.0,
                                  accelerationDuration: const Duration(seconds: 5),
                                  decelerationDuration: const Duration(milliseconds: 500),
                                  accelerationCurve: Curves.linear,
                                  decelerationCurve: Curves.easeOut,
                                ),
                              ),
                            ]),
                          ) : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Row(children: [

                                  SizedBox(width: 250 /*(context.width * 0.17)*/ - (scrollingRate * 90)),

                                  Expanded(child: InfoViewWidget(restaurant: restaurant, restController: restController, scrollingRate: scrollingRate)),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  hasCoupons ? Expanded(child: CouponViewWidget(scrollingRate: scrollingRate)) : const SizedBox(),

                                ]),

                                Positioned(left: Get.find<LocalizationController>().isLtr ? 30 : null, right: Get.find<LocalizationController>().isLtr ? null : 30, top: - 80 + (scrollingRate * 77), child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).cardColor,
                                    border: Border.all(color: Theme.of(context).primaryColor, width: 0.2),
                                    boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.3), blurRadius: 10)]
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(500),
                                    child: Stack(children: [
                                      CustomImageWidget(
                                        image: '${restaurant.logoFullUrl}',
                                        height: 200 - (scrollingRate * 90), width: 200 - (scrollingRate * 90), fit: BoxFit.cover,
                                        isRestaurant: true,
                                      ),
                                      restController.isRestaurantOpenNow(restaurant.active!, restaurant.schedules) ? const SizedBox() : Positioned(
                                        left: 0, right: 0, bottom: 0,
                                        child: Container(
                                          height: 30,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusSmall)),
                                            color: Colors.black.withOpacity(0.6),
                                          ),
                                          child: Text(
                                            'closed_now'.tr, textAlign: TextAlign.center,
                                            style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              background: Container(
                margin: EdgeInsets.only(bottom: isDesktop ? 100 : (hasCoupon ? 100 : 100)),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusLarge)),
                  child: CustomImageWidget(
                    height: 100,
                    fit: BoxFit.cover, placeholder: Images.restaurantCover,
                    image: '${restaurant.coverPhotoFullUrl}',
                    isRestaurant: true,
                  ),
                ),
              ),
            ),
          );
        }
      ),
      actions: const [SizedBox()],
    );
  }
}