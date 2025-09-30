import 'dart:developer';

import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/item_card_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/widgets/restaurant_description_view_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/widgets/restaurant_info_section_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/widgets/restaurant_screen_shimmer_widget.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/bottom_cart_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/paginated_list_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/veg_filter_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/product_shimmer_widget.dart';
import '../widgets/coupon_view_widget.dart';

class RestaurantScreen extends StatefulWidget {
  final Restaurant? restaurant;
  final String slug;
  const RestaurantScreen({super.key, required this.restaurant, this.slug = ''});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _initDataCall();
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  Future<void> _initDataCall() async {

// WidgetsBinding.instance.addPostFrameCallback((_) async
//     {



      if (Get.find<RestaurantController>().isSearching) {
        Get.find<RestaurantController>().changeSearchStatus(isUpdate: false);
      }
       await Get.find<RestaurantController>()
          .getRestaurantDetails(widget.restaurant!, slug: widget.slug);
      if (Get.find<CategoryController>().categoryList == null) {
        Get.find<CategoryController>().getCategoryList(true);
      }
      if (Get.find<CategoryController>().subCategoryList == null) {
        Get.find<CategoryController>()
            .getSubCategoryList(widget.restaurant?.categoryId.toString());
      }
      Get.find<CouponController>().getRestaurantCouponList(
          restaurantId: widget.restaurant!.id ??
              Get.find<RestaurantController>().restaurant!.id!);
      Get.find<RestaurantController>().getRestaurantRecommendedItemList(
          widget.restaurant!.id ??
              Get.find<RestaurantController>().restaurant!.id!,
          false);


      Get.find<RestaurantController>().getRestaurantProductList(
          widget.restaurant!.id ??
              Get.find<RestaurantController>().restaurant!.id!,
          1,
          'all',
          false);

      // Get.find<RestaurantController>().setSubCategoryList(Get.find<RestaurantController>().restaurant!.categoryId!);
      // Get.find<CategoryController>().getSubCategoryList(Get.find<RestaurantController>().restaurant!.categoryId.toString());
    // });
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(

        endDrawer: const MenuDrawerWidget(),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: Theme.of(context).cardColor,
        body: GetBuilder<RestaurantController>(builder: (restController) {
          return GetBuilder<CouponController>(builder: (couponController) {
            return GetBuilder<CategoryController>(
                builder: (categoryController) {
              Restaurant? restaurant;
              if (restController.restaurant != null &&
                  restController.restaurant!.name != null &&
                  categoryController.categoryList != null) {
                restaurant = restController.restaurant;
              }


              // restController.setCategoryList();

          restController.setSubCategoryList(widget.restaurant!.categoryId!);



              bool hasCoupon = (couponController.couponList != null &&
                  couponController.couponList!.isNotEmpty);

              return ( restController.isLoading==false
                  // restController.restaurant != null &&
                  //     restController.restaurant!.name != null &&
                  //     categoryController.categoryList != null
              )
                  ? CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      slivers: [

                        RestaurantInfoSectionWidget(
                            restaurant: restaurant!,
                            restController: restController,
                            hasCoupon: hasCoupon),

                      // hasCoupon ?   CouponViewWidget(scrollingRate: 1) : const SizedBox(),
                        SliverToBoxAdapter(
                          child: hasCoupon
                              ? CouponViewWidget(scrollingRate: 0)
                              : const SizedBox(),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 4,)),

                        SliverToBoxAdapter(

                          child:  Row(
                                children: [
                                  const SizedBox(
                                      width: Dimensions.paddingSizeSmall),
                                  Expanded(
                                    child: TextField(

                                      controller: _searchController,
                                      textInputAction:
                                          TextInputAction.search,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 14),

                                        hintText: 'search_for_products'.tr,
                                        hintStyle: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            color: Theme.of(context)
                                                .disabledColor),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(Dimensions.radiusXExtraLarge),
                                            borderSide : BorderSide(color: Colors.transparent),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(Dimensions.radiusXExtraLarge),
                                            borderSide : BorderSide(color: Colors.transparent)),

                                       filled: true,
                                        fillColor: Colors.grey.withOpacity(0.08),
                                        isDense: true,
                                        prefixIcon: InkWell(
                                          onTap: () {
                                            if (!restController.isSearching) {
                                              Get.find<RestaurantController>().getRestaurantSearchProductList(
                                                _searchController.text.trim(),
                                                Get.find<RestaurantController>().restaurant!.id.toString(), 1, restController.type,
                                              );
                                            } else {
                                              _searchController.text = '';
                                              restController.initSearchData();
                                              restController.changeSearchStatus();
                                            }
                                          },
                                          child: Icon(
                                              restController.isSearching
                                                  ? Icons.clear
                                                  : CupertinoIcons.search,
                                              color: Theme.of(context).primaryColor.withOpacity(0.70),
                                          size: 20,),
                                        ),
                                      ),

                                      onSubmitted: (String? value) {
                                        if (value!.isNotEmpty) {
                                          restController
                                              .getRestaurantSearchProductList(
                                            _searchController.text.trim(),
                                            Get.find<RestaurantController>().restaurant!.id.toString(), 1, restController.type,
                                          );
                                        }
                                      },
                                      onChanged: (String? value) {
                                        if (value!.isNotEmpty) {
                                          restController.getRestaurantSearchProductList(
                                            _searchController.text.trim(),
                                            Get.find<RestaurantController>().restaurant!.id.toString(), 1, restController.type,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),
                                ],
                              )

                        ),

                        SliverToBoxAdapter(
                          child: Center(
                            child: Container(
                              width: Dimensions.webMaxWidth,
                              color: Theme.of(context).cardColor,
                              child: Column(children: [
                                // isDesktop
                                //     ? const SizedBox()
                                //     : RestaurantDescriptionViewWidget(
                                //         restaurant: restaurant),
                                restaurant.discount != null
                                    ? Container(
                                        width: context.width,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: Dimensions.paddingSizeSmall,
                                            horizontal: Dimensions.paddingSizeLarge),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                            color: Theme.of(context).primaryColor),
                                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                restaurant.discount!.discountType == 'percent'
                                                    ? '${restaurant.discount!.discount}% ${'off'.tr}'
                                                    : '${PriceConverter.convertPrice(restaurant.discount!.discount)} ${'off'.tr}',
                                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor),
                                              ),
                                              Text(
                                                restaurant.discount!.discountType == 'percent'
                                                    ? '${'enjoy'.tr} ${restaurant.discount!.discount}% ${'off_on_all_categories'.tr}'
                                                    : '${'enjoy'.tr} ${PriceConverter.convertPrice(restaurant.discount!.discount)}'
                                                        ' ${'off_on_all_categories'.tr}',
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions.fontSizeSmall,
                                                    color: Theme.of(context).cardColor),
                                              ),
                                              SizedBox(
                                                  height: (restaurant.discount!.minPurchase != 0 || restaurant.discount!.maxDiscount != 0)
                                                      ? 5
                                                      : 0),
                                              restaurant.discount!.minPurchase != 0
                                                  ? Text(
                                                      '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.minPurchase)} ]',
                                                      style: robotoRegular.copyWith(
                                                          fontSize: Dimensions.fontSizeExtraSmall,
                                                          color: Theme.of(context).cardColor),
                                                    )
                                                  : const SizedBox(),
                                              restaurant.discount!.maxDiscount !=
                                                      0
                                                  ? Text(
                                                      '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.maxDiscount)} ]',
                                                      style: robotoRegular.copyWith(
                                                          fontSize: Dimensions.fontSizeExtraSmall,
                                                          color: Theme.of(context).cardColor),
                                                    )
                                                  : const SizedBox(),
                                              Text(
                                                '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(restaurant.discount!.startTime!)} '
                                                '- ${DateConverter.convertTimeToTime(restaurant.discount!.endTime!)} ]',
                                                style: robotoRegular.copyWith(
                                                    fontSize: Dimensions.fontSizeExtraSmall,
                                                    color: Theme.of(context).cardColor),
                                              ),
                                            ]),
                                      )
                                    : const SizedBox(),
                                SizedBox(
                                    height: (restaurant.announcementActive! &&
                                            restaurant.announcementMessage !=
                                                null)
                                        ? 0
                                        : Dimensions.paddingSizeSmall),
                                ResponsiveHelper.isMobile(context)
                                    ? (restaurant.announcementActive! &&
                                            restaurant.announcementMessage !=
                                                null)
                                        ? Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.green),

                                            padding: const EdgeInsets.symmetric(
                                                vertical:
                                                    Dimensions.paddingSizeSmall,
                                                horizontal: Dimensions
                                                    .paddingSizeLarge),
                                            margin: const EdgeInsets.only(
                                                bottom: Dimensions.paddingSizeSmall,top: Dimensions.paddingSizeSmall
                                            ),
                                            child: Row(children: [
                                              Image.asset(Images.announcement,
                                                  height: 26, width: 26),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeSmall),
                                              Flexible(
                                                  child: Text(
                                                restaurant
                                                        .announcementMessage ??
                                                    '',
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall,
                                                    color: Theme.of(context)
                                                        .cardColor),
                                              )),
                                            ]),
                                          )
                                        : const SizedBox()
                                    : const SizedBox(),
                                restController.recommendedProductModel !=
                                            null &&
                                        restController.recommendedProductModel!
                                            .products!.isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: Dimensions
                                                  .paddingSizeSmall,
                                              left: Dimensions
                                                  .paddingSizeLarge,
                                              bottom: Dimensions
                                                  .paddingSizeExtraSmall,
                                              right: Dimensions
                                                  .paddingSizeLarge,
                                            ),
                                            child: Row(children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    Text(
                                                        'recommend_for_you'.tr,
                                                        style: robotoMedium.copyWith(fontSize: 20, fontWeight: FontWeight.w700)),
                                                    const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    Text('here_is_what_you_might_like_to_test'.tr,
                                                        style: robotoRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeDefault,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor)),
                                                  ],
                                                ),
                                              ),
                                              ArrowIconButtonWidget(
                                                onTap: () => Get.toNamed(
                                                    RouteHelper.getPopularFoodRoute(
                                                        false,
                                                        fromIsRestaurantFood: true,
                                                        restaurantId: widget.restaurant!.id ?? Get.find<RestaurantController>().restaurant!.id!)),
                                              ),
                                            ]),
                                          ),
                                          SizedBox(
                                            height: 280,
                                            width: context.width,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection:
                                                  Axis.horizontal,
                                              itemCount: restController
                                                  .recommendedProductModel!
                                                  .products!
                                                  .length,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              padding: const EdgeInsets
                                                  .only(
                                                  top: Dimensions
                                                      .paddingSizeExtraSmall,
                                                  // bottom: Dimensions
                                                  //     .paddingSizeExtraSmall,
                                                  right: Dimensions
                                                      .paddingSizeDefault),
                                              itemBuilder:
                                                  (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      left: Dimensions
                                                          .paddingSizeDefault),
                                                  child: ItemCardWidget(
                                                    product: restController
                                                        .recommendedProductModel!
                                                        .products![index],
                                                    isBestItem: false,
                                                    isPopularNearbyItem:
                                                        false,
                                                    width:  MediaQuery.of(context).size.width * 0.43,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ])
                                    : const SizedBox(),
                              ]),
                            ),
                          ),
                        ),
                        // (restController.categoryList!.isNotEmpty)
                        (restController.subCategoryList != null)
                            ? SliverPersistentHeader(
                                pinned: true,
                                delegate: SliverDelegate(
                                    height: 60,
                                    child: Center(
                                        child: Container(
                                      width: Dimensions.webMaxWidth,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.1),
                                                    spreadRadius: 1,
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 1)),
                                              ],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical:5),
                                      child: Column(children: [
                                        // Padding(
                                        //   padding: const EdgeInsets.only(
                                        //       left: Dimensions.paddingSizeLarge,
                                        //       right:
                                        //           Dimensions.paddingSizeLarge,
                                        //       top: Dimensions.paddingSizeSmall),
                                        //   child: Row(children: [
                                        //     Text('all_food_items'.tr,
                                        //         style: robotoBold.copyWith(
                                        //             fontSize: Dimensions
                                        //                 .fontSizeExtraLarge)),
                                        //     const Expanded(child: SizedBox()),
                                        //
                                        //     restController.type.isNotEmpty
                                        //         ? VegFilterWidget(
                                        //             type: restController.type,
                                        //             onSelected: (String type) {
                                        //               restController
                                        //                   .getRestaurantProductList(
                                        //                       restController
                                        //                           .restaurant!
                                        //                           .id,
                                        //                       1,
                                        //                       type,
                                        //                       true);
                                        //             },
                                        //           )
                                        //         : const SizedBox(),
                                        //   ]),
                                        // ),
                                        const Divider(
                                            thickness: 0.2, height: 10),
                                        SizedBox(
                                          height: 36,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            // itemCount: restController
                                            //     .categoryList!.length,
                                            itemCount: restController
                                                .subCategoryList!.length,
                                            padding: const EdgeInsets.only(
                                                left: Dimensions
                                                    .paddingSizeLarge),
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              // final data = restController
                                              //     .categoryList![index];
                                              final data = restController
                                                  .subCategoryList![index];
                                              return InkWell(
                                                onTap: () {
                                                  // restController
                                                  //     .setCategoryIndex(index);
                                                  restController
                                                      .setSubCategoryIndex(
                                                          index);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeSmall,
                                                      vertical: Dimensions
                                                          .paddingSizeExtraSmall
                                                  ),
                                                  margin: const EdgeInsets.only(
                                                      right: Dimensions
                                                          .paddingSizeSmall),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radiusDefault),
                                                    color: index ==
                                                            restController
                                                                .subCategoryIndex
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(0.1)
                                                        : Colors.transparent,
                                                  ),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          data.name!,
                                                          style: index ==
                                                                  restController
                                                                      .subCategoryIndex
                                                              ? robotoMedium.copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeDefault,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor)
                                                              : robotoRegular.copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeLarge),
                                                        ),
                                                      ]),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ]),
                                    ))),
                              )
                            : const SliverToBoxAdapter(child: SizedBox()),
                        SliverToBoxAdapter(
                            child: FooterViewWidget(
                          child: Center(
                              child: Container(
                            width: Dimensions.webMaxWidth,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                            ),
                            child: PaginatedListViewWidget(
                              scrollController: scrollController,
                              onPaginate: (int? offset) {
                                if (restController.isSearching) {
                                  restController.getRestaurantSearchProductList(
                                    restController.searchText,
                                    Get.find<RestaurantController>()
                                        .restaurant!
                                        .id
                                        .toString(),
                                    offset!,
                                    restController.type,
                                  );
                                } else {
                                  restController.getRestaurantProductList(
                                      Get.find<RestaurantController>()
                                          .restaurant!
                                          .id,
                                      offset!,
                                      restController.type,
                                      false);
                                }
                              },
                              totalSize: restController.isSearching
                                  ? restController
                                      .restaurantSearchProductModel?.totalSize
                                  : restController.restaurantProducts != null
                                      ? restController.foodPageSize
                                      : null,
                              offset: restController.isSearching
                                  ? restController
                                      .restaurantSearchProductModel?.offset
                                  : restController.restaurantProducts != null
                                      ? restController.foodPageOffset
                                      : null,
                              productView: ProductViewWidget(
                                isRestaurant: false,
                                restaurants: null,
                                products: restController.isSearching
                                    ? restController
                                        .restaurantSearchProductModel?.products
                                    : restController.subCategoryList != null
                                        // restController.categoryList!.isNotEmpty
                                        ? restController.restaurantProducts
                                        : null,
                                inRestaurantPage: true,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall,
                                  vertical: Dimensions.paddingSizeSmall,
                                ),
                              ),
                            ),
                          )),
                        )),
                      ],
                    )
                  : const RestaurantScreenShimmerWidget();
            });
          });
        }),
        bottomNavigationBar:
            GetBuilder<CartController>(builder: (cartController) {
          return cartController.cartList.isNotEmpty && ResponsiveHelper.isMobile(context)
              ? BottomCartWidget(
                  restaurantId:
                      cartController.cartList[0].product!.restaurantId!)
              : const SizedBox();
        }));
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;

  SliverDelegate({required this.child, this.height = 100});

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

// class CategoryProduct {
//   CategoryModel category;
//   List<Product> products;
//   CategoryProduct(this.category, this.products);
// }
