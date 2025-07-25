import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/common/widgets/hover_widgets/app_tile_title_bar.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class WhatOnYourMindViewWidget extends StatelessWidget {
  const WhatOnYourMindViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(
            top: ResponsiveHelper.isMobile(context)
                ? 0
                : Dimensions.paddingSizeOverLarge,
            left: Get.find<LocalizationController>().isLtr
                ? Dimensions.paddingSizeExtraSmall
                : 0,
            right: Get.find<LocalizationController>().isLtr
                ? 0
                : Dimensions.paddingSizeExtraSmall,
            bottom: ResponsiveHelper.isMobile(context)
                ? 0
                : Dimensions.paddingSizeOverLarge,
          ),
          child: ResponsiveHelper.isDesktop(context)
              ? Text('what_on_your_mind'.tr,
                  style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      fontWeight: FontWeight.w600))
              : Padding(
                  padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeSmall,
                      right: Dimensions.paddingSizeDefault),
                  child: AppTileTitleBar(
                    title: 'what_on_your_mind'.tr,
                    onTap: () => Get.toNamed(RouteHelper.getCategoryRoute()),
                  ),
                ),
        ),
        SizedBox(
          height: ResponsiveHelper.isMobile(context) ? 260 : 300,
          child: categoryController.categoryList != null
              ? GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  clipBehavior: Clip.none,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.095,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
                  padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeDefault),
                  itemCount: categoryController.categoryList!.length > 10
                      ? 6
                      : categoryController.categoryList!.length,
                  itemBuilder: (context, index) {
                    if(index == 9) {
                      return ResponsiveHelper.isDesktop(context) ? Padding(
                        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeSmall),
                        child: Container(
                          width: 70,
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall, right: Dimensions.paddingSizeExtraSmall, top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              hoverColor: Colors.transparent,
                              onTap: () => Get.toNamed(RouteHelper.getCategoryRoute()),
                              child: Container(
                                height: 40, width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                                ),
                                child: Icon(Icons.arrow_forward, color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                        ),
                      ): const SizedBox();
                    }

                    return CustomInkWellWidget(
                      padding: EdgeInsets.zero,
                      onTap: () => Get.toNamed(
                        RouteHelper.getCategoryProductRoute(
                          categoryController.categoryList![index].id,
                          categoryController.categoryList![index].name!,
                        ),
                      ),
                      radius: 100,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: ResponsiveHelper.isMobile(context)
                                  ? 90
                                  : 100,
                              width: ResponsiveHelper.isMobile(context)
                                  ? 90
                                  : 100,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CustomImageWidget(
                                  image:
                                      '${categoryController.categoryList![index].imageFullUrl}',
                                  height: ResponsiveHelper.isMobile(context)
                                      ? 60
                                      : 100,
                                  width: ResponsiveHelper.isMobile(context)
                                      ? 60
                                      : 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                                height: ResponsiveHelper.isMobile(context)
                                    ? Dimensions.paddingSizeDefault - 12
                                    : Dimensions.paddingSizeLarge),
                            Text(
                              categoryController.categoryList![index].name!,
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ]),
                    );
                  },
                )
              : WebWhatOnYourMindViewShimmer(
                  categoryController: categoryController),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge - 12),
      ]);
    });
  }
}

class WebWhatOnYourMindViewShimmer extends StatelessWidget {
  final CategoryController categoryController;

  const WebWhatOnYourMindViewShimmer(
      {super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.isMobile(context) ? 120 : 170,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
                bottom: Dimensions.paddingSizeSmall,
                right: Dimensions.paddingSizeSmall,
                top: Dimensions.paddingSizeSmall),
            child: Container(
              width: ResponsiveHelper.isMobile(context) ? 70 : 108,
              height: ResponsiveHelper.isMobile(context) ? 70 : 100,
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              margin: EdgeInsets.only(
                  top: ResponsiveHelper.isMobile(context)
                      ? 0
                      : Dimensions.paddingSizeSmall),
              child: Column(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: Shimmer(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                          color: Theme.of(context).shadowColor),
                      height: ResponsiveHelper.isMobile(context) ? 70 : 80,
                      width: 70,
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: Shimmer(
                    child: Container(
                      height: ResponsiveHelper.isMobile(context) ? 10 : 15,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                          color: Theme.of(context).shadowColor),
                    ),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
