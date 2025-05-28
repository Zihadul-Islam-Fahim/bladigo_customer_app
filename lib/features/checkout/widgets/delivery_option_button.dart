import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:stackfood_multivendor/common/widgets/custom_tool_tip.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/custom_container_button.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryOptionButton extends StatelessWidget {
  final String value;
  final String title;
  final double? charge;
  final bool? isFree;
  final double total;
  final String? chargeForView;
  final JustTheController? deliveryFeeTooltipController;
  final double badWeatherCharge;
  final double extraChargeForToolTip;
  const DeliveryOptionButton(
      {super.key,
      required this.value,
      required this.title,
      required this.charge,
      required this.isFree,
      required this.total,
      this.chargeForView,
      this.deliveryFeeTooltipController,
      required this.badWeatherCharge,
      required this.extraChargeForToolTip});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (checkoutController) {
        bool select = checkoutController.orderType == value;
        return InkWell(
          onTap: () {
            checkoutController.setOrderType(value);
            checkoutController.setInstruction(-1);

            if (checkoutController.orderType == 'take_away') {
              checkoutController.addTips(0);
              if (checkoutController.isPartialPay ||
                  checkoutController.paymentMethodIndex == 1) {
                double tips = 0;
                try {
                  tips = double.parse(checkoutController.tipController.text);
                } catch (_) {}
                checkoutController.checkBalanceStatus(total,
                    discount: charge! + tips);
              }
            } else {
              checkoutController.updateTips(
                Get.find<AuthController>().getDmTipIndex().isNotEmpty
                    ? int.parse(Get.find<AuthController>().getDmTipIndex())
                    : 0,
                notify: false,
              );

              if (checkoutController.isPartialPay) {
                checkoutController.changePartialPayment();
              } else {
                checkoutController.setPaymentMethod(-1);
              }
            }
          },
          child: ResponsiveHelper.isDesktop(context)
              ? Container(
                  decoration: BoxDecoration(
                    color: select
                        ? Theme.of(context).cardColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    border: Border.all(
                        color: select
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).disabledColor,
                        width: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall,
                      vertical: Dimensions.paddingSizeSmall),
                  child: Row(
                    children: [
                      Radio(
                        value: value,
                        groupValue: checkoutController.orderType,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (String? value) {
                          checkoutController.setOrderType(value!);
                        },
                        activeColor: Theme.of(context).primaryColor,
                        visualDensity:
                            const VisualDensity(horizontal: -3, vertical: -3),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: robotoMedium.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color)),
                            Row(children: [
                              Text(
                                  value == 'delivery'
                                      ? '${'charge'.tr}: +$chargeForView'
                                      : 'free'.tr,
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color)),
                              const SizedBox(
                                  width: Dimensions.paddingSizeExtraSmall),
                              value == 'delivery' &&
                                      checkoutController.extraCharge != null &&
                                      (chargeForView! != '0') &&
                                      extraChargeForToolTip > 0
                                  ? CustomToolTip(
                                      message:
                                          '${'this_charge_include_extra_vehicle_charge'.tr} ${PriceConverter.convertPrice(extraChargeForToolTip)} ${badWeatherCharge > 0 ? '${'and_bad_weather_charge'.tr} ${PriceConverter.convertPrice(badWeatherCharge)}' : ''}',
                                      tooltipController:
                                          deliveryFeeTooltipController,
                                      preferredDirection: AxisDirection.right,
                                      child: const Icon(Icons.info,
                                          color: Colors.blue, size: 14),
                                    )
                                  : const SizedBox(),
                            ]),
                          ]),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      // Text(
                      //   '(${(value == 'take_away' || isFree!) ? 'free'.tr : charge != -1 ? PriceConverter.convertPrice(charge) : 'calculating'.tr})',
                      //   style: robotoMedium,
                      // ),
                    ],
                  ),
                )
              : CustomContainerCard(
                  svgAsset: value == 'delivery' ? Images.rider : Images.pickUp,
                  text: title,
                  onTap: () {
                    checkoutController.setOrderType(value);
                  },
                  iconColor: checkoutController.orderType == value
                      ? Theme.of(context).cardColor
                      : Theme.of(context).disabledColor,
                  boxColor: checkoutController.orderType == value
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  textColor: checkoutController.orderType == value
                      ? Theme.of(context).cardColor
                      : Theme.of(context).hintColor,
                ),
        );
      },
    );
  }

  Widget _buildTopButton(
      BuildContext context, Function() orderNowTap, Function() picUpTap) {
    return Padding(
      padding: EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomContainerCard(
            svgAsset: Images.rider,
            text: "Order Now",
            onTap: orderNowTap,
            boxColor: Theme.of(context).primaryColor,
            textColor: Theme.of(context).cardColor,
          ),
          CustomContainerCard(
            svgAsset: Images.pickUp,
            text: "Pick Up",
            onTap: picUpTap,
            boxColor: Theme.of(context).cardColor,
            textColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
