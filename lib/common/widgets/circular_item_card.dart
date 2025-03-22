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
      color:  Color(0xffE8F5E9),  // Color.fromRGBO(255, 255, 255, 1.0),
      shape: CircleBorder(),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
        //  color: Colors.black.withOpacity(0.065),
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
                        height: ResponsiveHelper.isMobile(context) ? 82 : 100,
                        width: ResponsiveHelper.isMobile(context) ? 98 : 100,
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
                  fontSize: Dimensions.fontSizeDefault,
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
