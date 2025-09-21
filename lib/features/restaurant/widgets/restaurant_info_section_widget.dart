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

    final double xyz = MediaQuery.of(context).size.width-1170;
    final double realSpaceNeeded = xyz/2;

    return SliverAppBar(
      expandedHeight:  hasCoupon ? 300 : 300,
      toolbarHeight:  90,
      pinned: true, floating: false, elevation: 0.5,
      backgroundColor: Theme.of(context).cardColor,
      leadingWidth: 80,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Row(
            children: [
              GetBuilder<FavouriteController>(builder: (favouriteController) {
                bool isWished = favouriteController.wishRestIdList.contains(restaurant.id);
                return Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white),
                  child: CustomFavouriteWidget(
                    isWished: isWished,
                    isRestaurant: true,
                    restaurant: restaurant,
                    size: 20,
                  ),
                );
              }),
              SizedBox(width: 10,),

              AppConstants.webHostedUrl.isNotEmpty ? Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white),
                child: InkWell(
                  onTap: (){

                      String shareUrl = '${AppConstants.webHostedUrl}${restController.filteringUrl(restaurant.slug ?? '')}';
                      Share.share(shareUrl);

                  },
                  child: CustomAssetImageWidget( Images.share , height: 20, width: 20),
                ),
              ) : const SizedBox(),
            ],
          ),


        ],
      ),
      leading:  IconButton(
        icon:Container(
          // width: 20, // Adjust size as needed
          // height: 20,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            // Rounded corners
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
        ),
        onPressed: () => Get.back(),
      ) ,


      flexibleSpace: GetBuilder<CouponController>(
        builder: (couponController) {
          bool hasCoupons = couponController.couponList != null && couponController.couponList!.isNotEmpty;
          return Container(
            margin:  EdgeInsets.zero,
            child: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              centerTitle: true,
              expandedTitleScale: 1.1,
              title: CustomizableSpaceBarWidget(
                builder: (context, scrollingRate) {
                  return  Container(
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
                                      child:Container(
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
                                                    fontSize: 21 -
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
                                                                  ( Dimensions.fontSizeSmall)),
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
                                                                    (Dimensions.fontSizeSmall)),
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
                                                                  ( Dimensions.fontSizeSmall)),
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
                  ) ;
                },
              ),
              background: Container(
                margin: EdgeInsets.only(bottom:  (hasCoupon ? 100 : 100)),
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