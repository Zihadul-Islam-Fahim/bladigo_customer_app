import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/cart_widget.dart';
import 'package:stackfood_multivendor/common/widgets/veg_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final bool showCart;
  final Color? bgColor;
  final Function(String value)? onVegFilterTap;
  final String? type;
  const CustomAppBarWidget({super.key, required this.title, this.isBackButtonExist = true, this.onBackPressed,
    this.showCart = false, this.bgColor, this.onVegFilterTap, this.type});

  @override
  Widget build(BuildContext context) {
    return GetPlatform.isDesktop ? const WebMenuBar() : AppBar(
      title: Text(title, style: robotoMedium.copyWith(fontSize: 20, color: bgColor == null ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).cardColor)),
      centerTitle: true,
      leading: isBackButtonExist ? IconButton(
        icon: Container(
          width: 33,
          height: 33,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            // Rounded corners
            border: Border.all(
              color: Colors.black,
              width: 1.38,
            ),
          ),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
        ),
        color: bgColor == null ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).cardColor,
        onPressed: () => onBackPressed != null ? onBackPressed!() : Navigator.pop(context),
      ) : const SizedBox(),
      backgroundColor: bgColor ?? Theme.of(context).cardColor,
      surfaceTintColor: Theme.of(context).cardColor,
      shadowColor: Theme.of(context).disabledColor.withOpacity(0.5),
      elevation: 0,
      actions: showCart || onVegFilterTap != null ? [
        showCart ? IconButton(
          onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
          icon: CartWidget(color: Theme.of(context).textTheme.bodyLarge!.color, size: 25),
        ) : const SizedBox(),

        onVegFilterTap != null ? VegFilterWidget(
          type: type,
          onSelected: onVegFilterTap,
          fromAppBar: true,
        ) : const SizedBox(),
      ] : [const SizedBox()],
    );
  }

  @override
  Size get preferredSize => Size(Dimensions.webMaxWidth, GetPlatform.isDesktop ? 100 : 50);
}
