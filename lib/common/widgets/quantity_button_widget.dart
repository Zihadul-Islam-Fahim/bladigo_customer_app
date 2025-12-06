import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final Function()? onTap;
  final bool showRemoveIcon;
  final Color? color;
  const QuantityButton(
      {super.key,
      required this.isIncrement,
      required this.onTap,
      this.showRemoveIcon = false,
      this.color});

  @override
  Widget build(BuildContext context) {
    return CustomInkWellWidget(
      onTap: onTap ?? () {},
      child: Container(
        height: 35,
        width: 35,
        margin:
            const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // borderRadius: BorderRadius.circular(5),
          border: Border.all(
              width: 1,
              color: showRemoveIcon
                  ? Theme.of(context).primaryColor
                  : !isIncrement
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor),
          color: showRemoveIcon
              ? Theme.of(context).cardColor
              : isIncrement
                  ? color ?? Theme.of(context).primaryColor
                  : Theme.of(context).cardColor,
        ),
        alignment: Alignment.center,
        child: Icon(
          showRemoveIcon
              ? CupertinoIcons.trash
              : isIncrement
                  ? Icons.add
                  : Icons.remove,
          size: 22,
          color: showRemoveIcon
              ? Theme.of(context).colorScheme.error
              : isIncrement
                  ? Theme.of(context).cardColor
                  : Colors.black,
        ),
      ),
    );
  }
}
