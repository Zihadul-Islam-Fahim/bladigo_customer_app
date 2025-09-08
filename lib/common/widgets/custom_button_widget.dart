import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButtonWidget extends StatelessWidget {
  final Function? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double radius;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final bool isBold;
  final bool hasPrice;
  final String price;
  final int? productQuantity;
  const CustomButtonWidget({super.key,this.hasPrice = false,this.price="0", this.onPressed, required this.buttonText, this.transparent = false, this.margin, this.width, this.height = 55,
    this.fontSize=18, this.radius = Dimensions.radiusXExtraLarge, this.icon, this.color, this.textColor, this.isLoading = false, this.isBold = true, this.productQuantity});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null ? Theme.of(context).disabledColor.withOpacity(0.6) : transparent
          ? Colors.transparent : color ?? Theme.of(context).primaryColor,
      minimumSize: Size(width != null ? width! : Dimensions.webMaxWidth, height != null ? height! : 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
    );

    return Center(child: SizedBox(width: width ?? Dimensions.webMaxWidth, child: Padding(
      padding: margin == null ? const EdgeInsets.all(0) : margin!,
      child: TextButton(
        onPressed: isLoading ? null : onPressed as void Function()?,
        style: flatButtonStyle,
        child: isLoading ? Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 15, width: 15,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text('loading'.tr, style: robotoMedium.copyWith(color: Colors.white)),
        ]),
        ) : hasPrice ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buttonText == "showInCircle" ?

                Row(
                  children: [
                    Text("add".tr, textAlign: TextAlign.center, overflow: TextOverflow.fade,maxLines: 1, style: isBold ? robotoBold.copyWith(
                      color: textColor ?? (transparent ? Theme.of(context).primaryColor : Colors.white),
                      fontSize: fontSize ?? Dimensions.fontSizeLarge,
                    ) : robotoRegular.copyWith(
                      color: textColor ?? (transparent ? Theme.of(context).primaryColor : Colors.white),
                      fontSize: fontSize ?? Dimensions.fontSizeLarge,
                    )
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(productQuantity.toString(), textAlign: TextAlign.center, overflow: TextOverflow.fade,maxLines: 1, style: isBold ? robotoBold.copyWith(
                        color: textColor ?? ( Theme.of(context).primaryColor ),
                        fontSize: fontSize ?? Dimensions.fontSizeLarge,
                      ) : robotoRegular.copyWith(
                        color: textColor ?? (transparent ? Theme.of(context).primaryColor : Colors.black),
                        fontSize: fontSize ?? Dimensions.fontSizeLarge,
                      )
                      ),
                    ),
                    Text("for".tr, textAlign: TextAlign.center, overflow: TextOverflow.fade,maxLines: 1, style: isBold ? robotoBold.copyWith(
                      color: textColor ?? (transparent ? Theme.of(context).primaryColor : Colors.white),
                      fontSize: fontSize ?? Dimensions.fontSizeLarge,
                    ) : robotoRegular.copyWith(
                      color: textColor ?? (transparent ? Theme.of(context).primaryColor : Colors.white),
                      fontSize: fontSize ?? Dimensions.fontSizeLarge,
                    )
                    )
                  ],
                )


           : Text(buttonText, textAlign: TextAlign.center, overflow: TextOverflow.fade,maxLines: 1, style: isBold ? robotoBold.copyWith(
              color: textColor ?? (transparent ? Theme.of(context).primaryColor : Colors.white),
              fontSize: fontSize ?? Dimensions.fontSizeLarge,
            ) : robotoRegular.copyWith(
              color: textColor ?? (transparent ? Theme.of(context).primaryColor : Colors.white),
              fontSize: fontSize ?? Dimensions.fontSizeLarge,
            )
            ),
            Text(price, textAlign: TextAlign.center, overflow: TextOverflow.fade,maxLines: 1, style: isBold ? robotoBold.copyWith(
              color: textColor ?? (transparent ? Theme.of(context).primaryColor : Colors.white),
              fontSize: fontSize ?? Dimensions.fontSizeLarge,
            ) : robotoRegular.copyWith(
              color: textColor ?? (transparent ? Theme.of(context).primaryColor : Colors.white),
              fontSize: fontSize ?? Dimensions.fontSizeLarge,
            )
            )
          ],
        ): Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          icon != null ? Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
            child: Icon(icon, color: transparent ? Theme.of(context).primaryColor : Theme.of(context).cardColor),
          ) : const SizedBox(),
          Text(buttonText, textAlign: TextAlign.center, overflow: TextOverflow.fade,maxLines: 1, style: isBold ? robotoBold.copyWith(
              color: textColor ?? (transparent ? Theme.of(context).primaryColor : Colors.white),
              fontSize: fontSize ?? Dimensions.fontSizeLarge,
            ) : robotoRegular.copyWith(
              color: textColor ?? (transparent ? Theme.of(context).primaryColor : Colors.white),
              fontSize: fontSize ?? Dimensions.fontSizeLarge,
            )
          ),
        ]) ,
      ),
    )));
  }
}
