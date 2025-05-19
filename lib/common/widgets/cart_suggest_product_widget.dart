import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_favourite_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/common/widgets/not_available_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/home/widgets/overflow_container_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/features/product/controllers/product_controller.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/discount_tag_widget.dart';
import 'package:stackfood_multivendor/common/widgets/discount_tag_without_image_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartSuggestProductWidget extends StatelessWidget {
  final Product? product;
  final Restaurant? restaurant;
  final bool isRestaurant;
  final int index;
  final int? length;
  final bool inRestaurant;
  final bool isCampaign;
  final bool fromCartSuggestion;

  const CartSuggestProductWidget(
      {super.key,
        required this.product,
        required this.isRestaurant,
        required this.restaurant,
        required this.index,
        required this.length,
        this.inRestaurant = false,
        this.isCampaign = false,
        this.fromCartSuggestion = false});

  @override
  Widget build(BuildContext context) {
    bool desktop = ResponsiveHelper.isDesktop(context);
    double? discount;
    String? discountType;
    bool isAvailable;
    String? image;
    double price = 0;
    double discountPrice = 0;
    if (isRestaurant) {
      image = restaurant!.logoFullUrl;
      discount =
      restaurant!.discount != null ? restaurant!.discount!.discount : 0;
      discountType = restaurant!.discount != null
          ? restaurant!.discount!.discountType
          : 'percent';
      isAvailable = restaurant!.open == 1 && restaurant!.active!;
    } else {
      image = product!.imageFullUrl;
      discount = (product!.restaurantDiscount == 0 || isCampaign)
          ? product!.discount
          : product!.restaurantDiscount;
      discountType = (product!.restaurantDiscount == 0 || isCampaign)
          ? product!.discountType
          : 'percent';
      isAvailable = DateConverter.isAvailable(
          product!.availableTimeStarts, product!.availableTimeEnds);
      price = product!.price!;
      discountPrice =
      PriceConverter.convertWithDiscount(price, discount, discountType)!;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        // horizontal: desktop ? 0 : Dimensions.paddingSizeExtraSmall,
        //vertical: desktop ? 0 : Dimensions.paddingSizeExtraSmall
      ),
      child: Container(
        margin: desktop ? null : const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          // color: Theme.of(context).cardColor,
          //color: Colors.red,
          // boxShadow: [
          // BoxShadow(
          //     color: Colors.grey.withOpacity(0.1),
          //     spreadRadius: 1,
          //     blurRadius: 10,
          //     offset: const Offset(0, 1))
          // ],
        ),
        child: CustomInkWellWidget(
          onTap: () {
            if (isRestaurant) {
              if (restaurant != null && restaurant!.restaurantStatus == 1) {
                Get.toNamed(RouteHelper.getRestaurantRoute(restaurant!.id),
                    arguments: RestaurantScreen(restaurant: restaurant));
              } else if (restaurant!.restaurantStatus == 0) {
                showCustomSnackBar('restaurant_is_not_available'.tr);
              }
            } else {
              if (product!.restaurantStatus == 1) {
                ResponsiveHelper.isMobile(context)
                    ? Get.to(
                  ProductBottomSheetWidget(
                      product: product,
                      inRestaurantPage: inRestaurant,
                      isCampaign: isCampaign),
                  // backgroundColor: Colors.transparent,
                  //isScrollControlled: true,
                )
                    : Get.dialog(
                  Dialog(
                      child: ProductBottomSheetWidget(
                          product: product,
                          inRestaurantPage: inRestaurant)),
                );
              } else {
                showCustomSnackBar('item_is_not_available'.tr);
              }
            }
          },
          radius: Dimensions.radiusDefault,
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Card(
              color: Colors.transparent,
              elevation: 0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(clipBehavior: Clip.none, children: [
                      ((image != null && image.isNotEmpty) || isRestaurant)
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                            Dimensions.radiusDefault),
                        child: CustomImageWidget(
                          image:
                          '${isRestaurant ? restaurant!.logoFullUrl : product!.imageFullUrl}',
                          height: desktop
                              ? 120
                              : length == null
                              ? 100
                              : 150,
                          width: desktop ? 120 : 140,
                          fit: BoxFit.cover,
                          isFood: !isRestaurant,
                          isRestaurant: isRestaurant,
                        ),
                      )
                          : isAvailable
                          ? const SizedBox()
                          : Container(
                        height: desktop
                            ? 120
                            : length == null
                            ? 100
                            : 110,
                        width: desktop ? 120 : 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              Dimensions.radiusDefault),
                        ),
                      ),
                      ((image != null && image.isNotEmpty) || isRestaurant)
                          ? DiscountTagWidget(
                        discount: discount,
                        discountType: discountType,
                        freeDelivery: isRestaurant
                            ? restaurant!.freeDelivery
                            : false,
                        fromTop: Dimensions.paddingSizeExtraSmall,
                        fromLeft: isAvailable ? -7 : -3,
                        paddingVertical:
                        ResponsiveHelper.isDesktop(context) ? 5 : 10,
                      )
                          : const SizedBox(),
                      isAvailable
                          ? const SizedBox()
                          : NotAvailableWidget(
                        isRestaurant: isRestaurant,
                        opacity: ((image != null && image.isNotEmpty) ||
                            isRestaurant)
                            ? 0.6
                            : 0.15,
                        color: ((image != null && image.isNotEmpty) ||
                            isRestaurant)
                            ? Colors.white
                            : Colors.black,
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(width: Dimensions.paddingSizeExtraLarge),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Text(
                              isRestaurant ? restaurant!.name! : product!.name!,
                              style: robotoMedium.copyWith(
                                  fontFamily: 'Roboto',
                                fontSize: Dimensions.fontSizeLarge
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          isRestaurant
                              ? Row(
                            children: [
                              Text(
                                'start_from'.tr,
                                style: robotoRegular.copyWith(
                                    fontSize:
                                    Dimensions.fontSizeExtraSmall,
                                    color:
                                    Theme.of(context).disabledColor),
                              ),
                              const SizedBox(
                                  width:
                                  Dimensions.paddingSizeExtraSmall),
                              Text(
                                PriceConverter.convertPrice(
                                    restaurant!.minimumOrder!),
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color),
                              ),
                            ],
                          )
                              : Wrap(children: [
                            discount! > 0
                                ? Text(
                              PriceConverter.convertPrice(
                                  product!.price),
                              textDirection: TextDirection.ltr,
                              style: robotoMedium.copyWith(
                                fontSize:
                                Dimensions.fontSizeSmall,
                                color:
                                Theme.of(context).disabledColor,
                                decoration:
                                TextDecoration.lineThrough,
                              ),
                            )
                                : const SizedBox(),
                            SizedBox(
                                width: discount > 0
                                    ? Dimensions.paddingSizeExtraSmall
                                    : 0),
                            Text(
                              PriceConverter.convertPrice(product!.price,
                                  discount: discount,
                                  discountType: discountType),
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Colors.black),
                              textDirection: TextDirection.ltr,
                            ),
                            const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall),
                            (image != null && image.isNotEmpty)
                                ? const SizedBox.shrink()
                                : DiscountTagWithoutImageWidget(
                                discount: discount,
                                discountType: discountType,
                                freeDelivery: isRestaurant
                                    ? restaurant!.freeDelivery
                                    : false),
                          ]),

                        ],
                      ),
                    ),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }
}
