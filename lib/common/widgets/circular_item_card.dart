import 'package:flutter/material.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class CircularItemCard extends StatelessWidget {
  const CircularItemCard({
    super.key,
    required this.imagePath,
    required this.label,
    this.isNetworkImage = true,
  });

  final String imagePath;
  final String label;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: CircleBorder(),
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isNetworkImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomImageWidget(
                        image: imagePath,
                        height: ResponsiveHelper.isMobile(context) ? 62 : 100,
                        width: ResponsiveHelper.isMobile(context) ? 60 : 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        height: ResponsiveHelper.isMobile(context) ? 60 : 100,
                        // width: ResponsiveHelper.isMobile(context) ? 60 : 100,
                      ),
                    ),
              SizedBox(
                  height: ResponsiveHelper.isMobile(context)
                      ? Dimensions.paddingSizeDefault - 10
                      : Dimensions.paddingSizeLarge),
              Text(
                label,
                style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ]),
      ),
    );
  }
}
