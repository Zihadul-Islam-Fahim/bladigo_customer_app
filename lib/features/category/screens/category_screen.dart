import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor/features/home/screens/filtered_services_screen.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryModel? parentCategory;
  const CategoryScreen({super.key, this.parentCategory});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController scrollController = ScrollController();
  List<CategoryModel>? _categories;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    final controller = Get.find<CategoryController>();
    if (widget.parentCategory != null) {
      await controller.getSubCategoryList(widget.parentCategory!.id.toString());
      _categories = [];
      _categories!.addAll(controller.subCategoryList ?? []);
    } else {
      await controller.getCategoryList(false);
      _categories = [];
      _categories!.addAll(controller.categoryList ?? []);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isSubCategory = widget.parentCategory != null ? true : false;
    return Scaffold(
      appBar: CustomAppBarWidget(
          title: isSubCategory
              ? widget.parentCategory!.name.toString()
              : 'categories'.tr),
      endDrawer: const MenuDrawerWidget(),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: FooterViewWidget(
              child: Column(
            children: [
              WebScreenTitleWidget(
                  title: isSubCategory
                      ? widget.parentCategory!.name.toString()
                      : 'categories'.tr),
              Center(
                  child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: GetBuilder<CategoryController>(builder: (catController) {
                  return _categories != null
                      ? _categories!.isNotEmpty
                          ? GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    ResponsiveHelper.isDesktop(context)
                                        ? 6
                                        : ResponsiveHelper.isTab(context)
                                            ? 4
                                            : 3,
                                childAspectRatio: (1 / 1),
                                mainAxisSpacing: Dimensions.paddingSizeSmall,
                                crossAxisSpacing: Dimensions.paddingSizeSmall,
                              ),
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeSmall),
                              itemCount: _categories!.length,
                              itemBuilder: (context, index) {
                                final data = _categories![index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[
                                              Get.isDarkMode ? 800 : 200]!,
                                          blurRadius: 5,
                                          spreadRadius: 1)
                                    ],
                                  ),
                                  child: CustomInkWellWidget(
                                    onTap: () {
                                      if (widget.parentCategory != null) {
                                        Get.toNamed(
                                          RouteHelper.getCategoryProductRoute(
                                            widget.parentCategory!.id,
                                            widget.parentCategory!.name
                                                .toString(),
                                          ),
                                          arguments: index,
                                        );
                                      } else {
                                        // Get.toNamed(
                                        //     RouteHelper.getCategoryProductRoute(
                                        //   data.id,
                                        //   data.name!,
                                        // ));
                                        Get.to(
                                          () => FilteredServicesScreen(
                                              category: data),
                                        );
                                      }
                                    },
                                    radius: Dimensions.radiusDefault,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusSmall),
                                            child: CustomImageWidget(
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                              image: '${data.imageFullUrl}',
                                            ),
                                          ),
                                          const SizedBox(
                                              height: Dimensions
                                                  .paddingSizeExtraSmall),
                                          Text(
                                            data.name!,
                                            textAlign: TextAlign.center,
                                            style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ]),
                                  ),
                                );
                              },
                            )
                          : NoDataScreen(title: 'no_category_found'.tr)
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                }),
              )),
            ],
          )),
        ),
      ),
    );
  }
}
