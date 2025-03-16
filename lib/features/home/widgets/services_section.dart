import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:stackfood_multivendor/common/widgets/circular_item_card.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/common/widgets/hover_widgets/app_tile_title_bar.dart';
import 'package:stackfood_multivendor/common/widgets/shimmer_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/home/screens/filtered_services_screen.dart';
import 'package:stackfood_multivendor/features/mock_data/mock_data.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 12),
        child: AppTileTitleBar(
          title: 'All Services'.tr,
          onTap: () => Get.toNamed(RouteHelper.getCategoryRoute()),
        ),
      ),
      GetBuilder<CategoryController>(builder: (categoryController) {
        return SizedBox(
            // height: ResponsiveHelper.isMobile(context) ? 260 : 300,
            child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          clipBehavior: Clip.none,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.98,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2),
          padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
          itemCount: categoryController.categoryList != null
              ? categoryController.categoryList!.length > 8
                  ? 9
                  : categoryController.categoryList!.length
              : 6,
          itemBuilder: (context, index) {
            final data = categoryController.categoryList != null
                ? categoryController.categoryList![index]
                : null;
            return categoryController.categoryList != null
                ? CustomInkWellWidget(
                    padding: EdgeInsets.zero,
                    highlightColor: Color(0xff2b9430),
                    onTap: () {
                      Get.to(
                        () => FilteredServicesScreen(category: data!),
                      );
                    },
                    radius: 68,
                    child: CircularItemCard(
                      isNetworkImage: true,
                      imagePath: "${data?.imageFullUrl}",
                      label: "${data?.name}",
                    ),
                  )
                : Card(
                    shape: CircleBorder(),
                    elevation: 8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShimmerWidget.circular(
                          height: ResponsiveHelper.isMobile(context) ? 80 : 120,
                          width: ResponsiveHelper.isMobile(context) ? 80 : 120,
                        ),
                        SizedBox(
                            height: ResponsiveHelper.isMobile(context)
                                ? Dimensions.paddingSizeDefault - 10
                                : Dimensions.paddingSizeLarge),
                        ShimmerWidget.rectangular(
                          height: 12,
                          width: 25,
                        ),
                      ],
                    ),
                  );
          },
        ));
      }),
      const SizedBox(height: Dimensions.paddingSizeLarge - 12),
    ]);
  }
}
