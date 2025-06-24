import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';

import '../../../util/styles.dart';

class AppTileTitleBar extends StatelessWidget {
  const AppTileTitleBar({
    super.key,
    required this.title,
    this.onTap,
    this.showSeeAll = true,
    this.bottomPadding = 0,
    this.topPadding = 0,
    this.leftPadding = 0,
    this.rightPadding = 0,
  });

  final String title;
  final bool showSeeAll;
  final void Function()? onTap;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        bottom: bottomPadding,
        top: topPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            // crossAxisAlignment: WrapCrossAlignment.center,
            // spacing: 8,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8)),
                width: 4.5,
                height: 24,
              ),
              SizedBox(width: 5,),
              SizedBox(
                width: showSeeAll ? Get.width *0.72 : double.infinity,
                child: Text(title,
                    style: robotoBold.copyWith(
                        fontSize: Get.width * 0.05,
                        fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.fade,

                ),
              ),
            ],
          ),
          Visibility(
            visible: showSeeAll,
            child: TextButton(
                onPressed: onTap,
                child: Wrap(
                  spacing: 4,
                  children: [
                    Text(
                      'See all',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w300),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      weight: 0.5,
                    )
                  ],
                )),
          ),
          // ArrowIconButtonWidget(
          //     onTap: () => Get.toNamed(RouteHelper.getCategoryRoute())),
        ],
      ),
    );
  }
}



class AppTileTitleBar2 extends StatelessWidget {
  const AppTileTitleBar2({
    super.key,
    required this.title,
    this.onTap,
    this.showSeeAll = true,
    this.bottomPadding = 0,
    this.topPadding = 0,
    this.leftPadding = 0,
    this.rightPadding = 0,
  });

  final String title;
  final bool showSeeAll;
  final void Function()? onTap;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        bottom: bottomPadding,
        top: topPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              Container(

                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8)),
                width: 4.5,
                height: 24,
              ),
              SizedBox(
                width: Get.width* 0.7,
                child: Text(title,
                    style: robotoBold.copyWith(
                        fontSize: 23,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),

          // ArrowIconButtonWidget(
          //     onTap: () => Get.toNamed(RouteHelper.getCategoryRoute())),
        ],
      ),
    );
  }
}