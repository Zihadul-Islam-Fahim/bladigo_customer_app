import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/common/widgets/circular_item_card.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/common/widgets/hover_widgets/app_tile_title_bar.dart';
import 'package:stackfood_multivendor/common/widgets/shimmer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/sub_service_item_card.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor/features/category/screens/category_product_screen.dart';
import 'package:stackfood_multivendor/features/home/widgets/home/home_screen_header.dart';
import 'package:stackfood_multivendor/features/mock_data/mock_data.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';

import '../../../common/widgets/custom_favourite_widget.dart';
import '../../../common/widgets/custom_image_widget.dart';
import '../../favourite/controllers/favourite_controller.dart';
import '../../language/controllers/localization_controller.dart';
import '../widgets/icon_with_text_row_widget.dart';

class FilteredServicesScreen extends StatefulWidget {
  const FilteredServicesScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  State<FilteredServicesScreen> createState() => _FilteredServicesScreenState();
}

class _FilteredServicesScreenState extends State<FilteredServicesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>()
        .getSubCategoryList(widget.category.id.toString());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //   Get.find<RestaurantController>()
      //       .getCategoryWiseRestaurantList(widget.category.id.toString());
      //
      Get.find<CategoryController>().getCategoryRestaurantList(
        widget.category.id.toString(),
        Get.find<CategoryController>().offset,
        Get.find<CategoryController>().type,
        true,
      );
      _scrollController.addListener(() {
        if (_scrollController.position.atEdge &&
            !_scrollController.position.pixels.isNegative) {
          Get.find<CategoryController>().getCategoryRestaurantList(
            widget.category.id.toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            true,
          );
        }
      });
    });
  }

  _reload() async {
    await Get.find<CategoryController>()
        .getSubCategoryList(widget.category.id.toString());
    // await Get.find<RestaurantController>()
    //     .getCategoryWiseRestaurantList(widget.category.id.toString());
    await Get.find<CategoryController>().getCategoryRestaurantList(
      widget.category.id.toString(),
      0, //scroll offset default 0 use
      Get.find<CategoryController>().type,
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _reload();
          },
          child: SingleChildScrollView(
            child: Column(
              // controller: _scrollController,
              // physics: AlwaysScrollableScrollPhysics(),
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
        
              children: [
                HomeScreenHeaderWidget(),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _searchBar(context),
                      // SizedBox(height: 9),
                      AppTileTitleBar(
                        title: widget.category.name.toString(),
                        onTap: () => Get.toNamed(RouteHelper.getCategoryRoute(),
                            arguments: widget.category),
                      ),
                      GetBuilder<CategoryController>(builder: (categoryController) {
                        return categoryController.subCategoryList != null &&
                                categoryController.subCategoryList!.isEmpty
                            ? SizedBox.shrink()
                            : SizedBox(
                                // height: ResponsiveHelper.isMobile(context)
                                //     ? 240
                                //     : 280,
                                child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                clipBehavior: Clip.none,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.96,
                                  crossAxisSpacing: 4,
                                ),
                                padding: const EdgeInsets.only(
                                    left: Dimensions.paddingSizeDefault),
                                itemCount: categoryController.subCategoryList !=
                                        null
                                    ? categoryController.subCategoryList!.length > 9
                                        ? 5
                                        : categoryController.subCategoryList!.length
                                    : 5,
                                itemBuilder: (context, index) {
                                  final data = categoryController.subCategoryList !=
                                          null
                                      ? categoryController.subCategoryList![index]
                                      : null;
                                  return categoryController.subCategoryList != null
                                      ? CustomInkWellWidget(
                                          padding: EdgeInsets.zero,
                                          radius: 8,
                                          highlightColor: Color(0xff2b9430),
                                          onTap: () => Get.toNamed(
                                            RouteHelper.getCategoryProductRoute(
                                              widget.category.id,
                                              widget.category.name.toString(),
                                            ),
                                            arguments: index,
                                          ),
                                          // radius: 68,
                                          child: SubServiceItemCard(
                                            isNetworkImage: true,
                                            filteredPage: true,
                                            imagePath: "${data?.imageFullUrl}",
                                            label: "${data?.name}",
                                          ),
                                        )
                                      : Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          elevation: 0.5,
                                          color: Colors.grey[100],
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ShimmerWidget.rectangular(
                                                height: ResponsiveHelper.isMobile(
                                                        context)
                                                    ? 70
                                                    : 110,
                                                width: ResponsiveHelper.isMobile(
                                                        context)
                                                    ? 80
                                                    : 110,
                                              ),
                                              SizedBox(
                                                  height: ResponsiveHelper.isMobile(
                                                          context)
                                                      ? Dimensions
                                                          .paddingSizeExtraSmall
                                                      : Dimensions
                                                          .paddingSizeLarge),
                                              ShimmerWidget.rectangular(
                                                height: 11,
                                                width: 50,
                                              ),
                                            ],
                                          ),
                                        );
                                },
                              ));
                      }),
                      SizedBox(height: Dimensions.paddingSizeDefault),
                      AppTileTitleBar2(
                        title: "All_Available_Restaurants".tr,
                        onTap: () => Get.toNamed(RouteHelper.getCategoryRoute(),
                            arguments: widget.category),
                      ),
                      SizedBox(height: Dimensions.paddingSizeDefault),
                      GetBuilder<CategoryController>(builder: (catController) {
                        return Column(
                          children: [
                            // if (restaturantController.categoryWiseRestaurantList ==
                            //         null ||
                            //     restaturantController.categoryWiseRestaurantList !=
                            //             null &&
                            //         restaturantController
                            //             .categoryWiseRestaurantList!.isNotEmpty)
                            //   AppTileTitleBar(
                            //     title: widget.category.name.toString(),
                            //     onTap: () {
                            //       CategoryProductScreen.tabIndex = 1;
                            //       Get.find<CategoryController>()
                            //           .setRestaurant(true);
                            //       Get.toNamed(
                            //         RouteHelper.getCategoryProductRoute(
                            //           widget.category.id,
                            //           widget.category.name.toString(),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            ListView.builder(
                              padding: EdgeInsets.only(top: 0, bottom: 0),
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (context, index) {
                                final data = catController.categoryRestaurantList ==
                                        null
                                    ? null
                                    : catController.categoryRestaurantList![index];
                                return catController.categoryRestaurantList != null
                                    ? FilteredItemCard(restaurant: data!)
                                    : _restaurentShimmerWidget(context);
                              },

                              itemCount: catController.categoryRestaurantList ==
                                      null
                                  ? 8
                                  : catController.categoryRestaurantList!.length,
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _restaurentShimmerWidget(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 108,
        child: Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: ShimmerWidget.rectangular(
                  width: 95,
                  height: 100,
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget.rectangular(height: 14),
                  SizedBox(height: 8),
                  ShimmerWidget.rectangular(height: 15),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      ShimmerWidget.rectangular(height: 12, width: 50),
                      SizedBox(width: 2),
                      ShimmerWidget.rectangular(height: 10, width: 80),
                    ],
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                      width: 70, child: ShimmerWidget.rectangular(height: 9)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: ShimmerWidget.rectangular(height: 9)),
                      SizedBox(width: 2),
                      Expanded(child: ShimmerWidget.rectangular(height: 9)),
                      SizedBox(width: 2),
                      Expanded(child: ShimmerWidget.rectangular(height: 9)),
                    ],
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(RouteHelper.getSearchRoute()),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              transform: Matrix4.translationValues(0, -3, 0),
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(25),
                  // border: Border.all(color: Theme.of(context).primaryColor)
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 2, top: 16, bottom: 16),
                child: Row(children: [
                  Image.asset(Images.searchIconNew, width: 16, height: 16),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Expanded(
                    child: Text("What_you_like_to".tr,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
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
    );
  }
}

class BlurredItemCard extends StatelessWidget {
  const BlurredItemCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double width = 164;
    return Stack(
      children: [
        _containerBg(width),
        Positioned(
          top: 0,
          child: Container(
            margin: EdgeInsets.only(left: 12),
            padding: EdgeInsets.only(left: 6, right: 6, top: 10, bottom: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                )),
            child: Text(
              '\$40 OFF',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 7),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: BlurryContainer(
            blur: 4,
            height: 94,
            width: width,
            color: Colors.transparent,
            padding: const EdgeInsets.all(8),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: _cardContent(context),
          ),
        ),
      ],
    );
  }

  Widget _cardContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Meat Pizza',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            Icon(Icons.favorite_border, color: Colors.white)
          ],
        ),
        SizedBox(height: 2),
        _ratingSection(context),
        SizedBox(height: 2),
        _priceAndAddToCardSection(context),
      ],
    );
  }

  Widget _priceAndAddToCardSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '\$ 370.00',
          style: TextStyle(
              fontSize: 8.5, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        Icon(
          Icons.add_circle,
          color: Theme.of(context).primaryColor,
        )
      ],
    );
  }

  Widget _ratingSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(48),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 2,
          bottom: 2,
        ),
        child: Text(
          '4.3 ⭐',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _containerBg(double width) {
    return Container(
      height: 216,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage('assets/image/shaearma.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class FilteredItemCard extends StatefulWidget {
  const FilteredItemCard({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  State<FilteredItemCard> createState() => _FilteredItemCardState();
}

class _FilteredItemCardState extends State<FilteredItemCard> {


  @override
  Widget build(BuildContext context) {

   final restController = Get.find<RestaurantController>();
   bool isAvailable = widget.restaurant.open == 1 && widget.restaurant.active!;
   String characteristics = '';
   if(widget.restaurant.characteristics != null) {

       characteristics = '$characteristics${characteristics.isNotEmpty ? ', ' : ''}';

   }
    return CustomInkWellWidget(
      onTap: () => Get.toNamed(
        RouteHelper.getRestaurantRoute(widget.restaurant.id),
        arguments: RestaurantScreen(restaurant: widget.restaurant),
      ),
      radius: 8,
      child: SizedBox(
        // height: 260,
        child:  Padding(
              padding: EdgeInsets.only(left:  0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(

                    height: 195,
                    // width: ResponsiveHelper.isDesktop(context) ? 253 : MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: CustomInkWellWidget(
                      onTap: () => Get.toNamed(RouteHelper.getRestaurantRoute(widget.restaurant.id),
                        arguments: RestaurantScreen(restaurant: widget.restaurant),
                      ),
                      radius: Dimensions.radiusDefault,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            height: 250, width: ResponsiveHelper.isDesktop(context) ? 253 : MediaQuery.of(context).size.width * 0.95,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all( Radius.circular(Dimensions.radiusExtraLarge),),
                              child: Stack(
                                children: [
                                  CustomImageWidget(
                                    image: '${widget.restaurant.coverPhotoFullUrl}',
                                    fit: BoxFit.cover, height: 250, width: ResponsiveHelper.isDesktop(context) ? 253 : MediaQuery.of(context).size.width * 0.92,
                                    isRestaurant: true,

                                  ),

                                  !isAvailable ? Positioned(
                                    top: 0, left: 0, right: 0, bottom: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                    ),
                                  ) : const SizedBox(),
                                ],
                              ),
                            ),
                          ),

                          !isAvailable ? Positioned(top: 30, left: 60, child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(Dimensions.radiusLarge)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.fontSizeExtraLarge, vertical: Dimensions.paddingSizeExtraSmall),
                            child: Row(children: [
                              Icon(Icons.access_time, size: 12, color: Theme.of(context).cardColor),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Text('closed_now'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall)),
                            ]),
                          )) : const SizedBox(),

                          Positioned(
                            top: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
                            child: GetBuilder<FavouriteController>(builder: (favouriteController) {
                              bool isWished = favouriteController.wishRestIdList.contains(widget.restaurant.id);
                              return CustomFavouriteWidget(
                                isWished: isWished,
                                isRestaurant: true,
                                restaurant: widget.restaurant,
                              );
                            }
                            ),
                          ),

                          Positioned(
                            bottom: 20, right: 10,
                            child: Container(
                              height: 23,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all( Radius.circular(Dimensions.radiusDefault)),
                                color: Theme.of(context).cardColor,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                              child: Center(
                                child: Text( '${restController.getRestaurantDistance(
                                  LatLng(double.parse(widget.restaurant.latitude!), double.parse(widget.restaurant.longitude!)),
                                ).toStringAsFixed(2)} ${'km'.tr}',
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black),
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            top: 15, left: Dimensions.paddingSizeSmall,
                            child: Container(
                              height: 65, width: 65,
                              decoration:  BoxDecoration(
                                color: Theme.of(context).cardColor,
                                border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.1), width: 3),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                child: CustomImageWidget(
                                  image: '${widget.restaurant.logoFullUrl}',
                                  fit: BoxFit.cover, height: 65, width: 65,
                                  isRestaurant: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    // height: 23,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(  Radius.circular(Dimensions.radiusDefault)),
                        color: Theme.of(context).cardColor,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      // margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(widget.restaurant.name!, overflow: TextOverflow.ellipsis, maxLines: 1, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge1)),
                          characteristics == "" ? SizedBox.shrink() :Text(
                            characteristics,
                            overflow: TextOverflow.ellipsis, maxLines: 1,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                          ),
                        ],
                      )),

                  Container(
                    // height: 23,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all( Radius.circular(Dimensions.radiusDefault), ),
                      color: Theme.of(context).cardColor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        widget.restaurant.ratingCount! > 0 ? IconWithTextRowWidget(
                          icon: Icons.star,
                          text: widget.restaurant.avgRating!.toStringAsFixed(1),
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ) : const SizedBox(),
                        SizedBox(width: widget.restaurant.ratingCount! > 0 ? Dimensions.paddingSizeDefault : 0),


                        IconWithTextRowWidget(
                          icon: Icons.access_time_outlined,
                          text: '${widget.restaurant.deliveryTime}',
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),

                      ],
                    ),
                  ),
                  widget.restaurant.freeDelivery! ? Container(
                    height: 23,
                    // width: 120,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all( Radius.circular(Dimensions.radiusDefault), ),
                      // color: Colors.yellow,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    child: ImageWithTextRowWidget(
                      widget: Image.asset(
                          Images.deliveryIcon, height: 20,
                          width: 20),
                      text: 'free_delivery'.tr,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall),
                    ),
                  )
                      : const SizedBox(),
                  SizedBox(height: 12,)


                ],
              ),
            )
      ),
    );
  }




  Widget _iconLabel({
    required IconData icon,
    required String label,
    Color? iconColor,
    Color? textColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: iconColor ?? Theme.of(context).primaryColor,
          size: 14,
        ),
        SizedBox(width: 2),
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w400,
            fontSize: 12.33,
          ),
        )
      ],
    );
  }
}
