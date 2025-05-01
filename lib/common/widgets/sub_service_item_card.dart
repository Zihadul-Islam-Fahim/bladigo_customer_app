import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class SubServiceItemCard extends StatelessWidget {
  const SubServiceItemCard(
      {super.key,
      required this.imagePath,
      required this.label,
      this.isNetworkImage = true,
      this.filteredPage = false});

  final String imagePath;
  final String label;
  final bool isNetworkImage;
  final bool filteredPage;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0.0,
      color: Theme.of(context).brightness == Brightness.dark? Colors.black54 : Color(0xffE8F5E9),
      shadowColor: Colors.transparent,
      borderOnForeground: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              // color: label.tr == 'all'.tr
              //     ? Colors.grey.withOpacity(0.18)
              //     : Colors.transparent,
                color: ThemeMode.values ==  ThemeMode.dark ? Colors.black : Colors.transparent
            ),
            child: Padding(
              padding: filteredPage ? EdgeInsets.zero : EdgeInsets.all(8.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isNetworkImage
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CustomImageWidget(
                              image: imagePath,
                              height: ResponsiveHelper.isMobile(context)
                                  ? filteredPage
                                      ? 80
                                      : 62
                                  : 100,
                              placeholder: label == 'all'.tr ? Images.menu : '',
                              width: ResponsiveHelper.isMobile(context)
                                  ? label.tr == 'all'.tr
                                      ? 62
                                      : filteredPage
                                          ? 200
                                          : 60
                                  : 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              height:
                                  ResponsiveHelper.isMobile(context) ? 60 : 100,
                              // width: ResponsiveHelper.isMobile(context) ? 60 : 100,
                            ),
                          ),
                  ]),
            ),
          ),
          SizedBox(
              height: ResponsiveHelper.isMobile(context)
                  ? Dimensions.paddingSizeDefault - 10
                  : Dimensions.paddingSizeLarge),
          Text(
            label,
            style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeDefault,

            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
